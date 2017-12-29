Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:34494 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdL2NKy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 08:10:54 -0500
Date: Fri, 29 Dec 2017 14:10:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "Ailus, Sakari" <sakari.ailus@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: IRQ behaivour has been changed from v4.14 to v4.15-rc1
In-Reply-To: <1514549171.7000.512.camel@linux.intel.com>
Message-ID: <alpine.DEB.2.20.1712291409460.1899@nanos>
References: <1514481444.7000.451.camel@intel.com>   <alpine.DEB.2.20.1712281820040.1899@nanos>   <1514482448.7000.460.camel@linux.intel.com>   <alpine.DEB.2.20.1712281834520.1899@nanos>   <1514489471.7000.463.camel@linux.intel.com>   <alpine.DEB.2.20.1712282117160.1899@nanos>
  <1514495025.7000.484.camel@linux.intel.com>  <alpine.DEB.2.20.1712282218080.1899@nanos>  <alpine.DEB.2.20.1712282256240.1899@nanos> <1514549171.7000.512.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 29 Dec 2017, Andy Shevchenko wrote:

> On Thu, 2017-12-28 at 22:59 +0100, Thomas Gleixner wrote:
> > On Thu, 28 Dec 2017, Thomas Gleixner wrote:
> > > On Thu, 28 Dec 2017, Andy Shevchenko wrote:
> 
> > > > The result w/o above is (full log is available here
> > > > https://pastebin.com
> > > > /J5yaTbM9):
> > > 
> > > Ok. Which irqs are related to that ISP thingy?
> > > 
> > > Are these interrupts MSI?
> 
> Yes, they are MSI.
> 
> > And looking at the log, I see that you can load the driver
> > successfully and
> > the trouble starts afterwards when you actually use it.
> 
> Correct.
> 
> > Can you please enable CONFIG_GENERIC_IRQ_DEBUGFS and after login,
> > check
> > which interrupt is assigned to that atomisp thingy and then provide
> > the
> > output of
> > 
> > cat /sys/kernel/debug/irq/irqs/$ATOMISPIRQ
> 
> Full log, including output of the above.
> 
> https://pastebin.com/4jammqi5

Thanks for the info. Can you please test the patch below?

Thanks,

	tglx

8<--------------------
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -339,6 +339,40 @@ int msi_domain_populate_irqs(struct irq_
 	return ret;
 }
 
+/*
+ * Carefully check whether the device can use reservation mode. If
+ * reservation mode is enabled then the early activation will assign a
+ * dummy vector to the device. If the PCI/MSI device does not support
+ * masking of the entry then this can result in spurious interrupts when
+ * the device driver is not absolutely careful. But even then a malfunction
+ * of the hardware could result in a spurious interrupt on the dummy vector
+ * and render the device unusable. If the entry can be masked then the core
+ * logic will prevent the spurious interrupt and reservation mode can be
+ * used. For now reservation mode is restricted to PCI/MSI.
+ */
+static bool msi_check_reservation_mode(struct irq_domain *domain,
+				       struct msi_domain_info *info,
+				       struct device *dev)
+{
+	struct msi_desc *desc;
+
+	if (domain->bus_token != DOMAIN_BUS_PCI_MSI)
+		return false;
+
+	if (!(info->flags & MSI_FLAG_MUST_REACTIVATE))
+		return false;
+
+	if (IS_ENABLED(CONFIG_PCI_MSI) && pci_msi_ignore_mask)
+		return false;
+
+	/*
+	 * Checking the first MSI descriptor is sufficient. MSIX supports
+	 * masking and MSI does so when the maskbit is set.
+	 */
+	desc = first_msi_entry(dev);
+	return desc->msi_attrib.is_msix || desc->msi_attrib.maskbit;
+}
+
 /**
  * msi_domain_alloc_irqs - Allocate interrupts from a MSI interrupt domain
  * @domain:	The domain to allocate from
@@ -353,9 +387,11 @@ int msi_domain_alloc_irqs(struct irq_dom
 {
 	struct msi_domain_info *info = domain->host_data;
 	struct msi_domain_ops *ops = info->ops;
-	msi_alloc_info_t arg;
+	struct irq_data *irq_data;
 	struct msi_desc *desc;
+	msi_alloc_info_t arg;
 	int i, ret, virq;
+	bool can_reserve;
 
 	ret = msi_domain_prepare_irqs(domain, dev, nvec, &arg);
 	if (ret)
@@ -385,6 +421,8 @@ int msi_domain_alloc_irqs(struct irq_dom
 	if (ops->msi_finish)
 		ops->msi_finish(&arg, 0);
 
+	can_reserve = msi_check_reservation_mode(domain, info, dev);
+
 	for_each_msi_entry(desc, dev) {
 		virq = desc->irq;
 		if (desc->nvec_used == 1)
@@ -397,17 +435,28 @@ int msi_domain_alloc_irqs(struct irq_dom
 		 * the MSI entries before the PCI layer enables MSI in the
 		 * card. Otherwise the card latches a random msi message.
 		 */
