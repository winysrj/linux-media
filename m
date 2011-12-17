Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab1LQLQj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 06:16:39 -0500
Message-ID: <4EEC7A12.5060404@redhat.com>
Date: Sat, 17 Dec 2011 09:16:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Brian May <brian@microcomaustralia.com.au>
CC: linux-media@vger.kernel.org
Subject: Re: budget_ci / rc-hauppauge / inputlirc /Linux 3.0+ broken
References: <CAA0ZO6BFmX6pb4+8jgnBQsGGZCV+ZkZ_BPSQFxLrOA43Ny1s1w@mail.gmail.com>
In-Reply-To: <CAA0ZO6BFmX6pb4+8jgnBQsGGZCV+ZkZ_BPSQFxLrOA43Ny1s1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brian,

Em 17-12-2011 04:33, Brian May escreveu:
> SUMMARY OF WHAT I THINK I HAPPENING:
> 
> budget_ci sets dev->scanmask to 0xff, this means the scancodes in the
> tables have the upper 8 bits of the 16 bit code set to 0.
> 
> However for my card, it sets full_rc5 to True and rc_device to 0x1f.
> This means the following new code gets executed:
> 
>     if (budget_ci->ir.full_rc5) {
>         rc_keydown(dev,
>                budget_ci->ir.rc5_device <<8 | budget_ci->ir.ir_key,
>                (command & 0x20) ? 1 : 0);
>         return;
>     }
> 
> 
> Where as before this code would get executed:
> 
> rc_keydown(dev, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);
> 
> The result is that it tries to lookup (in this case) 0x1f21 in the
> scancode table, which is a copy of rc-hauppauge but with the upper 8
> bits of the scan code set to 0; the result is it can't find a match.
> 
> Does this sound right?
> 
> Maybe scanmask shouldn't be set to 0xff if full_rc5 is set to true?

Yes.

could you please try the enclosed patch?

Thanks!
Mauro

-

[PATCH] [media] budget-ci: Fix Hauppauge RC-5 IR support

Hauppauge RC-5 tables require the full scancodes. The code at budget-ci
handles it right, however, it request the rc-code to mask them with 0xff,
breaking support for some remote controllers.

Fix it by not selecting a scancode mask when the driver is on full_rc5 mode.

Reported-by: Brian May <brian@microcomaustralia.com.au>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/ttpci/budget-ci.c
b/drivers/media/dvb/ttpci/budget-ci.c
index ca02e97..ab180f9 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -193,7 +193,6 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	dev->input_phys = budget_ci->ir.phys;
 	dev->input_id.bustype = BUS_PCI;
 	dev->input_id.version = 1;
-	dev->scanmask = 0xff;
 	if (saa->pci->subsystem_vendor) {
 		dev->input_id.vendor = saa->pci->subsystem_vendor;
 		dev->input_id.product = saa->pci->subsystem_device;
@@ -234,6 +233,8 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 		dev->map_name = RC_MAP_BUDGET_CI_OLD;
 		break;
 	}
+	if (!budget_ci->ir.full_rc5)
+		dev->scanmask = 0xff;

 	error = rc_register_device(dev);
 	if (error) {


