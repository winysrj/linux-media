Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59486 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbbE1Kfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 06:35:36 -0400
Message-ID: <1432809329.3228.19.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/5] gpu: ipu-v3: Add mem2mem image conversion
 support to IC
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Lucas Stach <l.stach@pengutronix.de>
Date: Thu, 28 May 2015 12:35:29 +0200
In-Reply-To: <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com>
References: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de>
	 <1426674173-17088-3-git-send-email-p.zabel@pengutronix.de>
	 <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

Am Mittwoch, den 27.05.2015, 20:42 +0200 schrieb Jean-Michel Hautbois:
[...]
> > The tiling code has a parameter to optionally round frame sizes up or down
> > and avoid overdraw in compositing scenarios.
> 
> Can you detail what you call "compositing scenarios" ?

I meant using the v4l2 selection API to draw the scaled result into a
compose rectangle in a larger v4l2 capture buffer. To avoid overdrawing
pixels outside of the rectangle, its right edge must be aligned with the
burst size of the rightmost tiles.

[...]
> > @@ -152,6 +203,19 @@ struct ipu_ic {
> >         bool in_use;
> >
> >         struct ipu_ic_priv *priv;
> > +
> > +       struct ipuv3_channel *input_channel_p;
> > +       struct ipuv3_channel *input_channel;
> > +       struct ipuv3_channel *input_channel_n;
> > +       struct ipuv3_channel *output_channel;
> > +       struct ipuv3_channel *rotation_input_channel;
> > +       struct ipuv3_channel *rotation_output_channel;
> > +
> > +       struct list_head image_list;
> > +
> > +       struct workqueue_struct *workqueue;
> > +       struct work_struct work;
> > +       struct completion complete;
> >  };
> 
> As this is a workqueue, it can sleep, and you don't know when it is
> called exactly.
> Can we be sure that it is "real-time" compatible ? If you have this
> scaler after a capture source, and before the coda driver, you can be
> starved of buffers ?
> And you can even have multiple instances of the scaler, so you
> probably can get into troubles if there is not enough buffers on the
> capture and output queues, right ?

When there are no buffers available, the m2m scaler won't run. What do
you mean by "real-time" compatible? We can't make any guarantees that
scaling will be finished in a certain timeframe in general, as the
scaler competes with other hardware units for memory bandwidth, which
often is the limiting factor.
If multiple scaling instances are run on the same IPU, they will take
turns using the IC.

> I have played with it a bit and have been successful having two
> instances on IPU1 and two other on IPU2.
> But I don't know if there can be side effects...

regards
Philipp

