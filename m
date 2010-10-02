Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:46290 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751118Ab0JBIDr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Oct 2010 04:03:47 -0400
Date: Sat, 2 Oct 2010 10:03:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <mgr@pengutronix.de>
cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: Re: [PATCH v2 10/11] mt9m111: rewrite set_pixfmt
In-Reply-To: <Pine.LNX.4.64.1009042234400.24729@axis700.grange>
Message-ID: <Pine.LNX.4.64.1010021003190.14599@axis700.grange>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280833069-26993-11-git-send-email-m.grzeschik@pengutronix.de>
 <Pine.LNX.4.64.1008271335200.28043@axis700.grange> <871v9hmdoz.fsf@free.fr>
 <20100831074605.GC15967@pengutronix.de> <Pine.LNX.4.64.1009042234400.24729@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Michael, any insight?

Thanks
Guennadi

On Sat, 4 Sep 2010, Guennadi Liakhovetski wrote:

> On Tue, 31 Aug 2010, Michael Grzeschik wrote:
> 
> > Hi Robert and Guennadi
> > 
> > On Sun, Aug 29, 2010 at 09:17:00PM +0200, Robert Jarzmik wrote:
> > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> > > 
> > > > Robert, I'll need your ack / tested by on this one too. It actually 
> > > > changes behaviour, for example, it sets MT9M111_OUTFMT_FLIP_BAYER_ROW in 
> > > > the OUTPUT_FORMAT_CTRL register for the V4L2_MBUS_FMT_SBGGR8_1X8 8 bit 
> > > > Bayer format. Maybe other things too - please have a look.
> > > 
> > > For the YUV and RGB formats, tested and acked.
> > > For the bayer, I don't use it. With row switch, that gives back:
> > > byte offset: 0 1 2 3
> > >              B G B G
> > >              G R G R
> > > 
> > > Without the switch:
> > > byte offset: 0 1 2 3
> > >              G R G R
> > >              B G B G
> > > 
> > > I would have expected the second version (ie. without the switch, ie. the
> > > original version of mt9m111 driver) to be correct, but I might be wrong. Maybe
> > > Michael can enlighten me here.
> > Yes this seems odd, i normaly expect the first line to be BGBG.
> > I will search for the cause and reply a little later, perhaps end of
> > the week, since i am also short on time at this moment.
> 
> Ok, _if_ you have to redo this patch, maybe you could also merge
> 
> [PATCH 04/11] mt9m111: added new bit offset defines
> [PATCH 08/11] mt9m111: added reg_mask function
> 
> into it, otherwise their purpose is unclear.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
