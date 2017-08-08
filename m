Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59920 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751880AbdHHMPP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 08:15:15 -0400
Date: Tue, 8 Aug 2017 15:15:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Fabio Estevam <festevam@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-media <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Subject: Re: [PATCH 1/2] [media] ov7670: Return the real error code
Message-ID: <20170808121511.76mqltaiyeraxkvo@valkosipuli.retiisi.org.uk>
References: <1500435259-5838-1-git-send-email-festevam@gmail.com>
 <20170808112406.gkr2jhedzjkdr2ww@valkosipuli.retiisi.org.uk>
 <CAOMZO5CDVNR563UD-na882hGijaxd6ob9hUt83K_ycqmSCSmgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CDVNR563UD-na882hGijaxd6ob9hUt83K_ycqmSCSmgg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 08, 2017 at 08:56:14AM -0300, Fabio Estevam wrote:
> Hi Sakari,
> 
> On Tue, Aug 8, 2017 at 8:24 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
> > I don't think -EPROBE_DEFER is returned by clk_get() if the clock can't be
> > found. The clock providers often are e.g. ISP drivers that may well be
> 
> Yes, it is.
> 
> Please check:
> 
> commit a34cd4666f3da84228a82f70c94b8d9b692034ea
> Author: Jean-Francois Moine <moinejf@free.fr>
> Date:   Mon Nov 25 19:47:04 2013 +0100
> 
>     clk: return probe defer when DT clock not yet ready
> 
>     At probe time, a clock device may not be ready when some other device
>     wants to use it.
> 
>     This patch lets the functions clk_get/devm_clk_get return a probe defer
>     when the clock is defined in the DT but not yet available.

Nice! I'll apply both then.

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
