Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33203 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbbHaWNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 18:13:17 -0400
Received: by laboe4 with SMTP id oe4so54470053lab.0
        for <linux-media@vger.kernel.org>; Mon, 31 Aug 2015 15:13:15 -0700 (PDT)
Subject: Re: [PATCH] rcar_vin: propagate querystd() error upstream
To: Hans Verkuil <hverkuil@xs4all.nl>, g.liakhovetski@gmx.de,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org
References: <1650569.JYNQd5Bi8T@wasted.cogentembedded.com>
 <55DC7AE2.6010103@xs4all.nl>
Cc: linux-sh@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <55E4D179.4080009@cogentembedded.com>
Date: Tue, 1 Sep 2015 01:13:13 +0300
MIME-Version: 1.0
In-Reply-To: <55DC7AE2.6010103@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 08/25/2015 05:25 PM, Hans Verkuil wrote:

>> rcar_vin_set_fmt() defaults to  PAL when the subdevice's querystd() method call
>> fails (e.g. due to I2C error).  This doesn't work very well when a camera being
>> used  outputs NTSC which has different order of fields and resolution.  Let  us
>> stop  pretending and return the actual error (which would prevent video capture
>> on at least Renesas Henninger/Porter board where I2C seems particularly buggy).
>>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>
>> ---
>> The patch is against the 'media_tree.git' repo's 'fixes' branch.
>>
>>   drivers/media/platform/soc_camera/rcar_vin.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
>> ===================================================================
>> --- media_tree.orig/drivers/media/platform/soc_camera/rcar_vin.c
>> +++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
>> @@ -1592,7 +1592,7 @@ static int rcar_vin_set_fmt(struct soc_c
>>   		/* Query for standard if not explicitly mentioned _TB/_BT */
>>   		ret = v4l2_subdev_call(sd, video, querystd, &std);

> Ouch, this should never be done like this.

    Too late. :-)

> Instead the decision should be made using the last set std, never by querying.
> So querystd should be replaced by g_std in the v4l2_subdev_call above.

    Hm, then this code will stop working, as adv7180.c and ml86v7667.c we use 
don't support the g_std() method yet...

> The only place querystd can be called is in the QUERYSTD ioctl, all other
> ioctls should use the last set standard.

    OK, I'll have to fix all the drivers involved...

> Regards,
> 	Hans

MBR, Sergei

