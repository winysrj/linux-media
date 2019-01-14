Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D44C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 17:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F7F520659
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 17:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfANRFy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 12:05:54 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:60526 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbfANRFy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 12:05:54 -0500
Received: from [IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4] ([IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4])
        by smtp-cloud9.xs4all.net with ESMTPA
        id j5gNgAz4caxzfj5gOgbSrW; Mon, 14 Jan 2019 18:05:53 +0100
Subject: Re: [PATCH] vimc: add USERPTR support
To:     Helen Koike <helen.koike@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3f07695e-b441-343d-900f-fce397484915@xs4all.nl>
 <c8a92791-5bf4-56a1-f969-5b1dbc70c2eb@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e6bb6bba-abc6-3f51-c170-5d62828e2737@xs4all.nl>
Date:   Mon, 14 Jan 2019 18:05:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <c8a92791-5bf4-56a1-f969-5b1dbc70c2eb@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNPgYNnWxKUpSpDng9eTn8tLBimSpLk+zyItioi4sYrPu5v4oDc8jjQWWSWxBsqFhVqhaw7zFp85vlMc0nO3gZkfnZIv3q+otbSMCHX+xxmROp5aPGNw
 MLPCJ7iQQeI1w2ZB2gU0M0AEWCjVk58S6D8RFnBxsyP91C/Btx8nRP/2t6uChvWKeAlsdX3ttoBT6un+oMPdfEQ5Ikz0SJV3WuiWcaceDnqZDqL9y2L2qhOL
 d1hNoBTCLBtLmUmKhJ/nxZDIfhAn9LqqcflgOkRjP3qzB8/FbyOojgiZogOPQ8j5mvVerSnSCt3SYZmS08fADg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/14/19 6:04 PM, Helen Koike wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On 1/14/19 12:58 PM, Hans Verkuil wrote:
>> Add VB2_USERPTR to the vimc capture device.
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>> diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
>> index 3f7e9ed56633..35c730f484a7 100644
>> --- a/drivers/media/platform/vimc/vimc-capture.c
>> +++ b/drivers/media/platform/vimc/vimc-capture.c
>> @@ -431,7 +431,7 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
>>  	/* Initialize the vb2 queue */
>>  	q = &vcap->queue;
>>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> -	q->io_modes = VB2_MMAP | VB2_DMABUF;
>> +	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_USERPTR;
>>  	q->drv_priv = vcap;
>>  	q->buf_struct_size = sizeof(struct vimc_cap_buffer);
>>  	q->ops = &vimc_cap_qops;
>>
> 
> I remember at the time I was having some issues regarding userptr, I
> just want to make a few tests first.

Make sure you update to the latest v4l-utils first: there was a v4l2-compliance bug
that caused an incorrect FAIL for vimc.

Regards,

	Hans
