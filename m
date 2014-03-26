Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47761 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaCZKB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 06:01:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] adv7611: Set HPD GPIO direction to output
Date: Wed, 26 Mar 2014 11:03:53 +0100
Message-ID: <2189761.hxRNmn9JuL@avalon>
In-Reply-To: <5332A35E.3000504@cisco.com>
References: <1395800929-17036-1-git-send-email-laurent.pinchart@ideasonboard.com> <5332A35E.3000504@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 26 March 2014 10:52:30 Hans Verkuil wrote:
> Hi Laurent,
> 
> Stupid question perhaps, but why is gpiod_set_value_cansleep() removed?
> Does setting the output direction force the value to 0 as well?

The last argument to gpiod_direction_output() sets the initial output level, 
yes.

> On 03/26/14 03:28, Laurent Pinchart wrote:
> > The HPD GPIO is used as an output but its direction is never set. Fix
> > it.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/i2c/adv7604.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > This patch applies on top of the ADV7611 support series queued for v3.16.
> > 
> > diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> > index 51f14ab..b38ebb9 100644
> > --- a/drivers/media/i2c/adv7604.c
> > +++ b/drivers/media/i2c/adv7604.c
> > @@ -2845,7 +2845,7 @@ static int adv7604_probe(struct i2c_client *client,
> >  		if (IS_ERR(state->hpd_gpio[i]))
> >  			continue;
> > 
> > -		gpiod_set_value_cansleep(state->hpd_gpio[i], 0);
> > +		gpiod_direction_output(state->hpd_gpio[i], 0);
> > 
> >  		v4l_info(client, "Handling HPD %u GPIO\n", i);
> >  	}

-- 
Regards,

Laurent Pinchart

