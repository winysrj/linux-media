Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1746 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab3KIXA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Nov 2013 18:00:59 -0500
Message-ID: <527EBEA4.1070202@xs4all.nl>
Date: Sun, 10 Nov 2013 00:00:52 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Lorenz_R=F6hrl?= <sheepshit@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: BUG: Freeze upon loading bttv module
References: <527E606A.40101@gmx.de>
In-Reply-To: <527E606A.40101@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lorenz,

On 11/09/2013 05:18 PM, Lorenz Röhrl wrote:
> Hi,
> 
> i'm having problems loading the bttv-module for my bt878 based DVB-T 
> card: my system just freezes. Magic-Syskeys also won't work then.
> With kernel 3.9.0 this worked just fine. Versions 3.10, 3.11 and 3.12 
> won't work.
> 
> Last messages on screen with 3.12 upon booting/loading the module is: 
> http://abload.de/img/bttv_freezeqxdn2.png
> 
> With kernel 3.9 i get an additional line on module loading and the 
> device works fine:
> [    1.895037] bttv: 0: add subdevice "dvb0"
> 
> I traced the problem, it dies somewhere in v4l2_ctrl_handler_setup on 
> line 4169 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/media/pci/bt8xx/bttv-driver.c#n4169

Can you try this patch? I'm not 100% but I think this might be the cause of
the problem.

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index c6532de..4f0aaa5 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4182,7 +4182,8 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	}
 	btv->std = V4L2_STD_PAL;
 	init_irqreg(btv);
-	v4l2_ctrl_handler_setup(hdl);
+	if (!bttv_tvcards[btv->c.type].no_video)
+		v4l2_ctrl_handler_setup(hdl);
 	if (hdl->error) {
 		result = hdl->error;
 		goto fail2;

Regards,

	Hans

> 
> lspci output from kernel 3.9:
> [...]
> 04:01.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
> Capture (rev 11)
>          Subsystem: Twinhan Technology Co. Ltd VisionPlus DVB card
>          Flags: bus master, medium devsel, latency 32, IRQ 16
>          Memory at f0401000 (32-bit, prefetchable) [size=4K]
>          Capabilities: [44] Vital Product Data
>          Capabilities: [4c] Power Management version 2
>          Kernel driver in use: bttv
>          Kernel modules: bttv
> 
> 04:01.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
> (rev 11)
>          Subsystem: Twinhan Technology Co. Ltd VisionPlus DVB Card
>          Flags: bus master, medium devsel, latency 32, IRQ 16
>          Memory at f0400000 (32-bit, prefetchable) [size=4K]
>          Capabilities: [44] Vital Product Data
>          Capabilities: [4c] Power Management version 2
>          Kernel driver in use: bt878
>          Kernel modules: bt878
> 
> 
> 
> Please CC me as i'm not subscribed to the list.
> 
> Thanks!
> 
> - Lorenz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

