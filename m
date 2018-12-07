Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5C1C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 20:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20EC720892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 20:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GnmWvHun"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20EC720892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbeLGUIG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 15:08:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41311 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeLGUIG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 15:08:06 -0500
Received: by mail-wr1-f65.google.com with SMTP id x10so4905774wrs.8
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 12:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=lsrE7lt4+MX5408AIjCR+p/dwFZsEWkcSv0XWAYtvuU=;
        b=GnmWvHunmokwKxk1Wv04RQ2EOYJsLgGDen3OYSIoMR6sStd9q1zSmy/BMkl40zgdxK
         GrxYpkTxlhoWhRsq9GJU0xugCKuihu1xj4qRy95jNeQtt7gziSj8WMpNLo8EDWQKVxsL
         TOSpv3+U4Q1Rd6iqXEYW1RHar/1iYkC3rWETBDPVdN3ZLrOkzPAkAMX0NN1TQbChfARp
         YtZI+tsWE1vnTPxUtjnWYVfvuawINuy3q7/i6IFo9VrEhPLdOLZUL49OmgKc1STCufoL
         na8OJI/NtE8z3ZqTjX24MvJJETZuZhTSblxdaaMre2QMAj2eZD2bFrO4wB6Uq5rsaK7A
         E/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lsrE7lt4+MX5408AIjCR+p/dwFZsEWkcSv0XWAYtvuU=;
        b=NZCxcxnj4HCS3+spZ2ayWqoFY4C067k4VXKXvEaFe8xUr9JDTxz6F6CMfn/us3j7Ta
         6AQAzq/qvzyp0FSmqm/pVg+5e+2gz1vGf0ALbHZ7KtsejoiFlCzbHZLeoIZ17Im+EgAZ
         A4ilalmVs1QoSMUdmHJ0NyzJ/YN9pEkBFXQeT8C5O/t6+ZO07tQ04QhcQYcXxH0t7hrG
         zPaPRJqcerHAv0JO0QsZEVGJXO70zJXn91lP6MBzXvL+haY7pppQo+mt8ezfpicBRecN
         QWDme7BYXtTegCfaDYBuIbShRyniOtvGuS8iSSyvpc7UhvSbBXIGhOVQR6Gyj5z6CqEz
         MMMg==
X-Gm-Message-State: AA+aEWYiglAi8WODiT0rBhG362B0rbKdYZN+vUDNldYcSG5pPmb7CEK4
        6ZU3mc29oRuvJhntFIuIxmZZk8NX
X-Google-Smtp-Source: AFSGD/XxD9wp7SekTpLMJJW92vP6HWVGNPSa9UZe9J9AE5HGHq8UGRcT799NsaX+A7YKijMRZRkMQg==
X-Received: by 2002:a5d:504f:: with SMTP id h15mr2972918wrt.83.1544213283200;
        Fri, 07 Dec 2018 12:08:03 -0800 (PST)
Received: from [172.30.89.100] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id t131sm2675525wmt.1.2018.12.07.12.08.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 12:08:02 -0800 (PST)
Subject: Re: [PATCH v5 00/12] imx-media: Fixes for interlaced capture
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <20181017000027.23696-1-slongerbeam@gmail.com>
 <30f8b7b7-3c43-aefd-a37e-245996f1a7bb@xs4all.nl>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <90b092b3-aeb4-17be-0338-6425eb8547b2@gmail.com>
Date:   Fri, 7 Dec 2018 12:07:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <30f8b7b7-3c43-aefd-a37e-245996f1a7bb@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 12/7/18 5:35 AM, Hans Verkuil wrote:
> Hi Steve,
>
> How to proceed with this w.r.t. the two gpu ipu patches? Are those going
> in first through the gpu tree? Or do they have to go in through our tree?

There is only one remaining gpu ipu patch in this series that is 
awaiting an ack from Philipp:

"gpu: ipu-csi: Swap fields according to input/output field types"

I pinged him again.

Philipp agreed to allow the two ipu patches in the series to be merged 
to media tree.

Steve

