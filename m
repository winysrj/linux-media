Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46966 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967197Ab3E2Xwo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 19:52:44 -0400
Message-ID: <51A694A2.10807@iki.fi>
Date: Thu, 30 May 2013 02:52:02 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: Keene
References: <5167513D.60804@iki.fi> <201304190912.06319.hverkuil@xs4all.nl> <51710A3F.10909@iki.fi> <201305291626.20170.hverkuil@xs4all.nl> <51A641DE.9020403@iki.fi>
In-Reply-To: <51A641DE.9020403@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------070303000004040000030302"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070303000004040000030302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/29/2013 08:58 PM, Antti Palosaari wrote:
> On 05/29/2013 05:26 PM, Hans Verkuil wrote:
>> On Fri April 19 2013 11:11:27 Antti Palosaari wrote:
>>> On 04/19/2013 10:12 AM, Hans Verkuil wrote:
>>>> On Wed April 17 2013 21:45:24 Antti Palosaari wrote:
>>>>> On 04/15/2013 09:55 AM, Hans Verkuil wrote:
>>>>>> On Fri April 12 2013 02:11:41 Antti Palosaari wrote:
>>>>>>> Hello Hans,
>>>>>>> That device is working very, thank you for it. Anyhow, I noticed
>>>>>>> two things.
>>>>>>>
>>>>>>> 1) it does not start transmitting just after I plug it - I have to
>>>>>>> retune it!
>>>>>>> Output says it is tuned to 95.160000 MHz by default, but it is not.
>>>>>>> After I issue retune, just to same channel it starts working.
>>>>>>> $ v4l2-ctl -d /dev/radio0 --set-freq=95.16
>>>>>>
>>>>>> Can you try this patch:
>>>>>>
>>>>>
>>>>> It does not resolve the problem. It is quite strange behavior. After I
>>>>> install modules, and modules are unload, plug stick in first time, it
>>>>> usually (not every-time) starts TX. But when I replug it without
>>>>> unloading modules, it will never start TX. Tx is started always when I
>>>>> set freq using v4l2-ctl.
>>>>
>>>> If you replace 'false' by 'true' in the cmd_main, does that make it
>>>> work?
>>>> I'm fairly certain that's the problem.
>>>
>>> Nope, I replaces all 'false' with 'true' and problem remains. When
>>> modules were unload and device is plugged it starts TX. When I replug it
>>> doesn't start anymore.
>>>
>>> I just added msleep(1000); just before keene_cmd_main() in .probe() and
>>> now it seems to work every-time. So it is definitely timing issue. I
>>> will try to find out some smallest suitable value for sleep and and sent
>>> patch.
>>
>> Have you had time to find a smaller msleep value?
>
> Nope, but I will do it today (if I don't meet any problems when
> upgrading to latest master).
>
> regards
> Antti
>

Attached patch gives some idea. Do what you want, I have no idea how it 
should be.

Interesting thing I saw there was some automatic on/off Tx logic, but 
unfortunately it was enabled randomly.

Also keene_cmd_main() play parameter does not have any effect.

regards
Antti


-- 
http://palosaari.fi/

--------------070303000004040000030302
Content-Type: text/x-patch;
 name="0001-Keene-start-Tx-by-default.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Keene-start-Tx-by-default.patch"

>From 59257e5556a5ac4d19111e35001ced5b4d53b5c2 Mon Sep 17 00:00:00 2001
From: Antti Palosaari <crope@iki.fi>
Date: Thu, 30 May 2013 02:45:47 +0300
Subject: [PATCH] Keene: start Tx by default

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/radio/radio-keene.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 4c9ae76..d710529 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -383,6 +383,20 @@ static int usb_keene_probe(struct usb_interface *intf,
 	video_set_drvdata(&radio->vdev, radio);
 	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
 
+	/*
+	 * mdelay(11) needed in order to apply keene_cmd_main() command.
+	 * mdelay(10) is not enough, it works sometimes but usually not.
+	 *
+	 * keene_cmd_main() 3rd parameter (play) does not has any effect.
+	 * It starts Tx regardless of that parameter.
+	 *
+	 * Sometimes it enters mode where it stops Tx automatically after input
+	 * is silent 60 sec and also starts Tx automatically when there is
+	 * noise on input. It is not clear how to enable that...
+	 */
+	mdelay(11);
+	keene_cmd_main(radio, 95.16 * FREQ_MUL, false);
+
 	retval = video_register_device(&radio->vdev, VFL_TYPE_RADIO, -1);
 	if (retval < 0) {
 		dev_err(&intf->dev, "could not register video device\n");
-- 
1.7.11.7


--------------070303000004040000030302--
