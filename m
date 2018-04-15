Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:37463 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbeDOUfw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 16:35:52 -0400
Received: by mail-lf0-f53.google.com with SMTP id b23-v6so233110lfg.4
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 13:35:51 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sun, 15 Apr 2018 22:35:49 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180415203549.GE20093@bigcity.dyn.berto.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <2180075.m4Wkig6IL5@avalon>
 <CAMuHMdXoprxZNP6KuYjcYW5EYjzAAFqNn6orK24pv7k_fO+i4A@mail.gmail.com>
 <1571834.H8Xd6h4YlB@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1571834.H8Xd6h4YlB@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert and Laurent,

Thanks for the feedback.

On 2018-04-05 11:26:45 +0300, Laurent Pinchart wrote:

[snip]

> > Alternatively, you could check for a valid number of lanes, and use
> > knowledge about the internal lane bits:
> > 
> >     phycnt = PHYCNT_ENABLECLK;
> >     phycnt |= (1 << priv->lanes) - 1;
> 
> If Niklas is fine with that, I like it too.

I'm fine what that thanks for the suggestion Geert!

-- 
Regards,
Niklas Söderlund
