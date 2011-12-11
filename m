Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49910 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab1LKQUs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 11:20:48 -0500
Received: by wgbdr13 with SMTP id dr13so9516095wgb.1
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 08:20:46 -0800 (PST)
Message-ID: <1323620428.3625.7.camel@tvbox>
Subject: [PATCH] [BUG] Re: add support for IT9135 9005 devices
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Date: Sun, 11 Dec 2011 16:20:28 +0000
In-Reply-To: <E1RZhQJ-00030k-Pa@www.linuxtv.org>
References: <E1RZhQJ-00030k-Pa@www.linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Re: [git:v4l-dvb/for_v3.3] [media] it9135:  add support for IT9135 9005 devices
On Sun, 2011-12-11 at 11:55 +0100, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] it9135:  add support for IT9135 9005 devices
> Author:  Malcolm Priestley <tvboxspy@gmail.com>
> Date:    Wed Nov 30 17:16:09 2011 -0300
> 
> Support add for IT9135 9005 devices
> 
> With this patch IT9135 devices now move to using
> dvb-usb-it9135-01.fw firmware
> IT9137 remain on previous firmware.
Hi Mauro,

I have made a small mistake on this patch.

I forgot to increase number of num_device_descs to 4.

Regards


Malcolm

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 1aa3872..26b31c0 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -775,7 +775,7 @@ static struct dvb_usb_device_properties it913x_properties = {
 		.rc_codes	= RC_MAP_MSI_DIGIVOX_III,
 	},
 	.i2c_algo         = &it913x_i2c_algo,
-	.num_device_descs = 3,
+	.num_device_descs = 4,
 	.devices = {
 		{   "Kworld UB499-2T T09(IT9137)",
 			{ &it913x_table[0], NULL },
-- 
1.7.7.3


