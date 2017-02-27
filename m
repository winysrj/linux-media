Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:35855 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbdB0DGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Feb 2017 22:06:39 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OM0016ULJAPWKA0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Feb 2017 12:06:25 +0900 (KST)
Subject: Re: [PATCH 1/2] media: s5p-mfc: convert drivers to use the new
 vb2_queue dev field
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kyungmin.park@samsung.com, jtp.park@samsung.com,
        mchehab@kernel.org, mchehab@osg.samsung.com,
        hans.verkuil@cisco.com, krzk@kernel.org, kgene@kernel.org,
        Smitha T Murthy <smitha.t@samsung.com>
From: "pankaj.dubey" <pankaj.dubey@samsung.com>
Message-id: <63c351de-6b2f-3d32-ccbd-898e4443a4bf@samsung.com>
Date: Mon, 27 Feb 2017 08:39:16 +0530
MIME-version: 1.0
In-reply-to: <a4db0512-8a5b-aaea-713b-5e3c09c3e8c2@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1481888915-19624-1-git-send-email-pankaj.dubey@samsung.com>
 <1481888915-19624-2-git-send-email-pankaj.dubey@samsung.com>
 <CGME20170224192311epcas1p34370fb737bd0d30e592431809d0dc540@epcas1p3.samsung.com>
 <a4db0512-8a5b-aaea-713b-5e3c09c3e8c2@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Javier,

On Saturday 25 February 2017 12:52 AM, Javier Martinez Canillas wrote:
> Hello Pankaj,
> 
> On 12/16/2016 08:48 AM, Pankaj Dubey wrote:
>> From: Smitha T Murthy <smitha.t@samsung.com>
>>
>> commit 2548fee63d9e ("[media] media/platform: convert drivers to use the new
>> vb2_queue dev field") has missed to set dev pointer of vb2_queue which will be
>> used in reqbufs of mfc driver. Without this change following error is observed:
>>
>> ---------------------------------------------------------------
>> V4L2 Codec decoding example application
>> Kamil Debski <k.debski@samsung.com>
>> Copyright 2012 Samsung Electronics Co., Ltd.
>>
>> Opening MFC.
>> (mfc.c:mfc_open:58): MFC Info (/dev/video0): driver="s5p-mfc" \
>> bus_info="platform:12c30000.mfc0" card="s5p-mfc-dec" fd=0x4[
>> 42.339165] Remapping memory failed, error: -6
>>
>> MFC Open Success.
>> (main.c:main:711): Successfully opened all necessary files and devices
>> (mfc.c:mfc_dec_setup_output:103): Setup MFC decoding OUTPUT buffer \
>> size=4194304 (requested=4194304)
>> (mfc.c:mfc_dec_setup_output:120): Number of MFC OUTPUT buffers is 2 \
>> (requested 2)
>>
>> [App] Out buf phy : 0x00000000, virt : 0xffffffff
>> Output Length is = 0x300000
>> Error (mfc.c:mfc_dec_setup_output:145): Failed to MMAP MFC OUTPUT buffer
>> -------------------------------------------------------
>>
> 
> On which kernel version did you face this issue?
> 

We observed this issue, on Linux 4.9 kernel while doing some experiment
for using reserved-memory for MFC on Exynos7880 based development board.

Anyways FYI, This patch is series is superseded by patch [1] after
review comments and suggestion from Marek. Patch [1] has been accepted
and merged and working well for us.

[1]: https://patchwork.kernel.org/patch/9482499/

Thanks,
Pankaj Dubey

>> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
>> [pankaj.dubey: debugging issue and formatting commit message]
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> index 0a5b8f5..6ea8246 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> @@ -838,6 +838,7 @@ static int s5p_mfc_open(struct file *file)
>>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>>  	q->drv_priv = &ctx->fh;
>>  	q->lock = &dev->mfc_mutex;
>> +	q->dev = &dev->plat_dev->dev;
>>  	if (vdev == dev->vfd_dec) {
>>  		q->io_modes = VB2_MMAP;
>>  		q->ops = get_dec_queue_ops();
>> @@ -861,6 +862,7 @@ static int s5p_mfc_open(struct file *file)
>>  	q->io_modes = VB2_MMAP;
>>  	q->drv_priv = &ctx->fh;
>>  	q->lock = &dev->mfc_mutex;
>> +	q->dev = &dev->plat_dev->dev;
>>  	if (vdev == dev->vfd_dec) {
>>  		q->io_modes = VB2_MMAP;
>>  		q->ops = get_dec_queue_ops();
>>
> 
> Please correct me if I'm wrong, but AFAIU this shouldn't be needed in
> the s5p-mfc driver since the videobuf2 core either uses the vb2_queue
> .dev field or the vb2_queue .alloc_devs. And the latter is set in the
> s5p_mfc_queue_setup() function, so the .dev field shouldn't be used.
> 
> Best regards,
> 
