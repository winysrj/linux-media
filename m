Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56607 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab1J1WaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Oct 2011 18:30:15 -0400
Received: by qabj40 with SMTP id j40so4105103qab.19
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2011 15:30:14 -0700 (PDT)
Message-ID: <4EAB2CF4.4040007@gmail.com>
Date: Sat, 29 Oct 2011 00:30:12 +0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Gilles Gigan <gilles.gigan@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Switching input during capture
References: <CAJWu0HN8WC-xfAy3cNnA_o3YPj7+9Eo5+YCvNtqRNs9dG18+8A@mail.gmail.com> <201110281442.21776.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201110281442.21776.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-10-2011 14:42, Laurent Pinchart escreveu:
> Hi Gilles,
> 
> On Friday 28 October 2011 03:31:53 Gilles Gigan wrote:
>> Hi,
>> I would like to know what is the correct way to switch the current
>> video input during capture on a card with a single BT878 chip and 4
>> inputs
>> (http://store.bluecherry.net/products/PV%252d143-%252d-4-port-video-captur
>> e-card-%2830FPS%29-%252d-OEM.html). I tried doing it in two ways:
>> - using VIDIOC_S_INPUT to change the current input. While this works,
>> the next captured frame shows video from the old input in its top half
>> and video from the new input in the bottom half.

This is is likely easy to fix. The driver has already a logic to prevent changing
the buffer while in the middle of a buffer filling. I suspect that the BKL removal
patches might have broken it somewhat, allowing things like that. basically, it
should be as simple as not allowing changing the input at the top half.

Please try the enclosed patch.

Regards,
Mauro

-

bttv: Avoid switching the video input at the top half.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 3dd0660..6a3be6f 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3978,7 +3978,7 @@ bttv_irq_switch_video(struct bttv *btv)
 	bttv_set_dma(btv, 0);
 
 	/* switch input */
-	if (UNSET != btv->new_input) {
+	if (! btv->curr.top && UNSET != btv->new_input) {
 		video_mux(btv,btv->new_input);
 		btv->new_input = UNSET;
 	}
