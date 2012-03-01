Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803Ab2CAKRy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Mar 2012 05:17:54 -0500
Message-ID: <4F4F4CCD.3080605@redhat.com>
Date: Thu, 01 Mar 2012 07:17:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: gennarone@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] smsdvb - fix UNDEFINED delivery on driver hotplug
References: <CAKdnbx4BJ6PN5TEUBiueF9Q7gscRDSPAObzPFUFsbKK0HmbyZg@mail.gmail.com> <CAKdnbx7FFd0WaCSrD+6MCoX5_Vy=gy-D0aNk+cXs5x67-s1W6g@mail.gmail.com> <4F4235AC.2010101@gmail.com> <4F4F4A37.2020000@redhat.com>
In-Reply-To: <4F4F4A37.2020000@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-03-2012 07:06, Mauro Carvalho Chehab escreveu:
> Em 20-02-2012 09:59, Gianluca Gennari escreveu:
>> Il 14/02/2012 23:35, Eddi De Pieri ha scritto:
>>> Someone can confirm my changes?
>>>
>>> Regards,
>>>
>>> Eddi
>>
>> Hi Eddi,
>> your patch makes sense to me, but I think you will have to resubmit it
>> to the list, as the original mail has never been published (I can only
>> see your reply to it). Also, your patch is not listed on patchwork, so
>> it must have been lost.
> 
> Yes, you should re-submit it. Please be sure that your emailer won't mangle
> it, as otherwise patchwork won't catch it.

After looking on your patch, I think that the best fix is the patch below.
Instead of changing the fe_ops template, we should modify the per-client
copy.

Regards,
Mauro

-

smsusb: fix the default delivery system setting

There are two issues on the default delivery system setting for smsusb:

	1) instead of filling the delivery system for the per-client
	   frontend.ops, it were changing the global structure;

	2) The client->frontend.ops copy were keeping the previous value
	   of the template. So, the first time the device was inserted,
	   it was using the wrong value.

Reported-by: Eddi De Pieri <eddi@depieri.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/siano/smsdvb.c b/drivers/media/dvb/siano/smsdvb.c
index 654685c..e2dc80d 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -872,11 +872,11 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	switch (smscore_get_device_mode(coredev)) {
 	case DEVICE_MODE_DVBT:
 	case DEVICE_MODE_DVBT_BDA:
-		smsdvb_fe_ops.delsys[0] = SYS_DVBT;
+		client->frontend.ops.delsys[0] = SYS_DVBT;
 		break;
 	case DEVICE_MODE_ISDBT:
 	case DEVICE_MODE_ISDBT_BDA:
-		smsdvb_fe_ops.delsys[0] = SYS_ISDBT;
+		client->frontend.ops.delsys[0] = SYS_ISDBT;
 		break;
 	}
 
