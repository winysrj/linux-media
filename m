Return-path: <linux-media-owner@vger.kernel.org>
Received: from jusst.de ([188.40.114.84]:45168 "EHLO web01.jusst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbcBWUMI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 15:12:08 -0500
Subject: Re: [PATCH] media: adv7180: Add of compatible strings for full family
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1456228699-22575-1-git-send-email-julian@jusst.de>
 <1941393.Upgl0HgCbF@avalon>
Cc: linux-media@vger.kernel.org, lars@metafoo.de, hverkuil@xs4all.nl
From: Julian Scheel <julian@jusst.de>
Message-ID: <56CCBD1D.6070900@jusst.de>
Date: Tue, 23 Feb 2016 21:12:13 +0100
MIME-Version: 1.0
In-Reply-To: <1941393.Upgl0HgCbF@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

thanks for the fast review :)

On 23.02.16 21:06, Laurent Pinchart wrote:
> On Tuesday 23 February 2016 12:58:19 Julian Scheel wrote:
>> Add entries for all supported chip variants into the of_match list, so that
>> the matching driver_info can be selected when using dt.
>
> How about starting by adding a DT bindings document ?

Probably a good thing to do. Didn't think about it as the of_match table 
was already there. Are you ok with the document being added within this 
commit or shall I better split it?

>> Change-Id: I6ff849726c8f475c81e848423b27c35f2ccb0509
>
> I sympathize with you for the pain gerrit is inflicting on you, but don't
> share it with all upstream developers please, you can remove this :-)

Hah, so true. Will drop it in v2 :)

>> Signed-off-by: Julian Scheel <julian@jusst.de>
>> ---
>>   drivers/media/i2c/adv7180.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
>> index ff57c1d..5515f3d 100644
>> --- a/drivers/media/i2c/adv7180.c
>> +++ b/drivers/media/i2c/adv7180.c
>> @@ -1328,6 +1328,14 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops,
>> adv7180_suspend, adv7180_resume); #ifdef CONFIG_OF
>>   static const struct of_device_id adv7180_of_id[] = {
>>   	{ .compatible = "adi,adv7180", },
>> +	{ .compatible = "adi,adv7182", },
>> +	{ .compatible = "adi,adv7280", },
>> +	{ .compatible = "adi,adv7280-m", },
>> +	{ .compatible = "adi,adv7281", },
>> +	{ .compatible = "adi,adv7281-m", },
>> +	{ .compatible = "adi,adv7281-ma", },
>> +	{ .compatible = "adi,adv7282", },
>> +	{ .compatible = "adi,adv7282-m", },
>>   	{ },
>>   };
>
