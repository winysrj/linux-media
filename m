Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51550 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762261AbZJPPsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 11:48:00 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9GFlNbF012975
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 10:47:24 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id n9GFlN1V027964
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 10:47:23 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Fri, 16 Oct 2009 10:47:22 -0500
Subject: RE: [Resubmition PATCH] Davinci VPFE Capture: Take i2c adapter id
 through platform data
Message-ID: <A69FA2915331DC488A831521EAE36FE4015555F643@dlee06.ent.ti.com>
References: <hvaibhav@ti.com>
	<1255688821-6655-1-git-send-email-hvaibhav@ti.com>
 <19F8576C6E063C45BE387C64729E73940436DB27DB@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436DB27DB@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vaibhav,

Thanks for the patch. See my comment below.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: davinci-linux-open-source-bounces@linux.davincidsp.com
>[mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
>Of Hiremath, Vaibhav
>Sent: Friday, October 16, 2009 6:29 AM
>To: Hiremath, Vaibhav; linux-media@vger.kernel.org
>Cc: davinci-linux-open-source@linux.davincidsp.com
>Subject: RE: [Resubmition PATCH] Davinci VPFE Capture: Take i2c adapter id
>through platform data
>
>> -----Original Message-----
>> From: Hiremath, Vaibhav
>> Sent: Friday, October 16, 2009 3:57 PM
>> To: linux-media@vger.kernel.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com; Hiremath,
>> Vaibhav
>> Subject: [Resubmition PATCH] Davinci VPFE Capture: Take i2c adapter
>> id through platform data
>>
>> From: Vaibhav Hiremath <hvaibhav@ti.com>
>>
>> The I2C adapter ID is actually depends on Board and may vary,
>> Davinci
>> uses id=1, but in case of AM3517 id=3.
>>
>> Changes:
>> 	- Fixed review comments (Typo) from Sergei
>>
>> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>> ---
>>  drivers/media/video/davinci/vpfe_capture.c |    3 +--
>>  include/media/davinci/vpfe_capture.h       |    2 ++
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/video/davinci/vpfe_capture.c
>> b/drivers/media/video/davinci/vpfe_capture.c
>> index dc32de0..c3c37e7 100644
>> --- a/drivers/media/video/davinci/vpfe_capture.c
>> +++ b/drivers/media/video/davinci/vpfe_capture.c
>> @@ -2228,8 +2228,7 @@ static __init int vpfe_probe(struct
>> platform_device *pdev)
>>  	platform_set_drvdata(pdev, vpfe_dev);
>>  	/* set driver private data */
>>  	video_set_drvdata(vpfe_dev->video_dev, vpfe_dev);
>> -	i2c_adap = i2c_get_adapter(1);
>> -	vpfe_cfg = pdev->dev.platform_data;

[MK] Why did you remove this? platform data has vpfe configuration.

>> +	i2c_adap = i2c_get_adapter(vpfe_cfg->i2c_adapter_id);
[MK] I guess adapter ID has to be non-zero. If so, we could use
a default id of 1 for davinci platform. Otherwise both dm355 and
dm6446 evm files are to be updated along with this patch.
What do you think? I can help you test this patch on the above platforms
and Ack it based on that.

i2c_get_adapter(vpfe_cfg->i2c_adapter_id == 0 ? 1:
				vpfe_cfg->i2c_adapter_id);

>>  	num_subdevs = vpfe_cfg->num_subdevs;
>>  	vpfe_dev->sd = kmalloc(sizeof(struct v4l2_subdev *) *
>> num_subdevs,
>>  				GFP_KERNEL);
>> diff --git a/include/media/davinci/vpfe_capture.h
>> b/include/media/davinci/vpfe_capture.h
>> index e8272d1..fc83d98 100644
>> --- a/include/media/davinci/vpfe_capture.h
>> +++ b/include/media/davinci/vpfe_capture.h
>> @@ -94,6 +94,8 @@ struct vpfe_subdev_info {
>>  struct vpfe_config {
>>  	/* Number of sub devices connected to vpfe */
>>  	int num_subdevs;
>> +	/* I2C Bus adapter no */
>> +	int i2c_adapter_id;
>>  	/* information about each subdev */
>>  	struct vpfe_subdev_info *sub_devs;
>>  	/* evm card info */
>[Hiremath, Vaibhav] Murali,
>
>If you do not have any comments with these series of patches, can you
>please ack them?
>
>Hans/Kevin,
>
>Can you please merge these patches to respective repo., they should get
>applied cleanly.
>
>Thanks,
>Vaibhav
>
>> --
>> 1.6.2.4
>
>_______________________________________________
>Davinci-linux-open-source mailing list
>Davinci-linux-open-source@linux.davincidsp.com
>http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
