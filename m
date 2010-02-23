Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47214 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab0BWSNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 13:13:09 -0500
Subject: My TV's standard video controls (Re: Chroma gain configuration)
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <1266939223.4589.48.camel@palomino.walls.org>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <201002222254.05573.hverkuil@xs4all.nl>
	 <829197381002221400i6e4f4b17u42597d5138171e19@mail.gmail.com>
	 <201002230853.36928.hverkuil@xs4all.nl>
	 <1266934843.4589.20.camel@palomino.walls.org>
	 <afc23983d22d02e5832ce68b75f35890.squirrel@webmail.xs4all.nl>
	 <1266939223.4589.48.camel@palomino.walls.org>
Content-Type: text/plain
Date: Tue, 23 Feb 2010 13:11:51 -0500
Message-Id: <1266948711.3090.41.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-02-23 at 10:33 -0500, Andy Walls wrote:
> On Tue, 2010-02-23 at 15:41 +0100, Hans Verkuil wrote:
> > > On Tue, 2010-02-23 at 08:53 +0100, Hans Verkuil wrote:
> > >> On Monday 22 February 2010 23:00:32 Devin Heitmueller wrote:
> > >> > On Mon, Feb 22, 2010 at 4:54 PM, Hans Verkuil <hverkuil@xs4all.nl>
> > >> wrote:
> > >
> > >> > Of course, if you and Mauro wanted to sign off on the creation of a
> > >> > new non-private user control called V4L2_CID_CHROMA_GAIN, that would
> > >> > also resolve my problem.  :-)
> > >>
> > >> Hmm, Mauro is right: the color controls we have now are a bit of a mess.
> > >> Perhaps this is a good moment to try and fix them. Suppose we had no
> > >> color
> > >> controls at all: how would we design them in that case? When we know
> > >> what we
> > >> really need, then we can compare that with what we have and figure out
> > >> what
> > >> we need to do to make things right again.
> 
> > Let me rephrase my question: how would you design the user color controls?
> 
> > E.g., the controls that are exported in GUIs to the average user.
> 
> Look at the knobs on an old TV or look at the menu on more modern
> televisions:
> 
> 1. Hue (or Tint) (at least NTSC TVs have this control)
> 2. Brightness
> 3. Saturation
> 
> These are the three parameters to which the Human Visual System
> sensitive.

These are the video controls exposed on the standard user menu of my
Sony KDP-51WS655 TV:


Name
TV's Help comment
Control type
My comments

Picture
Picture white level
Slider: 0 to Max
(No comment)

Brightness
Picture black level
Slider: 0 to Max
(No comment)

Color
Color saturation
Slider: 0 to Max
"UV Saturation"

Hue
Green/Red Tones
Slider: R 31 to 0 to G 31
Called "Tint" on older NTSC TV's, it doesn't give complete control over hue

Sharpness
Picture detail
Slider: 0 to Max
"Contrast"

Color Temp
Color Temperature
Enumerated options:
	Cool
	Bluish-white
	like a "daylight" light bulb

	Neutral
	Neutral
	(No comment)

	Warm
	Reddish-White (NTSC standard)
	like a "soft white" light bulb
Dominant color of light in the image. "Temperature" corresponds to the mean color of light from a blackbody radiator at such a temperature IIRC

ClearEdge VM
Edge enhancement
Enumerated options: High, Medium, Low, Off
(No comment)



Advanced Video controls available via the normal user menu:


Color Axis
Adjust red color axis
Enumerated values:
	Default
	Emphasize red colors
	(No comment)

	Monitor
	De-emphasize red colors
	(No comment)
I have no idea what this control is good for.

Noise Reduction
Reduces repetative random noise
Boolean: on/off
I suspect this may be Luma and Chroma coring.  I'm not sure.



The Service mode menu is available via pushing buttons on the remote:
DISPLAY, 5, VOL +, POWER ON

The service control and status options are cryptic and numerous.  I
suppose setting these wrong and saving would be akin to writing the
wrong values in the I2C EEPROM on one's video card.  (I will note the QM
INFO menu has a fascinating amount of status available.)

Regards,
Andy