>
> In that case I need Acks from whoever maintains that code.
>
> Regards,
>
> 	Hans
>
> On 10/17/2018 02:00 AM, Steve Longerbeam wrote:
>> A set of patches that fixes some bugs with capturing from an
>> interlaced source, and incompatibilites between IDMAC interlace
>> interweaving and 4:2:0 data write reduction.
>>
>> History:
>> v5:
>> - Added a regression fix to allow empty endpoints to CSI (fix for imx6q
>>    SabreAuto).
>> - Cleaned up some convoluted code in ipu_csi_init_interface(), suggested
>>    by Philipp Zabel.
>> - Fixed a regression in csi_setup(), caught by Philipp.
>> - Removed interweave_offset and replace with boolean interweave_swap,
>>    suggested by Philipp.
>> - Make clear that it is IDMAC channel that does pixel reordering and
>>    interweave, not the CSI, in the imx.rst doc, caught by Philipp.
>>
>> v4:
>> - rebased to latest media-tree master branch.
>> - Make patch author and SoB email addresses the same.
>>
>> v3:
>> - add support for/fix interweaved scan with YUV planar output.
>> - fix bug in 4:2:0 U/V offset macros.
>> - add patch that generalizes behavior of field swap in
>>    ipu_csi_init_interface().
>> - add support for interweaved scan with field order swap.
>>    Suggested by Philipp Zabel.
>> - in v2, inteweave scan was determined using field types of
>>    CSI (and PRPENCVF) at the sink and source pads. In v3, this
>>    has been moved one hop downstream: interweave is now determined
>>    using field type at source pad, and field type selected at
>>    capture interface. Suggested by Philipp.
>> - make sure to double CSI crop target height when input field
>>    type in alternate.
>> - more updates to media driver doc to reflect above.
>>
>> v2:
>> - update media driver doc.
>> - enable idmac interweave only if input field is sequential/alternate,
>>    and output field is 'interlaced*'.
>> - move field try logic out of *try_fmt and into separate function.
>> - fix bug with resetting crop/compose rectangles.
>> - add a patch that fixes a field order bug in VDIC indirect mode.
>> - remove alternate field type from V4L2_FIELD_IS_SEQUENTIAL() macro
>>    Suggested-by: Nicolas Dufresne <nicolas@ndufresne.ca>.
>> - add macro V4L2_FIELD_IS_INTERLACED().
>>
>>
>> Steve Longerbeam (12):
>>    media: videodev2.h: Add more field helper macros
>>    gpu: ipu-csi: Swap fields according to input/output field types
>>    gpu: ipu-v3: Add planar support to interlaced scan
>>    media: imx: Fix field negotiation
>>    media: imx-csi: Input connections to CSI should be optional
>>    media: imx-csi: Double crop height for alternate fields at sink
>>    media: imx: interweave and odd-chroma-row skip are incompatible
>>    media: imx-csi: Allow skipping odd chroma rows for YVU420
>>    media: imx: vdic: rely on VDIC for correct field order
>>    media: imx-csi: Move crop/compose reset after filling default mbus
>>      fields
>>    media: imx: Allow interweave with top/bottom lines swapped
>>    media: imx.rst: Update doc to reflect fixes to interlaced capture
>>
>>   Documentation/media/v4l-drivers/imx.rst       | 103 +++++++----
>>   drivers/gpu/ipu-v3/ipu-cpmem.c                |  26 ++-
>>   drivers/gpu/ipu-v3/ipu-csi.c                  | 119 +++++++++----
>>   drivers/staging/media/imx/imx-ic-prpencvf.c   |  46 +++--
>>   drivers/staging/media/imx/imx-media-capture.c |  14 ++
>>   drivers/staging/media/imx/imx-media-csi.c     | 168 +++++++++++++-----
>>   drivers/staging/media/imx/imx-media-vdic.c    |  12 +-
>>   include/uapi/linux/videodev2.h                |   7 +
>>   include/video/imx-ipu-v3.h                    |   6 +-
>>   9 files changed, 354 insertions(+), 147 deletions(-)
>>

