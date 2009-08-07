Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n77B4tcI003344
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 07:04:55 -0400
Received: from mail-ew0-f208.google.com (mail-ew0-f208.google.com
	[209.85.219.208])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n77B4d6o005918
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 07:04:39 -0400
Received: by ewy4 with SMTP id 4so346912ewy.3
	for <video4linux-list@redhat.com>; Fri, 07 Aug 2009 04:04:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eedb5540908070303t325d8573o9b8b85301238ecd5@mail.gmail.com>
References: <eedb5540908070134i3e94cddbv358ab6190b482715@mail.gmail.com>
	<eedb5540908070303t325d8573o9b8b85301238ecd5@mail.gmail.com>
Date: Fri, 7 Aug 2009 13:04:38 +0200
Message-ID: <eedb5540908070404m51be7773t5537c9b9a1de1aa4@mail.gmail.com>
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Russell King <linux@arm.linux.org.uk>, video4linux-list@redhat.com
Subject: Re: [PATCH] MX2x: Add CSI platform device and resources.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This patch would we for the case that csi and prp are considered as a
single device, which is the option I think it's more adjusted to the
v4l capture model. It's like the i.mx31 case where CSI is integrate
inside the IPU.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-mx2/devices.c |   48 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-mx2/devices.h |    1 +
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx2/devices.c b/arch/arm/mach-mx2/devices.c
index 4e7feea..ac46a3a 100644
--- a/arch/arm/mach-mx2/devices.c
+++ b/arch/arm/mach-mx2/devices.c
@@ -39,6 +39,54 @@

 #include "devices.h"

+
+static struct resource mxc_csi_prp_resources[] = {
+	[0] = {
+		.start  = CSI_BASE_ADDR,
+		.end    = CSI_BASE_ADDR + 0x1f,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= EMMA_PRP_BASE_ADDR,
+		.end	= EMMA_PRP_BASE_ADDR + 0x83,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start  = MXC_INT_CSI,
+		.end    = MXC_INT_CSI,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[3] = {
+		.start	= MXC_INT_EMMAPRP,
+		.end	= MXC_INT_EMMAPRP,
+		.flags	= IORESOURCE_IRQ,
+	},
+	[4] = {
+		.start  = DMA_REQ_CSI_RX,
+		.end    = DMA_REQ_CSI_RX,
+		.flags  = IORESOURCE_DMA
+	},
+	[5] = {
+		.start  = DMA_REQ_CSI_STAT,
+		.end    = DMA_REQ_CSI_STAT,
+		.flags  = IORESOURCE_DMA
+	},
+};
+
+static u64 mxc_csi_prp_dmamask = 0xffffffffUL;
+
+struct platform_device mxc_csi_prp_device = {
+	.name           = "mxc-camera",
+	.id             = 0,
+	.dev		= {
+		.dma_mask = &mxc_csi_prp_dmamask,
+		.coherent_dma_mask = 0xffffffff,
+	},
+	.resource       = mxc_csi_prp_resources,
+	.num_resources  = ARRAY_SIZE(mxc_csi_prp_resources),
+};
+
+
 /*
  * Resource definition for the MXC IrDA
  */
diff --git a/arch/arm/mach-mx2/devices.h b/arch/arm/mach-mx2/devices.h
index facb4d6..abeb2c9 100644
--- a/arch/arm/mach-mx2/devices.h
+++ b/arch/arm/mach-mx2/devices.h
@@ -1,3 +1,4 @@
+extern struct platform_device mxc_csi_prp_device;
 extern struct platform_device mxc_gpt1;
 extern struct platform_device mxc_gpt2;
 extern struct platform_device mxc_gpt3;
---
Please comment.

Thank you.
-- 
Javier Martin
Vista Silicon S.L.
Universidad de Cantabria
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
