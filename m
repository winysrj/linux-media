Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C802C10F03
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 07:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA4AE21929
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 07:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zqm649P6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfCVHrF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 03:47:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43957 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfCVHrF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 03:47:05 -0400
Received: by mail-lj1-f193.google.com with SMTP id f18so1185773lja.10
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 00:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=3DbbW9xZyhrn3Ibv1RQDTHJ1q/P4+W3QF6whNvjE6wQ=;
        b=Zqm649P61T+o7D5qqHEGciA6DtOrVH/eEc5ArEp97mbuzlVxPFe1ogx9QRsik9R0rB
         U07jMpYZiHbLVOtKxurEAL+RODoxm2NDma02j2bCswcXWZ2//kRQoq0Tyth8LGy0+OL7
         LK2HwZJ9K5L+soNo+Z+D4oEHdf43zSu553VcC+b1VJ2yTJQxEy44XhhJKp/JGtaDZ19+
         DbNNITUypC8V7iFxBBJ0wc6MYOlU0965kaTTG4/6mT3aqx+JDObKpNW2q/1ORhu5b8Tw
         jjD+36lwrrwb2AFAme6//YrpCezJc0jaQz0D3y/txDrMSW/Y9eQBddSFau9o9kr9N50y
         MO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3DbbW9xZyhrn3Ibv1RQDTHJ1q/P4+W3QF6whNvjE6wQ=;
        b=nHFW/LXijM+SygvpMJYC5lmCyamZ+wbh4ph8fShLc88GxC8sae+LVd1AulXFvDdlkM
         D9q5ZqVgbkRlt+ddyotHORdFMCnHatESbT+/b0SAV3UKJuDJfwQdwTNr3WZ3g4Cj3N41
         YuA1nfdAYUY1kbv8g5J5ivSDn6vXtVYqLBcj04K7iUUrF51sAOi1WArGkP8wXh0RtoYv
         AgSHTS1dbdksTU0dKKvwi5nEItjbQcik3DuXgv0pWVL04unJ3tIUn0drq3DF0Q0MWraJ
         XS4i/xIUrk0ZKyJV6n++gi+rfrNI0r3vrfVPGB4hkFsdALvcd+RA8ydv12pp9Qfv/pov
         rtvA==
X-Gm-Message-State: APjAAAVa1UnKNBJ9I1az1kpswlnYEEB4xPXK253lZO/18eUAxeOVKOxX
        tP/79knU+Xi4rOdBvj56oKA=
X-Google-Smtp-Source: APXvYqwZHc/s1xGcOUpSlHv5QBh0JTM17uRTHcX45ybABtSPv0nvjA9ubCpREKEcENcqWwaYypNdtA==
X-Received: by 2002:a2e:6c0f:: with SMTP id h15mr4346641ljc.155.1553240822306;
        Fri, 22 Mar 2019 00:47:02 -0700 (PDT)
Received: from [10.17.182.20] (ll-74.141.223.85.sovam.net.ua. [85.223.141.74])
        by smtp.gmail.com with ESMTPSA id j8sm1387824ljh.58.2019.03.22.00.47.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 00:47:01 -0700 (PDT)
Subject: Re: [Xen-devel][PATCH v6 0/1] cameraif: add ABI for para-virtual
 camera
To:     jgross@suse.com, hverkuil@xs4all.nl
References: <20190322073742.14639-1-andr2000@gmail.com>
Cc:     "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <12e4d13d-c02b-a8a0-6443-711226347c03@gmail.com>
Date:   Fri, 22 Mar 2019 09:47:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190322073742.14639-1-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Juergen, the changes are minor (request description clarification),
but still I didn't put your R-b: just in case.

Hope this version is good to go...

Thank you,
Oleksandr

