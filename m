Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56627 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936340AbdJQPYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 11:24:47 -0400
Message-ID: <1508253881.6854.14.camel@pengutronix.de>
Subject: Re: [PATCH][MEDIA]i.MX6 CSI: Fix MIPI camera operation in RAW/Bayer
 mode
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Fabio Estevam <festevam@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>
Date: Tue, 17 Oct 2017 17:24:41 +0200
In-Reply-To: <20171017135324.GM20805@n2100.armlinux.org.uk>
References: <m3fuail25k.fsf@t19.piap.pl>
         <CAOMZO5A6PYfXz6T4ZTs7M3rtUZLKOjf636i-v6uCjxNfxETQyQ@mail.gmail.com>
         <m3376hlxc4.fsf@t19.piap.pl> <20171017135324.GM20805@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-10-17 at 14:53 +0100, Russell King - ARM Linux wrote:
> On Tue, Oct 17, 2017 at 03:26:19PM +0200, Krzysztof Hałasa wrote:
> > Fabio Estevam <festevam@gmail.com> writes:
> > 
> > > > --- a/drivers/staging/media/imx/imx-media-csi.c
> > > > +++ b/drivers/staging/media/imx/imx-media-csi.c
> > > > @@ -340,7 +340,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
> > > >         case V4L2_PIX_FMT_SGBRG8:
> > > >         case V4L2_PIX_FMT_SGRBG8:
> > > >         case V4L2_PIX_FMT_SRGGB8:
> > > > -               burst_size = 8;
> > > > +               burst_size = 16;
> > > >                 passthrough = true;
> > > >                 passthrough_bits = 8;
> > > >                 break;
> > > 
> > > Russell has sent the same fix and Philipp made a comment about the
> > > possibility of using 32-byte or 64-byte bursts:
> > > http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2017-October/111960.html
> > 
> > Great.
> > 
> > Sometimes I wonder how many people are working on exactly the same
> > stuff.
> 
> I do wish the patch was merged (which fixes a real problem) rather than
> hanging around for optimisation questions.  We can always increase it
> in the future if it's deemed that a larger burst size is beneficial.

I am sorry, that patch should have been part of last week's pull
request. I'll send another one for -rc6.

regards
Philipp
