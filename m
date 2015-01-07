Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:50288 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbbAGUFy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 15:05:54 -0500
Received: by mail-yk0-f178.google.com with SMTP id 20so917882yks.23
        for <linux-media@vger.kernel.org>; Wed, 07 Jan 2015 12:05:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1501072043490.16637@axis700.grange>
References: <1420597628-317-1-git-send-email-andy.shevchenko@gmail.com>
	<Pine.LNX.4.64.1501072043490.16637@axis700.grange>
Date: Wed, 7 Jan 2015 22:05:53 +0200
Message-ID: <CAHp75VfsCDSiviC7-tprXCqDqXmvJs87V8ve4HoPECyVoh4eww@mail.gmail.com>
Subject: Re: [PATCH] [media] soc_camera: avoid potential null-dereference
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 7, 2015 at 9:44 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Andy,
>
> Thanks for the patch. Will queue for the next pull request.

If you didn't do that please wait. It seems it has one more place with
similar issue. Moreover, I would like to add a person's name who
reported this.

>
> Regards
> Guennadi
>
> On Wed, 7 Jan 2015, Andy Shevchenko wrote:
>
>> We have to check the pointer before dereferencing it.
>>
>> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>> ---
>>  drivers/media/platform/soc_camera/soc_camera.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
>> index b3db51c..8c665c4 100644
>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>> @@ -2166,7 +2166,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
>>  static int soc_camera_pdrv_probe(struct platform_device *pdev)
>>  {
>>       struct soc_camera_desc *sdesc = pdev->dev.platform_data;
>> -     struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
>> +     struct soc_camera_subdev_desc *ssdd;
>>       struct soc_camera_device *icd;
>>       int ret;
>>
>> @@ -2177,6 +2177,8 @@ static int soc_camera_pdrv_probe(struct platform_device *pdev)
>>       if (!icd)
>>               return -ENOMEM;
>>
>> +     ssdd = &sdesc->subdev_desc;
>> +
>>       /*
>>        * In the asynchronous case ssdd->num_regulators == 0 yet, so, the below
>>        * regulator allocation is a dummy. They are actually requested by the
>> --
>> 1.8.3.101.g727a46b
>>



-- 
With Best Regards,
Andy Shevchenko
