Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46466 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBKL7h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 06:59:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 35/47] adv7604: Add sink pads
Date: Tue, 11 Feb 2014 13:00:39 +0100
Message-ID: <3580605.MqbMpcI5hW@avalon>
In-Reply-To: <52F9F934.9090202@xs4all.nl>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-36-git-send-email-laurent.pinchart@ideasonboard.com> <52F9F934.9090202@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 11 February 2014 11:19:32 Hans Verkuil wrote:
> On 02/05/14 17:42, Laurent Pinchart wrote:
> > The ADV7604 has sink pads for its HDMI and analog inputs. Report them.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/i2c/adv7604.c | 71 +++++++++++++++++++++++++---------------
> >  include/media/adv7604.h     | 14 ---------
> >  2 files changed, 45 insertions(+), 40 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> > index 05e7e1a..da32ce9 100644
> > --- a/drivers/media/i2c/adv7604.c
> > +++ b/drivers/media/i2c/adv7604.c
> > @@ -97,13 +97,25 @@ struct adv7604_chip_info {
> > 
> >   **********************************************************************
> >   */
> > 
> > +enum adv7604_pad {
> > +	ADV7604_PAD_HDMI_PORT_A = 0,
> > +	ADV7604_PAD_HDMI_PORT_B = 1,
> > +	ADV7604_PAD_HDMI_PORT_C = 2,
> > +	ADV7604_PAD_HDMI_PORT_D = 3,
> > +	ADV7604_PAD_VGA_RGB = 4,
> > +	ADV7604_PAD_VGA_COMP = 5,
> > +	/* The source pad is either 1 (ADV7611) or 6 (ADV7604) */
> 
> How about making this explicit:
> 
> 	ADV7604_PAD_SOURCE = 6,
> 	ADV7611_PAD_SOURCE = 1,

I can do that, but those two constants won't be used in the driver as they 
computed dynamically.

> > +	ADV7604_PAD_MAX = 7,
> > +};
> 
> Wouldn't it make more sense to have this in the header? I would really
> like to use the symbolic names for these pads in my bridge driver.

That would add a dependency on the adv7604 driver to the bridge driver, isn't 
the whole point of subdevs to avoid such dependencies ?

-- 
Regards,

Laurent Pinchart