On 3/22/19 9:37 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> Hello!
>
> At the moment Xen [1] already supports some virtual multimedia
> features [2] such as virtual display, sound. It supports keyboards,
> pointers and multi-touch devices all allowing Xen to be used in
> automotive appliances, In-Vehicle Infotainment (IVI) systems
> and many more.
>
> Frontend implementation is available at [3] and the corresponding
> backend at [4]. These are work in progress, but frontend already
> passes v4l2-compliance test for V4L2 drivers. libxl preliminary
> changes are available at [5].
>
> This work adds a new Xen para-virtualized protocol for a virtual
> camera device which extends multimedia capabilities of Xen even
> farther: video conferencing, IVI, high definition maps etc.
>
> The initial goal is to support most needed functionality with the
> final idea to make it possible to extend the protocol if need be:
>
> 1. Provide means for base virtual device configuration:
>   - pixel formats
>   - resolutions
>   - frame rates
> 2. Support basic camera controls:
>   - contrast
>   - brightness
>   - hue
>   - saturation
> 3. Support streaming control
>
> I would like to thank Hans Verkuil <hverkuil@xs4all.nl> for valuable
> comments and help.
>
> Thank you,
> Oleksandr Andrushchenko
>
> Changes since v5:
> =================
>
> 1. Minor cleanup of the XENCAMERA_OP_BUF_REQUEST description
>
> Changes since v4:
> =================
>
> 1. Removed unused XENCAMERA_EVT_CFG_FLG_RESOL flag
> 2. Re-worded a bit description for num_buffers
>
> Changes since v3:
> =================
>
> 1. Add trimming example for short FOURCC labels, e.g. Y16 and Y16-BE
> 2. Remove from XENCAMERA_OP_CONFIG_XXX requests colorspace, xfer_func,
>     ycbcr_enc, quantization and move those into the corresponding response
> 3. Extend description of XENCAMERA_OP_BUF_REQUEST.num_bufs: limit to
>     maximum buffers and num_bufs == 0 case
> 4. Extend decription of XENCAMERA_OP_BUF_CREATE.index and specify its
>     range
> 5. Make XENCAMERA_EVT_FRAME_AVAIL.seq_num 32-bit instead of 64-bit
>
> Changes since v2:
> =================
>
> 1. Add "max-buffers" frontend configuration entry, e.g.
>     the maximum number of camera buffers a frontend may use.
> 2. Add big-endian pixel-format support:
>   - "formats" configuration string length changed from 4 to 7
>     octets, so we can also manage BE pixel-formats
>   - add corresponding comments to FOURCC mappings description
> 3. New commands added to the protocol and documented:
>   - XENCAMERA_OP_CONFIG_VALIDATE
>   - XENCAMERA_OP_FRAME_RATE_SET
>   - XENCAMERA_OP_BUF_GET_LAYOUT
> 4.-Add defaults for colorspace, xfer, ycbcr_enc and quantization
> 5. Remove XENCAMERA_EVT_CONFIG_CHANGE event
> 6. Move plane offsets to XENCAMERA_OP_BUF_REQUEST as offsets
>     required for the frontend might not be known at the configuration time
> 7. Clean up and address comments to v2 of the protocol
>
> Changes since v1:
> =================
>
> 1. Added XenStore entries:
>   - frame-rates
> 2. Do not require the FOURCC code in XenStore to be upper case only
> 3. Added/changed command set:
>   - configuration get/set
>   - buffer queue/dequeue
>   - control get
> 4. Added control flags, e.g. read-only etc.
> 5. Added colorspace configuration support, relevant constants
> 6. Added events:
>   - configuration change
>   - control change
> 7. Changed control values to 64-bit
> 8. Added sequence number to frame avail event
> 9. Coding style cleanup
>
> [1] https://www.xenproject.org/
> [2] https://xenbits.xen.org/gitweb/?p=xen.git;a=tree;f=xen/include/public/io
> [3] https://github.com/andr2000/linux/tree/camera_front_v1/drivers/media/xen
> [4] https://github.com/andr2000/camera_be
> [5] https://github.com/andr2000/xen/tree/vcamera
>
> Oleksandr Andrushchenko (1):
>    cameraif: add ABI for para-virtual camera
>
>   xen/include/public/io/cameraif.h | 1374 ++++++++++++++++++++++++++++++
>   1 file changed, 1374 insertions(+)
>   create mode 100644 xen/include/public/io/cameraif.h
>

