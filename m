Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailfe15.tele2.it ([212.247.155.205] helo=swip.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nsoranzo@tiscali.it>) id 1LK1pK-0006Yj-Qa
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 03:37:56 +0100
Received: from [93.145.255.150] (account cxu-8be-dgf@tele2.it HELO
	ozzy.localnet) by mailfe15.swip.net (CommuniGate Pro SMTP 5.2.6)
	with ESMTPA id 429922144 for linux-dvb@linuxtv.org;
	Tue, 06 Jan 2009 03:37:29 +0100
To: linux-dvb@linuxtv.org
Content-Disposition: inline
From: Nicola Soranzo <nsoranzo@tiscali.it>
Date: Tue, 6 Jan 2009 03:37:29 +0100
MIME-Version: 1.0
Message-Id: <200901060337.29267.nsoranzo@tiscali.it>
Subject: [linux-dvb] [PATCH] Re: Compile error,
	bug in compat.h with kernel 2.6.27.9 ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Fix compile error about ioremap_nocache with kernel 2.6.27.9 shipped by Fedora 
10.

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>

---

diff -urN v4l-dvb-8f3a8d9d0f7c/v4l/compat.h v4l-dvb-new/v4l/compat.h
--- v4l-dvb-8f3a8d9d0f7c/v4l/compat.h	2009-01-06 01:33:58.000000000 +0100
+++ v4l-dvb-new/v4l/compat.h	2009-01-05 21:34:05.000000000 +0100
@@ -270,10 +270,6 @@
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 28)
 #define snd_BUG_ON(cond)	WARN((cond), "BUG? (%s)\n", __stringify(cond))
-
-#define pci_ioremap_bar(pci, a)				\
-	 ioremap_nocache(pci_resource_start(pci, a),	\
-			 pci_resource_len(pci, a))
 #endif
 
 #ifndef PCI_DEVICE_ID_MARVELL_88ALP01_CCIC
@@ -410,5 +406,11 @@
 #define netdev_priv(dev)	((dev)->priv)
 #endif
 
+#ifdef NEED_PCI_IOREMAP_BAR
+#define pci_ioremap_bar(struct pci_dev *pdev, int bar) \
+	 ioremap_nocache(pci_resource_start(pdev, bar),	\
+			 pci_resource_len(pdev, bar))
+#endif
+
 
 #endif
diff -urN v4l-dvb-8f3a8d9d0f7c/v4l/scripts/make_config_compat.pl v4l-dvb-
new/v4l/scripts/make_config_compat.pl
--- v4l-dvb-8f3a8d9d0f7c/v4l/scripts/make_config_compat.pl	2009-01-06 
01:33:58.000000000 +0100
+++ v4l-dvb-new/v4l/scripts/make_config_compat.pl	2009-01-05 21:24:47.000000000 
+0100
@@ -235,6 +235,25 @@
 	close INNET;
 }
 
+sub check_pci_ioremap_bar()
+{
+	my $file = "$kdir/include/linux/pci.h";
+	my $need_compat = 1;
+
+	open INNET, "<$file" or die "File not found: $file";
+	while (<INNET>) {
+		if (m/pci_ioremap_bar/) {
+			$need_compat = 0;
+			last;
+		}
+	}
+
+	if ($need_compat) {
+		$out.= "\n#define NEED_PCI_IOREMAP_BAR 1\n";
+	}
+	close INNET;
+}
+
 sub check_other_dependencies()
 {
 	check_spin_lock();
@@ -249,6 +268,7 @@
 	check_algo_control();
 	check_net_dev();
 	check_usb_endpoint_type();
+	check_pci_ioremap_bar();
 }
 
 # Do the basic rules



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