-		if (info->flags & MSI_FLAG_ACTIVATE_EARLY) {
-			struct irq_data *irq_data;
+		if (!(info->flags & MSI_FLAG_ACTIVATE_EARLY))
+			continue;
 
+		irq_data = irq_domain_get_irq_data(domain, desc->irq);
+		if (!can_reserve)
+			irqd_clr_can_reserve(irq_data);
+		ret = irq_domain_activate_irq(irq_data, can_reserve);
+		if (ret)
+			goto cleanup;
+	}
+
+	/*
+	 * If these interrupts use reservation mode clear the activated bit
+	 * so request_irq() will assign the final vector.
+	 */
+	if (can_reserve) {
+		for_each_msi_entry(desc, dev) {
 			irq_data = irq_domain_get_irq_data(domain, desc->irq);
-			ret = irq_domain_activate_irq(irq_data, true);
-			if (ret)
-				goto cleanup;
-			if (info->flags & MSI_FLAG_MUST_REACTIVATE)
-				irqd_clr_activated(irq_data);
+			irqd_clr_activated(irq_data);
 		}
 	}
+
 	return 0;
 
 cleanup:
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -184,6 +184,7 @@ static void reserve_irq_vector_locked(st
 	irq_matrix_reserve(vector_matrix);
 	apicd->can_reserve = true;
 	apicd->has_reserved = true;
+	irqd_set_can_reserve(irqd);
 	trace_vector_reserve(irqd->irq, 0);
 	vector_assign_managed_shutdown(irqd);
 }
@@ -368,8 +369,18 @@ static int activate_reserved(struct irq_
 	int ret;
 
 	ret = assign_irq_vector_any_locked(irqd);
-	if (!ret)
+	if (!ret) {
 		apicd->has_reserved = false;
+		/*
+		 * Core might have disabled reservation mode after
+		 * allocating the irq descriptor. Ideally this should
+		 * happen before allocation time, but that would require
+		 * completely convoluted ways of transporting that
+		 * information.
+		 */
+		if (!irqd_can_reserve(irqd))
+			apicd->can_reserve = false;
+	}
 	return ret;
 }
 
@@ -478,6 +489,7 @@ static bool vector_configure_legacy(unsi
 	} else {
 		/* Release the vector */
 		apicd->can_reserve = true;
+		irqd_set_can_reserve(irqd);
 		clear_irq_vector(irqd);
 		realloc = true;
 	}
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -212,6 +212,7 @@ struct irq_data {
  *				  mask. Applies only to affinity managed irqs.
  * IRQD_SINGLE_TARGET		- IRQ allows only a single affinity target
  * IRQD_DEFAULT_TRIGGER_SET	- Expected trigger already been set
+ * IRQD_CAN_RESERVE		- Can use reservation mode
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -233,6 +234,7 @@ enum {
 	IRQD_MANAGED_SHUTDOWN		= (1 << 23),
 	IRQD_SINGLE_TARGET		= (1 << 24),
 	IRQD_DEFAULT_TRIGGER_SET	= (1 << 25),
+	IRQD_CAN_RESERVE		= (1 << 26),
 };
 
 #define __irqd_to_state(d) ACCESS_PRIVATE((d)->common, state_use_accessors)
@@ -377,6 +379,21 @@ static inline bool irqd_is_managed_and_s
 	return __irqd_to_state(d) & IRQD_MANAGED_SHUTDOWN;
 }
 
