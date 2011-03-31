Return-path: <mchehab@pedra>
Received: from canardo.mork.no ([148.122.252.1]:44134 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab1CaMuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 08:50:13 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org, Jos Hoekstra <joshoekstra@gmx.net>
Subject: Re: Technisat Cablestar HD2 not automatically detected by kernel > 2.6.33?
References: <4D9390FA.9040402@gmx.net>
Date: Thu, 31 Mar 2011 14:32:08 +0200
In-Reply-To: <4D9390FA.9040402@gmx.net> (Jos Hoekstra's message of "Wed, 30
	Mar 2011 22:22:18 +0200")
Message-ID: <8762qz79o7.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jos Hoekstra <joshoekstra@gmx.net> writes:

> I got this card and it doesn't seem to be detected by Ubuntu 10.4.2
> with kernel 2.6.35(-25-generic #44~lucid1-Ubuntu SMP Tue Jan 25
> 19:17:25 UTC 2011 x86_64 GNU/Linux)
>
> The wiki seems to indicate that this card is supported as of kernel
> 2.6.33, however it doesn't show up as a dvb-adapter.
[..]
> After rebooting it however seems I need to manually modprobe mantis
> and restart the backend to have mythtv work with this card. Is there a
> way to make these modules load automatically after a reboot?

This is fixed by the following trivial patch, which was finally included
in kernel 2.6.38:


commit 116d588ea21cf0278a4de1e3272e9c3220a647e7
Author: Manu Abraham <abraham.manu@gmail.com>
Date:   Thu Feb 11 04:11:05 2010 -0300

    [media] Mantis, hopper: use MODULE_DEVICE_TABLE
    
    use the macro to make modules auto-loadable
    
    Thanks to Ozan Çağlayan <ozan@pardus.org.tr> for pointing it out
    
    Signed-off-by: Manu Abraham <manu@linuxtv.org>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
index 09e9fc7..70e73af 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -251,6 +251,8 @@ static struct pci_device_id hopper_pci_table[] = {
        { }
 };
 
+MODULE_DEVICE_TABLE(pci, hopper_pci_table);
+
 static struct pci_driver hopper_pci_driver = {
        .name           = DRIVER_NAME,
        .id_table       = hopper_pci_table,
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index cf4b39f..40da225 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -281,6 +281,8 @@ static struct pci_device_id mantis_pci_table[] = {
        { }
 };
 
+MODULE_DEVICE_TABLE(pci, mantis_pci_table);
+
 static struct pci_driver mantis_pci_driver = {
        .name           = DRIVER_NAME,
        .id_table       = mantis_pci_table,



The best way to work around the problem until you upgrade your kernel to
2.6.38 or newer, is probably just adding mantis to /etc/modules.


Bjørn
