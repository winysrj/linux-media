Return-path: <linux-media-owner@vger.kernel.org>
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57986 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759297Ab0DBHoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 03:44:10 -0400
Date: Fri, 2 Apr 2010 09:44:00 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Richard =?iso-8859-15?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-ID: <20100402074400.GB28382@gundam.enneenne.com>
References: <20100219174451.GH21778@enneenne.com> <Pine.LNX.4.64.1002192018170.5860@axis700.grange> <20100222160139.GL21778@enneenne.com> <4B8310F1.8070005@pelagicore.com> <20100330140611.GR5937@enneenne.com> <20100401114827.GA6573@gundam.enneenne.com> <Pine.LNX.4.64.1004020906330.24014@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.1004020906330.24014@axis700.grange>
Subject: Re: adv7180 as SoC camera device
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 02, 2010 at 09:09:30AM +0200, Guennadi Liakhovetski wrote:
> On Thu, 1 Apr 2010, Rodolfo Giometti wrote:
> 
> > On Tue, Mar 30, 2010 at 04:06:11PM +0200, Rodolfo Giometti wrote:
> > > On Tue, Feb 23, 2010 at 12:19:13AM +0100, Richard Röjfors wrote:
> > > > 
> > > > We use it as a subdev to a driver not yet committed from us. So I think
> > > > you should extend it, not move it.
> > > 
> > > Finally I got something functional... but I'm puzzled to know how I
> > > can add platform data configuration struct by using the I2C's
> > > platform_data pointer if it is already used to hold struct
> > > soc_camera_device... O_o
> > 
> > Here my solution:
> > 
> > static __devinit int adv7180_probe(struct i2c_client *client,
> >                         const struct i2c_device_id *id)
> > {
> >         struct adv7180_state *state;
> > #if defined(CONFIG_SOC_CAMERA)
> >         struct soc_camera_device *icd = client->dev.platform_data;
> >         struct soc_camera_link *icl;
> >         struct adv7180_platform_data *pdata = NULL;
> > #else
> >         struct adv7180_platform_data *pdata =
> > 	client->dev.platform_data;
> > #endif
> 
> No, we don't want any ifdefs in drivers. And the current driver doesn't 
> use the platform data, so, I would just leave it as it is - if NULL - no 
> soc-camera and no platform data, if it set - soc-camera environment is 
> used. That's until we standardise the use of platform data for v4l i2c 
> devices.

Ok. Thanks! :)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
