Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DD7C282CC
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EF2621917
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:31:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SF4oIoew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfBIBbS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 20:31:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37223 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfBIBbS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 20:31:18 -0500
Received: by mail-wm1-f65.google.com with SMTP id x10so1022199wmg.2;
        Fri, 08 Feb 2019 17:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ue+kTTnhwZJlN7KH1RxSPq6F9+rsW1TLTtahEzOTXdg=;
        b=SF4oIoew95mOs/d+z3RERph38b4fIzBlYaxhez3AHe5AdaaSGgyQkejP7Vq9NXrou9
         fPQ/eNjotVn+oKykYZ6W/VuVADXo63xN9YHtbeFFhMqfy995j1bB0OdaH+URJhf2v5hF
         PhtMNakgKbs9YWy6Zqumb4Z3wrhf0k3aMWj1ms56D4elQKdIguPLadB+ESM6mIx5/jJk
         REIkT3Ia5ZZjWeNWXvkdkJBnVtfmcjK1B58vbdNp7kKZybBtzbjLgv9/B52CTmqLGpcv
         Nh0CwkNGjnBsy3o1S2/VXLoZhsWOYPZagGK/hujG+ianKThu2xX355lH6EBHRJ5HWn9a
         s6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ue+kTTnhwZJlN7KH1RxSPq6F9+rsW1TLTtahEzOTXdg=;
        b=hhIE7WKEplkBQ70JI6eJ2xE3a9ugLHENIcCES7djJ6V7lTADNsyHL+W1umlNXff6Mv
         oV4ch6cMdppeLsONLRG1vH1kdic9NY36ZBrsMES9e08VsM8+tTDTy0CsOhwoqfK2CYxZ
         gPsAkLqtPlN54B7RVgB/f071l26kfvcLHHzuACnTT9C2fDjtILc+GF0jFYY4k2NByU79
         3hv3W7m+DOTrgdQz0SOgBS4b4SJH78l5UblFjxPibGGD/HOSLy/RjxiySrFAV5sMbFlP
         SlBxc76f/hvrNraOaFYMZdBkCtTBG999rgt6oNsBEwbCVIt4L37tU4aezycG2tC3q72T
         fPUA==
X-Gm-Message-State: AHQUAuYCFWJBZYYLbvWcfakZTneiFSugw0sJ+bJNZjEeqIa2tFhoU3gU
        Bz1ESHjb1+a3Z99apWxeCzubgbg0
X-Google-Smtp-Source: AHgI3IYsrpubZr+4qySbe0QX0Vm7JhhnH5uRuGocvJAx2MAfbpx5CEk2uf25rh+P1xjGLxdFg9yY8w==
X-Received: by 2002:a1c:f707:: with SMTP id v7mr1032512wmh.18.1549675875284;
        Fri, 08 Feb 2019 17:31:15 -0800 (PST)
Received: from [172.30.89.46] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id a12sm5958566wrm.45.2019.02.08.17.31.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 17:31:14 -0800 (PST)
Subject: Re: [PATCH v3 3/4] gpu: ipu-v3: ipu-ic: Add support for BT.709
 encoding
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
References: <20190208192844.13930-1-slongerbeam@gmail.com>
 <20190208192844.13930-4-slongerbeam@gmail.com>
 <CAJ+vNU1O9E1Y=tvLvcL=0nrg6STwLxQFqOgfQpqvbTgPi4yo5w@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <f02aa3a8-1767-d92d-a80e-0b618f9119a3@gmail.com>
Date:   Fri, 8 Feb 2019 17:31:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU1O9E1Y=tvLvcL=0nrg6STwLxQFqOgfQpqvbTgPi4yo5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/8/19 4:20 PM, Tim Harvey wrote:
> On Fri, Feb 8, 2019 at 11:28 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>>          if (inf == outf)
>>                  params = &ic_csc_identity;
>>          else if (inf == IPUV3_COLORSPACE_YUV)
>> -               params = &ic_csc_ycbcr2rgb_bt601;
>> +               params = &ic_csc_ycbcr2rgb;
>
> Steve,
>
> compile issue...
>
> params = params_yuv2rgb;
>
>>          else
>> -               params = &ic_csc_rgb2ycbcr_bt601;
>> +               params = &ic_csc_rgb2ycbcr;
> params = params_rgb2yuv;

Wow, did I not even compile test that? Must be my head cold :-/
Sending v4.

>
> But, I'm still failing when using the mem2mem element (gst-launch-1.0
> v4l2src device=/dev/video4 ! v4l2video8convert
> output-io-mode=dmabuf-import ! fbdevsink) with 'Unsupported YCbCr
> encoding' because of inf=IPU_COLORSPACE_YCBCR outf=IPU_COLORSPACE_RGB
> and a seemingly unset encoding being passed in.
>
> It looks like maybe something in the mem2mem driver isn't defaulting
> encoding. The call path is (v4l2_m2m_streamon -> device_run ->
> ipu_image_convert_queue -> convert_start -> ipu_ic_task_init_rsc ->
> init_csc).

Looking at v7 of the mem2mem driver, it will set ycbcr_enc at the output 
side to V4L2_YCBCR_ENC_DEFAULT if colorspace is default. So colorspace 
will need to be set to something non-default in addition to setting 
ycbcr_enc, at the output side. I don't know whether gstreamer 
v4l2videoNconvertelement will do this, but you could hack the driver for 
now to get around it, and let Philipp know this may need a workaround in 
mem2mem for v8.

Steve
