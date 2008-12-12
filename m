Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBCCMNNd012396
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 07:22:23 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBCCM9kf008478
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 07:22:09 -0500
Date: Fri, 12 Dec 2008 13:22:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin <gatoguan-os@yahoo.com>
In-Reply-To: <577793.93046.qm@web32104.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0812121308290.4520@axis700.grange>
References: <577793.93046.qm@web32104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux list <video4linux-list@redhat.com>
Subject: Re: Soc-Camera architecture and nomenclature, and I2C in V4L
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Agustin,

On Fri, 12 Dec 2008, Agustin wrote:

> Absolutely. Right now I am connecting 6 MT9P031, the monochrome type, 
> with 12 bits ADC so I think the right format would be 'Y16'.

Hm, actually I think it is not. As you might have seen in the current 
soc-camera sources, we now handle two formats: one from the sensor to the 
host controller driver, and one from the host driver to the user. i.MX31 
can handle 15, 10, 8 and 4 bits, so, you will either have to extend your 
12 bits to 15, or truncate them to 10 or 8. Respectively you will choose 
a suitable format. But - it will have to be "15-bit monochrome", "10-bit 
monochrome", or "8-bit monochrome." Currently I only see 8 and 16 bits 
defined in v4l, so, if you use anything different you will have to define 
it. Yes, I know I used V4L2_PIX_FMT_Y16 in mt9m001 for "monochrome 10 bit" 
- this is wrong, as well as using V4L2_PIX_FMT_SBGGR16 for "Bayer 10 bit," 
I will have to fix this some time.

> Later on I plan to use the complete bus width in the i.MX31 (16 or 15 
> bit?) as 'raw' data, in order to pack pixels and get higher data rate at 
> the same clock.

Maximum 15, but you already use raw data for monochrome, i.MX31 doesn't 
have any special support for it.

> For multiplexing I2C I have a 4-channel I2C switch 'PCA9546A'. This is 
> required as the MT9P031 can only choose among 2 I2C address (an 
> improvement over previous models, insufficient for me though.
> 
> > (a) refers to the controller itself, to its registers if
> > you will. (b) refers to the signals connecting sensors to the
> > controller - syncs, data, clocks...
> 
> I see the use and meaning of (a), regarding (b) I have the feeling that 
> it is something internal to SoC-Camera implementation, as I have not 
> recognized it during the (unfinished) development of my SoC-Camera 
> driver.

I would say all the flags to configure VSYNC, HSYNC, DATA, clock polarity 
belong to (b) and are a part of the soc-camera framework.

> > > Finally, while caring of the I2C stuff in my design I have found some 
> > > I2C 'magic' within V4L API, but I am not quite sure yet. I personally 
> > > prefer to keep them apart V4L and I2C, let my camera driver care of
> > > the way it communicates with its hardware... How is that a sin against
> > > V4L bible? :-)
> > 
> > What exactly do you mean here?
> 
> I mean things like this I see in mt9m001 driver:
> 
> static int mt9m001_get_chip_id(struct soc_camera_device *icd,
> 			       struct v4l2_chip_ident *id)
> {
> 	if (id->match_type != V4L2_CHIP_MATCH_I2C_ADDR)
> 		return -EINVAL;
> [...]
> }
> 
> Where V4L seems to be caring about I2C somehow behind the scenes. And in 
> my case I need full control over what's going on in I2C, as I have 
> something there in the middle (an I2C switch!).

Ok, I see, yes, i2c is a popular (only?) way to control sensors, so, there 
are some references to it in v4l, right.

> I know there is a better way to integrate the I2C switch, I just don't 
> have time now to get to implement a transparent I2C switch driver, since 
> I don't even know where to start from!

I remember seeing some discussions about this recently on i2c ML... Maybe 
you'll be able to Google them.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
