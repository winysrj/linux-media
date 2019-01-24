Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1EDC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4883C2184C
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:37:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRGLNl8f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfAXIhq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:37:46 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36331 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfAXIhq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:37:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id n2so2366495pgm.3;
        Thu, 24 Jan 2019 00:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wnumqVFJVxZ/K0VhKYmHx1yjwFa79MKRt6NJCNkW9tM=;
        b=PRGLNl8fps2o7bI9WHbxpKSLLlhbbEpLeZfMF/8MSBXRj+N/Vr1h84YL0z5+sAoeh7
         4ERbZN2dhNtfvYk9JkQ2G9AR7/5Nw0m+vffCKVSIhOGl7uQUVoT8mYLOrGeK1XHqE8rn
         PERtOXLq2pBR1g2XDqehjCfGsguF+Fp6GOqeV+O7UJXDaPQRlAOK54qPiYrnw7DcsA4R
         8epSVLnl13fpUyLxqnrhFrBXigIrMR0HXenMTeehfJIAEZZ3UgchvOBwPSgaW8ImG+Be
         eKwtVZXf3DXj7xoz5WCGv+Lfwj+B7H6Ro/ArDtMgaVhQmH2rlGNtztKpu9KpeRe6okFD
         pw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wnumqVFJVxZ/K0VhKYmHx1yjwFa79MKRt6NJCNkW9tM=;
        b=NjjQM2XJASEVRvWDHcShXfzo6vzmnqNHsbp67+fevfNOrtuJWuX15TL1147ZI5Y6jV
         Nx91a7ZzLAjXiXtGVNL5Xy6vSKmylWkCPqVlc77Idv197vybL1XuU4/bCHMRLVp5cTDK
         Ri5b6mCtkKeiG4uHVSPhdqG6gU+3lnxcbLwDk5YSKXhJ0G34IPAsZwSfnY/d0FVjZqbh
         2fNCcRF9yH1jD6yfNf3f5fwkf9zIPZfPqw0axDImDpkwCRuk169sXhkGcEwtHaj5g6tQ
         bLNZ+UiVBYxRFdbOqnD9kkR2Wg4wC/9+RDA/zxmGK49IyRa3d6iFz90jEiNTdXWq3I51
         izGw==
X-Gm-Message-State: AJcUukckkgwov2PDKTi2DxdYXyp0rbCjkvhyIwYHi1lMB7x6CKB480La
        QaNOloWnqFvYShgcIZJQeyk=
X-Google-Smtp-Source: ALg8bN4wD8W+O9Ggs6w9TKqiSrXFJVLOIMCNYcB2zyPkZg0oEyBGzaQPaZl7Lz1lBIWcBq7Ji2xQ4A==
X-Received: by 2002:a63:f047:: with SMTP id s7mr5068572pgj.441.1548319064773;
        Thu, 24 Jan 2019 00:37:44 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id t12sm31458895pfi.45.2019.01.24.00.37.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 00:37:43 -0800 (PST)
Date:   Thu, 24 Jan 2019 00:37:42 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     VDR User <user.vdr@gmail.com>
Cc:     Bastien Nocera <hadess@hadess.net>, linux-input@vger.kernel.org,
        Sean Young <sean@mess.org>, mchehab+samsung@kernel.org,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] Input: Add missing event codes for common IR remote
 buttons
Message-ID: <20190124083742.GB139904@dtor-ws>
References: <20181103145532.9323-1-user.vdr@gmail.com>
 <766230a305f54a37e9d881779a0d81ec439f8bd8.camel@hadess.net>
 <CAA7C2qhCmaJJ1F8D6zz0-9Sp+OspPE2h=KYRYO7seMUrs2q=sA@mail.gmail.com>
 <20190119085252.GA187380@dtor-ws>
 <CAA7C2qiKOTKSWgmK_9ZyPC-JaBp+vW0nhoJMPJzHCmV_wsg8_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA7C2qiKOTKSWgmK_9ZyPC-JaBp+vW0nhoJMPJzHCmV_wsg8_A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 22, 2019 at 11:50:50PM -0800, VDR User wrote:
> > >
> > > KEY_DISPLAY_FORMAT doesn't open any menus and is used to cycle through
> > > how video is displayed on-screen to the user; full, zoomed,
> > > letterboxed, stretched, etc. KEY_CONTEXT_MENU would be for something
> > > like bringing up a playback menu where you'd set things like
> > > upscaling, deinterlacing, audio mixdown/mixup, etc.
> >
> > KEY_ASPECT_RATIO (formerly KEY_SCREEN).
> 
> Physical displays have a single set aspect ratio (W/H). Images have
> their own aspect ratios. When the AR of the video to be display and
> the display itself are mismatched, you have to do something
> (letterbox, pillarbox, windowbox) to the video to maintain the correct
> video aspect ratio. You can't change the displays AR, and you aren't
> changing the videos AR so using KEY_ASPECT_RATIO makes no sense. AR
> isn't being touched/altered/manipulated, but how the video is being
> displayed is. Stretching and filling to match the display AR alters
> the video AR so there is makes sense, but then zooming may not. So,
> since "aspect ratio" kind of makes sense in a couple cases, and makes
> no sense in the rest, the more suitable KEY_DISPLAY_FORMAT is my
> suggestion.

No, we will not be renaming this key. We try to have parity with the
HUT, which has the following to say:

"Aspect OSC - Selects the next available supported aspect ratio option
on a device which outputs or displays video.  For example, common
aspect ratio options are 4:3 (standard definition), 16:9 (often used
to stretch a standard definition source signal to a 16:9 video screen),
letter-box and anamorphic widescreen.The order in which the aspect
ratios are selected is implementation specific."

Thanks.

-- 
Dmitry
