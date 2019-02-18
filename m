Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC62CC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 07:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAFA8218D3
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 07:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rakg7VBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbfBRH0K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 02:26:10 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34497 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbfBRH0K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 02:26:10 -0500
Received: by mail-pg1-f196.google.com with SMTP id i130so8025740pgd.1;
        Sun, 17 Feb 2019 23:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gI2IVNHRseX2/6HJCtg5WpZCFOPz99s8lcwv2ABbK5k=;
        b=rakg7VBLj/A5RlsvA0YDPseiGIPA9XDnFDAB7hVdo+5WF5cO6uW3PTG7nMIBa6wWSt
         KDg16sGpgN4ujt8fqlm1gyPK4NIiX36tcKGUK9WNj0DI7rDNKeTzO+H9fKYBt9ku3PIi
         vwrN+8f7EQekTdYIJsH9EhawQQ/wF8CZkQ1lrY6bkvXz+tl2OhfyolgcucOpCSAX424m
         5TcSj9zDZQpm3Ji8VEwqtrPU1HcKIDyugULdak/oHNsPFFyoKsd2W7Z9v5B0o2ta2fGg
         wO2oktsn8tHAJ8F2jyW2VOOE4FtapzgAw7znkUX/dfRfPbkeQhvLyKvtiN5HOQwYSa+t
         ABpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gI2IVNHRseX2/6HJCtg5WpZCFOPz99s8lcwv2ABbK5k=;
        b=SdpXrdk2I3lA8CFfXAomV61FozeWJfiMRSBmN785psjHd1K/FxLIFp061/6Kio7kZp
         IAmwjAz6q0pGv8CQ1+MC4bJTaa+brMw70A9MZ86KNXeHpPbBXFuEUQB5KUjBaOnWvF24
         F0oY8Bp368lqRLRmUGxq+mHrPRjqxiNXvOTeosY5XUTnoewGlPtTBsgcrHKgEQqPawu+
         4bbe6AftAsOWlyXmitjUFRWR0X8jP4tpQAhmkmLFs2FOxvnNDrFdXG/62lP3dav8Vp/5
         Mg3+jnUKO2HSSMXbgZFkO+Pb9Z9+vIOoS3uxA3kO7rEcm1a0L0NQK8+JBgyZFNjp+QOU
         /NKQ==
X-Gm-Message-State: AHQUAuZGtqg3SKn7zY6B2TdQNsTi87MX9gIQ8b4APUvRJ/0H+YK8VIfI
        gYeBjf/V287IQQ6DA3PNGFY=
X-Google-Smtp-Source: AHgI3IabuMI6d6htCCRWxH3JhttPdAzW4BlHx+qzhIhaYRRwX0Ce86RSFTWikURb1T+n/HSv4UT9WQ==
X-Received: by 2002:a62:4b11:: with SMTP id y17mr23226949pfa.124.1550474768842;
        Sun, 17 Feb 2019 23:26:08 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id 67sm42404591pfl.175.2019.02.17.23.26.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Feb 2019 23:26:08 -0800 (PST)
Date:   Sun, 17 Feb 2019 23:26:06 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/7] [media] doc-rst: switch to new names for Full
 Screen/Aspect keys
Message-ID: <20190218072606.GG242714@dtor-ws>
References: <20190118233037.87318-1-dmitry.torokhov@gmail.com>
 <20190118233037.87318-2-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118233037.87318-2-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 18, 2019 at 03:30:32PM -0800, Dmitry Torokhov wrote:
> We defined better names for keys to activate full screen mode or
> change aspect ratio (while keeping the existing keycodes to avoid
> breaking userspace), so let's use them in the document.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  Documentation/media/uapi/rc/rc-tables.rst | 4 ++--

Mauro, do you want to take this through your tree or I should pick it up
with the patch that does renames in uapi header?

Thanks!

>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/media/uapi/rc/rc-tables.rst b/Documentation/media/uapi/rc/rc-tables.rst
> index c8ae9479f842..57797e56f45e 100644
> --- a/Documentation/media/uapi/rc/rc-tables.rst
> +++ b/Documentation/media/uapi/rc/rc-tables.rst
> @@ -616,7 +616,7 @@ the remote via /dev/input/event devices.
>  
>      -  .. row 78
>  
> -       -  ``KEY_SCREEN``
> +       -  ``KEY_ASPECT_RATIO``
>  
>         -  Select screen aspect ratio
>  
> @@ -624,7 +624,7 @@ the remote via /dev/input/event devices.
>  
>      -  .. row 79
>  
> -       -  ``KEY_ZOOM``
> +       -  ``KEY_FULL_SCREEN``
>  
>         -  Put device into zoom/full screen mode
>  
> -- 
> 2.20.1.321.g9e740568ce-goog
> 

-- 
Dmitry
