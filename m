Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37494 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726247AbeIDOHl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 10:07:41 -0400
Date: Tue, 4 Sep 2018 12:43:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ysato@users.sourceforge.jp, dalias@libc.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Remove sh_mobile_ceu_camera from arch/sh
Message-ID: <20180904094319.om6qp5rc3k66ukrd@valkosipuli.retiisi.org.uk>
References: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
 <20180831122558.zv7537uyfw5pcnqj@valkosipuli.retiisi.org.uk>
 <20180903072234.GA4116@w540>
 <20180904093358.GK20333@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180904093358.GK20333@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 04, 2018 at 11:33:58AM +0200, jacopo mondi wrote:
> Hi again Sakari,
>    sorry, I'm confusing you
> 
> On Mon, Sep 03, 2018 at 09:22:34AM +0200, jacopo mondi wrote:
> > Hi Sakari,
> >
> > On Fri, Aug 31, 2018 at 03:25:58PM +0300, Sakari Ailus wrote:
> > > Hi Jacopo,
> > >
> > > On Mon, May 28, 2018 at 06:37:06PM +0200, Jacopo Mondi wrote:
> > > > Hello,
> > > >     this series removes dependencies on the soc_camera based
> > > > sh_mobile_ceu_camera driver from 3 board files in arch/sh and from one
> > > > sensor driver used by one of those boards.
> > > >
> > > > Hans, this means there are no more user of the soc_camera framework that I know
> > > > of in Linux, and I guess we can now plan of to remove that framework.
> > >
> > > What's the status of this set? I think it'd be nice to get it in; the CEU
> > > driver is the last using SoC camera framework.
> > >
> 
> The series went in in the media tree in late June and I now see it in
> v4.19-rc2.

Oh; I missed this entirely. I thought it'd be merge later as there were
comments. Anyway it's good it's in. :-)

> 
> Sorry for the confusion.
> 
> The other soc_camera series which is pending for approval is the one
> removing dependencies on the framework from some SH defconfigs:
> https://lkml.org/lkml/2018/7/4/323

Given this series is in the current Linus's tree, that seems like a
no-brainer now.

> 
> Mauro was exitant to take this one through the media tree, and he's
> probably right SH maintainers should at least ack the series. So far,
> I haven't heard from them.
> 
> I'll try to rebase it on latest version and re-send.

If you have further changes, please make them in separate patches.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
