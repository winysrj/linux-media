Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49746 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbeEENcF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 09:32:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT FIXES FOR v4.17] UVC fixes
Date: Sat, 05 May 2018 16:32:19 +0300
Message-ID: <3875430.XimFTxnfmR@avalon>
In-Reply-To: <20180505073538.3999f6b0@vento.lan>
References: <2618618.x2Pkc03X4B@avalon> <20180505073538.3999f6b0@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Saturday, 5 May 2018 13:35:38 EEST Mauro Carvalho Chehab wrote:
> Em Wed, 25 Apr 2018 03:37:00 +0300 Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > The following changes since commit 
60cc43fc888428bb2f18f08997432d426a243338:
> >   Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)
> > 
> > are available in the Git repository at:
> >   git://linuxtv.org/pinchartl/media.git uvc/fixes
> > 
> > for you to fetch changes up to 3f22b63e8a488156467da43cdf9a3a7bd683f161:
> >   media: uvcvideo: Prevent setting unavailable flags (2018-04-25 03:16:42
> > 
> > +0300)
> 
> Not sure what happened here, but this e-mail is completely mangled.
> This way, patchwork won't parse it.
> 
> I manually applied it, but next time please check if your emailer
> is not messing with pull requests.

I really don't know what happened, I've used the same mailer as usual, nothing 
changed in my workflow :-/ I'll keep an eye on that when submitting the next 
pull request.

Thank you for applying the patch.

> > ----------------------------------------------------------------
> > 
> > Kieran Bingham (1):
> >       media: uvcvideo: Prevent setting unavailable flags
> >  
> >  drivers/media/usb/uvc/uvc_ctrl.c | 17 +++++++++--------
> >  1 file changed, 9 insertions(+), 8 deletions(-)

-- 
Regards,

Laurent Pinchart