+static inline void irqd_set_can_reserve(struct irq_data *d)
+{
+	__irqd_to_state(d) |= IRQD_CAN_RESERVE;
+}
+
+static inline void irqd_clr_can_reserve(struct irq_data *d)
+{
+	__irqd_to_state(d) &= ~IRQD_CAN_RESERVE;
+}
+
+static inline bool irqd_can_reserve(struct irq_data *d)
+{
+	return __irqd_to_state(d) & IRQD_CAN_RESERVE;
+}
+
 #undef __irqd_to_state
 
 static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
--- a/kernel/irq/debugfs.c
+++ b/kernel/irq/debugfs.c
@@ -113,6 +113,7 @@ static const struct irq_bit_descr irqdat
 	BIT_MASK_DESCR(IRQD_SETAFFINITY_PENDING),
 	BIT_MASK_DESCR(IRQD_AFFINITY_MANAGED),
 	BIT_MASK_DESCR(IRQD_MANAGED_SHUTDOWN),
+	BIT_MASK_DESCR(IRQD_CAN_RESERVE),
 
 	BIT_MASK_DESCR(IRQD_FORWARDED_TO_VCPU),
 
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -151,7 +151,7 @@ static struct apic apic_flat __ro_after_
 	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= flat_apic_id_registered,
 
-	.irq_delivery_mode		= dest_LowestPrio,
+	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 1, /* logical */
 
 	.disable_esr			= 0,
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -110,7 +110,7 @@ struct apic apic_noop __ro_after_init =
 	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= noop_apic_id_registered,
 
-	.irq_delivery_mode		= dest_LowestPrio,
+	.irq_delivery_mode		= dest_Fixed,
 	/* logical delivery broadcast to all CPUs: */
 	.irq_dest_mode			= 1,
 
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -39,17 +39,13 @@ static void irq_msi_compose_msg(struct i
 		((apic->irq_dest_mode == 0) ?
 			MSI_ADDR_DEST_MODE_PHYSICAL :
 			MSI_ADDR_DEST_MODE_LOGICAL) |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			MSI_ADDR_REDIRECTION_CPU :
-			MSI_ADDR_REDIRECTION_LOWPRI) |
+		MSI_ADDR_REDIRECTION_CPU |
 		MSI_ADDR_DEST_ID(cfg->dest_apicid);
 
 	msg->data =
 		MSI_DATA_TRIGGER_EDGE |
 		MSI_DATA_LEVEL_ASSERT |
-		((apic->irq_delivery_mode != dest_LowestPrio) ?
-			MSI_DATA_DELIVERY_FIXED :
-			MSI_DATA_DELIVERY_LOWPRI) |
+		MSI_DATA_DELIVERY_FIXED |
 		MSI_DATA_VECTOR(cfg->vector);
 }
 
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -105,7 +105,7 @@ static struct apic apic_default __ro_aft
 	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= default_apic_id_registered,
 
-	.irq_delivery_mode		= dest_LowestPrio,
+	.irq_delivery_mode		= dest_Fixed,
 	/* logical delivery broadcast to all CPUs: */
 	.irq_dest_mode			= 1,
 
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -184,7 +184,7 @@ static struct apic apic_x2apic_cluster _
 	.apic_id_valid			= x2apic_apic_id_valid,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
-	.irq_delivery_mode		= dest_LowestPrio,
+	.irq_delivery_mode		= dest_Fixed,
 	.irq_dest_mode			= 1, /* logical */
 
 	.disable_esr			= 0,
--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -985,9 +985,7 @@ static u32 hv_compose_msi_req_v1(
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
 	int_pkt->int_desc.vector_count = 1;
-	int_pkt->int_desc.delivery_mode =
-		(apic->irq_delivery_mode == dest_LowestPrio) ?
-			dest_LowestPrio : dest_Fixed;
+	int_pkt->int_desc.delivery_mode = dest_Fixed;
 
 	/*
 	 * Create MSI w/ dummy vCPU set, overwritten by subsequent retarget in
@@ -1008,9 +1006,7 @@ static u32 hv_compose_msi_req_v2(
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
 	int_pkt->int_desc.vector_count = 1;
-	int_pkt->int_desc.delivery_mode =
-		(apic->irq_delivery_mode == dest_LowestPrio) ?
-			dest_LowestPrio : dest_Fixed;
+	int_pkt->int_desc.delivery_mode = dest_Fixed;
 
 	/*
 	 * Create MSI w/ dummy vCPU set targeting just one vCPU, overwritten
