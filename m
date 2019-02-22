Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6D3C10F00
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 13:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E65EE207E0
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 13:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfBVNuQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:50:16 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:36823 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVNuQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 08:50:16 -0500
Received: by mail-ua1-f67.google.com with SMTP id e15so841567uam.3;
        Fri, 22 Feb 2019 05:50:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dAdbDDQBy0/NNVDldqUZgvAEgkb7Wb59ZpVyXtqTBkE=;
        b=slmnnhQpteKBDgwmXVoYt3pDyFW7jQd5Qkl+rDgSSOUaTELs0Y62klOX6xPjePHkZk
         vIgU2j5Tkh4Lca34VTk75VZjPL5rrPWhazRmciIMOTz7MfB5Flz0DSUK1l1Kj6D4TVNh
         ONohN3jk3FLOkMzmwQDolBX9PzH/0pJ05E/QomwZnHTv1BJeN8WagaN/jmAidT+of9wo
         uBCNuf8K5ZubtmKhxEp0zA3yBZUgTeWYGHXwaW4cmQasCN0rRbEQ5t6p6kyXWmp7zZfI
         +ON5ScAHM+40aDm+9rf+KaOcdj2+p9zW8+UsiyAtjEos8NTXRvj1005uqQgn9ymPySBX
         bfLQ==
X-Gm-Message-State: AHQUAua4g1qv49QJcOSLiINDDsuFwOdSEboLGD/eg2Ho3S3EYEwPK4Vl
        BAtfkX82NobJtsi1gLY2qToaV+IBzU+si37Q5iSbV2rA
X-Google-Smtp-Source: AHgI3IYKsyH+REBqBp7SlwyVtPtAdg+C92lZXTWC58sn03UdpxH9V7hOduiFA7Hu8AvcPbKcM49dV3UGi9Kb1F9NxOk=
X-Received: by 2002:a67:78ce:: with SMTP id t197mr2207920vsc.152.1550843414854;
 Fri, 22 Feb 2019 05:50:14 -0800 (PST)
MIME-Version: 1.0
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190221143940.k56z2vwovu3y5okh@uno.localdomain> <20190221223131.rago5jmpxhygtuep@kekkonen.localdomain>
 <20190222084019.62atdkk6qipnugvf@uno.localdomain> <20190222110429.ybmqdwba5rszntb7@paasikivi.fi.intel.com>
 <20190222111747.tlj2xdjhnjwrlqxx@uno.localdomain> <20190222112917.l7sgmdb56jmbnos2@paasikivi.fi.intel.com>
In-Reply-To: <20190222112917.l7sgmdb56jmbnos2@paasikivi.fi.intel.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 22 Feb 2019 14:50:01 +0100
Message-ID: <CAMuHMdUL9trjJ=3SoC8NhWTvf0QwonR_QUZXCCpESS1xqe7mxQ@mail.gmail.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and operations
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On Fri, Feb 22, 2019 at 12:30 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> On Fri, Feb 22, 2019 at 12:17:47PM +0100, Jacopo Mondi wrote:
> > On Fri, Feb 22, 2019 at 01:04:29PM +0200, Sakari Ailus wrote:
> > > You can btw. zero the struct memory by assigning { 0 } to it in
> > > declaration. memset() in general is much more trouble. In this case you
> > > could even do the assignments in delaration as well.
> > >
> >
> > Thanks, noted. I have been lazy and copied memset from other places in
> > the ioctl handling code. I should check on your suggestions because I
> > remember one of the many 0-initialization statement was a GCC specific one,
> > don't remember which...
>
> {} is GCC specific whereas { 0 } is not. But there have been long-standing
> GCC bugs related to the use of { 0 } which is quite unfortunate --- they've
> produced warnings or errors from code that is valid C...

Most of these are gone since commit cafa0010cd51fb71 ("Raise the minimum
required gcc version to 4.6").

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
