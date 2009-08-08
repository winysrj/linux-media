Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60277 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZHHI0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 04:26:04 -0400
Date: Sat, 8 Aug 2009 11:13:32 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Hans Verkuil <hverkuil@xs4all.nl>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv14 6/8] FM TX: si4713: Add files to handle si4713 i2c
 device
Message-ID: <20090808081332.GB21541@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1248707530-4068-1-git-send-email-eduardo.valentin@nokia.com>
 <1248707530-4068-2-git-send-email-eduardo.valentin@nokia.com>
 <1248707530-4068-3-git-send-email-eduardo.valentin@nokia.com>
 <1248707530-4068-4-git-send-email-eduardo.valentin@nokia.com>
 <1248707530-4068-5-git-send-email-eduardo.valentin@nokia.com>
 <1248707530-4068-6-git-send-email-eduardo.valentin@nokia.com>
 <1248707530-4068-7-git-send-email-eduardo.valentin@nokia.com>
 <1249648733.31807.102.camel@masi.ntc.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249648733.31807.102.camel@masi.ntc.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 07, 2009 at 02:38:53PM +0200, Aaltonen Matti.J (Nokia-D/Tampere) wrote:
> Hi.
> 
> On Mon, 2009-07-27 at 17:12 +0200, Valentin Eduardo (Nokia-D/Helsinki)
> wrote:
> > This patch adds files to control si4713 devices.
> > Internal functions to control device properties
> 
> ....
> 
> > + */
> > +/* si4713_probe - probe for the device */
> > +static int si4713_probe(struct i2c_client *client,
> > +                                       const struct i2c_device_id *id)
> > +{
> > +       struct si4713_device *sdev;
> > +       int rval;
> > +
> > +       sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
> > +       if (!sdev) {
> > +               v4l2_err(&sdev->sd, "Failed to alloc video device.\n");
>                            ^^^^^^^^^^
> > +               rval = -ENOMEM;
> > +               goto exit;
> > +       }
> 
> ....
> 
> You shouldn't do sdev->sd if sdev is NULL.

Ok! Thanks for pointing this Matti!


> 
> Cheers,
> Matti
> 
> 
> 
> 
> 
> 

-- 
Eduardo Valentin
