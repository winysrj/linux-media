Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50778 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752776AbeBIVbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 16:31:40 -0500
Received: by mail-wm0-f66.google.com with SMTP id f71so17699141wmf.0
        for <linux-media@vger.kernel.org>; Fri, 09 Feb 2018 13:31:40 -0800 (PST)
Subject: Re: [PATCH] media: imx-media-internal-sd: Use memset to clear
 pdevinfo struct
From: Ian Arkver <ian.arkver.dev@gmail.com>
To: Fabio Estevam <fabio.estevam@nxp.com>, mchehab@kernel.org
Cc: slongerbeam@gmail.com, p.zabel@pengutronix.de,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        gregkh@linuxfoundation.org, festevam@gmail.com
References: <20180209163640.8759-1-fabio.estevam@nxp.com>
 <afdf4f21-538d-fbe1-b300-8bfa944b6754@gmail.com>
Message-ID: <ca2367ef-3b50-65dc-199a-f94b646210de@gmail.com>
Date: Fri, 9 Feb 2018 21:31:36 +0000
MIME-Version: 1.0
In-Reply-To: <afdf4f21-538d-fbe1-b300-8bfa944b6754@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/18 21:17, Ian Arkver wrote:
> On 09/02/18 16:36, Fabio Estevam wrote:
>> When building with W=1 the following warning shows up:
>>
>> drivers/staging/media/imx/imx-media-internal-sd.c:274:49: warning: 
>> Using plain integer as NULL pointer
>>
>> Fix this problem by using memset() to clear the pdevinfo structure.
> 
> Hi Fabio,
> 
> I thought initializers were preferred to memset. I think the problem 
> here is the first element of the struct is a pointer. Maybe this would 
> be better?
> 
> struct platform_device_info pdevinfo = {NULL};

Actually an empty initialiser list would be better again.

eg:
https://patchwork.kernel.org/patch/9480131/

> I see similar patches, for example:
> https://patchwork.kernel.org/patch/10095129/
> 
> Regards,
> IanJ
>>
>> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
>> ---
>>   drivers/staging/media/imx/imx-media-internal-sd.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c 
>> b/drivers/staging/media/imx/imx-media-internal-sd.c
>> index 70833fe503b5..377c20863b76 100644
>> --- a/drivers/staging/media/imx/imx-media-internal-sd.c
>> +++ b/drivers/staging/media/imx/imx-media-internal-sd.c
>> @@ -271,7 +271,7 @@ static int add_internal_subdev(struct 
>> imx_media_dev *imxmd,
>>                      int ipu_id)
>>   {
>>       struct imx_media_internal_sd_platformdata pdata;
>> -    struct platform_device_info pdevinfo = {0};
>> +    struct platform_device_info pdevinfo;
>>       struct platform_device *pdev;
>>       pdata.grp_id = isd->id->grp_id;
>> @@ -283,6 +283,7 @@ static int add_internal_subdev(struct 
>> imx_media_dev *imxmd,
>>       imx_media_grp_id_to_sd_name(pdata.sd_name, sizeof(pdata.sd_name),
>>                       pdata.grp_id, ipu_id);
>> +    memset(&pdevinfo, 0, sizeof(pdevinfo));
>>       pdevinfo.name = isd->id->name;
>>       pdevinfo.id = ipu_id * num_isd + isd->id->index;
>>       pdevinfo.parent = imxmd->md.dev;
>>
