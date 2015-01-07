Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:37522 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbbAGUO7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 15:14:59 -0500
Received: by mail-yh0-f45.google.com with SMTP id f10so980520yha.4
        for <linux-media@vger.kernel.org>; Wed, 07 Jan 2015 12:14:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHp75VfsCDSiviC7-tprXCqDqXmvJs87V8ve4HoPECyVoh4eww@mail.gmail.com>
References: <1420597628-317-1-git-send-email-andy.shevchenko@gmail.com>
	<Pine.LNX.4.64.1501072043490.16637@axis700.grange>
	<CAHp75VfsCDSiviC7-tprXCqDqXmvJs87V8ve4HoPECyVoh4eww@mail.gmail.com>
Date: Wed, 7 Jan 2015 22:14:58 +0200
Message-ID: <CAHp75Ve1L=v68moUvTahw_O4HYY9-tTQfWoDdD7KcJv5HPb5Mw@mail.gmail.com>
Subject: Re: [PATCH] [media] soc_camera: avoid potential null-dereference
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 7, 2015 at 10:05 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, Jan 7, 2015 at 9:44 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
>> Hi Andy,
>>
>> Thanks for the patch. Will queue for the next pull request.
>
> If you didn't do that please wait. It seems it has one more place with
> similar issue. Moreover, I would like to add a person's name who
> reported this.

Okay, the second one is false positive.
And
Reported-by: Andrey Karpov <karpov@viva64.com>

>
>>
>> Regards
>> Guennadi
>>
>> On Wed, 7 Jan 2015, Andy Shevchenko wrote:
>>
>>> We have to check the pointer before dereferencing it.
>>>
>>> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>>> ---
>>>  drivers/media/platform/soc_camera/soc_camera.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
>>> index b3db51c..8c665c4 100644
>>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>>> @@ -2166,7 +2166,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
>>>  static int soc_camera_pdrv_probe(struct platform_device *pdev)
>>>  {
>>>       struct soc_camera_desc *sdesc = pdev->dev.platform_data;
>>> -     struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
>>> +     struct soc_camera_subdev_desc *ssdd;
>>>       struct soc_camera_device *icd;
>>>       int ret;
>>>
>>> @@ -2177,6 +2177,8 @@ static int soc_camera_pdrv_probe(struct platform_device *pdev)
>>>       if (!icd)
>>>               return -ENOMEM;
>>>
>>> +     ssdd = &sdesc->subdev_desc;
>>> +
>>>       /*
>>>        * In the asynchronous case ssdd->num_regulators == 0 yet, so, the below
>>>        * regulator allocation is a dummy. They are actually requested by the
>>> --
>>> 1.8.3.101.g727a46b
>>>
>
>
>
> --
> With Best Regards,
> Andy Shevchenko



-- 
With Best Regards,
Andy Shevchenko
