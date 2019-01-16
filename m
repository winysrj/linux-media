Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FE4C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 06:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6167F20840
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 06:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SLdNTaQf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387585AbfAPG1N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 01:27:13 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37351 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730888AbfAPG1N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 01:27:13 -0500
Received: by mail-ot1-f68.google.com with SMTP id s13so5446663otq.4
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 22:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z9chB0tioyYAtBLc0Ws2SWX8YCTjSwQeORPTeP3OIzs=;
        b=SLdNTaQfiE87eM6WqzDOQDVy7x2ukHBbO0jxw2MNUtB/xzU0282Vp4RtEYg5K+3FJn
         5B3FwDmAwP1FPtdP9RB94WYITS5OpbEhOq8bC7H3wEKW9ZyPAs2IPxo0cZ6NbzD61fjD
         ICjtDPijVRGvUZz5Oo1lB25yyNprudYnnkNuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z9chB0tioyYAtBLc0Ws2SWX8YCTjSwQeORPTeP3OIzs=;
        b=GMwxm2kbRpDWvsIPkW9c5UT3d+MevaAsJFD7TzBXdFiral7fvjrwfUH2Usi2nAKa+8
         dcGAUtlyn0lmInevIgcroBEssoa6gIx3SJwR2gdf5ftGI8XQzxR9wIWcg/Elj8tvYlGk
         +0fBiLnj1RBcfDwD3MCTh8fWXErs93yh52KJazGlVubNsjU/f5dlSerzaBlcxt7gJ0+3
         ka1ljXjuhTnECB8M7MlsF4HavS2yQSzW8dqRCnlCezJCcsDHGj6VkjnKFImoUFwBVVRq
         wTxrbmdvfVp+rwiSeNMOWWTynRQQ9MfyNVvTNp9vRu6tR6m8MZ2NKA8RZMfmffdeR1Xr
         08mA==
X-Gm-Message-State: AJcUukfF55nR3uk6ccnQ+eabBhcGuB4ViNJ991Nyb9VBGaBa0EYkYVtL
        wj3p/ujzpRtBw8jEeybdjxPacZSf4kE=
X-Google-Smtp-Source: ALg8bN7dXZbQCbfaw2NbdfkgBeA6fjs/jla4s8hzpnZ0o3Hyt5qjseGcQVUhUsSnFOAEkBzIrxauEg==
X-Received: by 2002:a9d:a83:: with SMTP id 3mr4861182otq.88.1547620032310;
        Tue, 15 Jan 2019 22:27:12 -0800 (PST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com. [209.85.210.48])
        by smtp.gmail.com with ESMTPSA id c23sm2328462otn.21.2019.01.15.22.27.11
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 22:27:11 -0800 (PST)
Received: by mail-ot1-f48.google.com with SMTP id a11so5413358otr.10
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 22:27:11 -0800 (PST)
X-Received: by 2002:aca:c2c3:: with SMTP id s186mr3309936oif.173.1547620030705;
 Tue, 15 Jan 2019 22:27:10 -0800 (PST)
MIME-Version: 1.0
References: <20190110121052.10116-1-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20190110121052.10116-1-laurent.pinchart@ideasonboard.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 16 Jan 2019 15:26:59 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BCaRStRM5BFQe8z6tmu==odz8XY8G6bYEsHu2gCp3YTg@mail.gmail.com>
Message-ID: <CAAFQd5BCaRStRM5BFQe8z6tmu==odz8XY8G6bYEsHu2gCp3YTg@mail.gmail.com>
Subject: Re: [PATCH] media: Documentation: staging/ipu3-imgu: Miscellaneous improvements
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Thu, Jan 10, 2019 at 9:09 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Implement miscellaneous changes that have been proposed in review
> comments but not captured, rephrase and clarify parts of the
> documentation, and mark shell code blocks appropriately.
>
> Major changes are still required, included rewriting the examples
> without the v4l2n tool, and documenting the internal blocks of the ImgU.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/media/v4l-drivers/ipu3.rst | 201 +++++++++++------------
>  1 file changed, 94 insertions(+), 107 deletions(-)
>

Thanks for the patch! Some comments inline not directly related to it
and more a material for follow up patches.

Feel free to add my Reviewed-by.

[snip]
> -With ImgU, once the input video node ("ipu3-imgu 0/1":0, in
> -<entity>:<pad-number> format) is queued with buffer (in packed raw Bayer
> -format), ImgU starts processing the buffer and produces the video output in YUV
> -format and statistics output on respective output nodes. The driver is expected
> -to have buffers ready for all of parameter, output and statistics nodes, when
> -input video node is queued with buffer.
> +With ImgU, a buffer is queued on the input video node ("ipu3-imgu 0/1":0, in
> +<entity>:<pad-number> format), the ImgU starts processing the buffer and
> +produces the video output in YUV format and statistics output on respective
> +output nodes. The driver is expected to have buffers ready for all of parameter,

I think it's the driver that actually expects to have buffers ready
for all of the other nodes, not the other way around.

> +output and statistics nodes, when a buffer is queued on the input video node.

AFAICT the behavior at input buffer queue time is that if there is no
buffer queued for the parameters, last parameters are kept and if
there is no buffer queued for any of the CAPTURE buffers, an internal
dummy buffer is used and so effectively the related output of the ISP
gets ignored.

>
>  At a minimum, all of input, main output, 3A statistics and viewfinder
>  video nodes should be enabled for IPU3 to start image processing.

Hmm, wasn't the viewfinder optional?

Best regards,
Tomasz
