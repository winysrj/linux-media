Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D3EC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D44DF214AF
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:38:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IOigUejh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfCLIif (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:38:35 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36767 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCLIif (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 04:38:35 -0400
Received: by mail-lf1-f65.google.com with SMTP id d18so703624lfn.3
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 01:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=d9i+bN0RKpp8w2BxTsuDGABqK025+FmhXSHTHeUl67I=;
        b=IOigUejh9opiPCuW29txa/8+Z1y/Lynj28JvkQhl9/eShwNh3R6jx5CgWM61OHZ6Zp
         Yk9l+tyxfEbcSzqhoTy9AaA9u3pnRASmFW0ZWeEF1A8gqrU/H2n/hiQ2uzmWLMjW/aJi
         k2ETb3xRcknFDkTmAvrSePubkiVsXs2bP3eeFvnU8290EX60BfNVJZFWxfAvUedNmS0G
         6SDViPGmLkZh5Dh7FmagAYylF9ee5pp0DayJQdYBli/GkiNzgayO5ix6b9dTf47TPGMe
         mRrmHDjpBvsNy9IF2yJ1VkzE4iLISE9Vl7siWVngSYHAyAZ7BbfBUBUVo6NqoFIfQhji
         fKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=d9i+bN0RKpp8w2BxTsuDGABqK025+FmhXSHTHeUl67I=;
        b=Zku9uq4B48pptqxfoqkzWnc4YME/63ZVlYXNiLR7sNLzVcCT7fwUxGLIJZTN1ZRSeM
         GMnundZ1PBUm2HW3CJne5l8EThxB2vMtcsP5FPp4eVxONj2A7fVRbtit0BlvBT/oRfe7
         bXK/j1bL97ncnFzScpH8TF1sicd8jd7eRMuJDaoIM9DWzo+uvXFVVFvBa87Bct3p3SY+
         m/RM/8qy9wlPDWn422CfZ0q/vHFzOM5H5GRxAhG+Mf7ofWT5L6DxXahhMkbzvn/pWTJi
         DEPgCPNUIhGzw2JlCfJOSytaB/d86O6gcdalpaV3pgvktVbikoOQWX8ycj7hxjZUeDHL
         K+TA==
X-Gm-Message-State: APjAAAWeWjzOcP9jcNzoRWcW0umnRleY4fuPXgaDqbgAR6N29BaMeTEo
        NGZqTIQ4Qmnm+aDBBsHgGYA=
X-Google-Smtp-Source: APXvYqzikvg3Mg4DOfY8Y8M55Q8knJTBqVzDV/OQSnDKCiJ+SKFhS2r+O6zQBuy2YXHGg/1/YMX96w==
X-Received: by 2002:ac2:551a:: with SMTP id j26mr20684904lfk.59.1552379911992;
        Tue, 12 Mar 2019 01:38:31 -0700 (PDT)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id j23sm1460863lfb.17.2019.03.12.01.38.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 01:38:31 -0700 (PDT)
Subject: Re: [Xen-devel][PATCH v5 0/1] cameraif: add ABI for para-virtual
 camera
To:     hverkuil@xs4all.nl
References: <20190312082000.32181-1-andr2000@gmail.com>
Cc:     "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <5f76bde5-bfbd-0241-b65d-6cd65c4d0613@gmail.com>
Date:   Tue, 12 Mar 2019 10:38:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190312082000.32181-1-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello, Hans!

This is the version of the protocol with minor comments addressed
(that you had on v4). Hope this now looks OK.

Thank you,
Oleksandr

On 3/12/19 10:19 AM, Oleksandr Andrushchenko wrote:
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
>
> Oleksandr Andrushchenko (1):
>    cameraif: add ABI for para-virtual camera
>
>   xen/include/public/io/cameraif.h | 1370 ++++++++++++++++++++++++++++++
>   1 file changed, 1370 insertions(+)
>   create mode 100644 xen/include/public/io/cameraif.h
>

