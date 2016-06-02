Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52141 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161475AbcFBT1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2016 15:27:42 -0400
Date: Thu, 2 Jun 2016 21:27:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv5] support for AD5820 camera auto-focus coil
Message-ID: <20160602192737.GA7984@amd>
References: <574049EF.2090208@gmail.com>
 <20160524090433.GA1277@amd>
 <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160531212222.GP26360@valkosipuli.retiisi.org.uk>
 <20160531213437.GA28397@amd>
 <20160601152439.GQ26360@valkosipuli.retiisi.org.uk>
 <20160601220840.GA21946@amd>
 <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 2016-06-02 10:45:45, Sakari Ailus wrote:
> On Thu, Jun 02, 2016 at 12:08:40AM +0200, Pavel Machek wrote:
> > On Wed 2016-06-01 18:24:39, Sakari Ailus wrote:
> > > Hi Pavel,
> > 
> > > > Well, it does not use any dt properties. So there's not really much to
> > > > discuss with dt people...
> > > > 
> > > > Maybe "ad5820" needs to go to list of simple i2c drivers somewhere,
> > > > but...
> > > 
> > > It's an I2C device and it does use a regulator. Not a lot, though, these are
> > > both quite basic stuff. This should still be documented as the people who
> > > write the DT bindings (in general) aren't expected to read driver code as
> > > well. That's at least my understanding.
> > 
> > Yep, you are right, I forgot about the regulator. Something like this?
> > 
> > Thanks,
> > 									Pavel
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > new file mode 100644
> > index 0000000..87c98f1
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> 
> I might use the compatible string as such as a part of the file name. Up to
> you.

Sorry, can't do that, for consistency with other ad* files in the directory.

> > @@ -0,0 +1,20 @@
> > +* Analog Devices AD5820 autofocus coil
> > +
> > +Required Properties:
> > +
> > +  - compatible: Must contain "adi,ad5820"
> > +
> > +  - reg: I2C slave address
> > +
> > +  - VANA-supply: supply of voltage for VANA pin
> > +
> > +Example:
> > +
> > +       /* D/A converter for auto-focus */
> 
> There is definitely D/A conversion happening there but I'm not sure I'd
> characterise the device as such. They're typically called "voice coil
> drivers", perhaps because the devices are similar to a parts of a
> loudspeaker.

Well, I'm pretty sure I did not invent that comment, but I can drop
it.

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
