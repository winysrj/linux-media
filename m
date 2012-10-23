Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57784 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933606Ab2JWUHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 16:07:16 -0400
Date: Tue, 23 Oct 2012 23:07:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, s.nawrocki@samsung.com,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC/PATCH] v4l: Add V4L2_CID_FLASH_HW_STROBE_MODE control
Message-ID: <20121023200710.GE23685@valkosipuli.retiisi.org.uk>
References: <1323115006-4385-1-git-send-email-snjw23@gmail.com>
 <20111205224155.GB938@valkosipuli.localdomain>
 <4EE364C7.1090805@gmail.com>
 <5079B869.3040609@gmail.com>
 <507A82DB.9070104@gmail.com>
 <20121014183032.GD21261@valkosipuli.retiisi.org.uk>
 <507DD597.4050907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507DD597.4050907@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, Oct 16, 2012 at 11:45:59PM +0200, Sylwester Nawrocki wrote:
> On 10/14/2012 08:30 PM, Sakari Ailus wrote:
> > Currently the flash control reference states that "The V4L2 flash controls
> > are intended to provide generic access to flash controller devices. Flash
> > controller devices are typically used in digital cameras".
> > 
> > Whether or not higher level controls should be part of the same class is a
> > valid question. The controls intended to expose certain frames with flash
> > are quite different from those used to control the low-level flash chip: the
> > user is fully responsible for timing and the flash sequence.
> > 
> > For higher level controls that could be implemented using the low-level
> > controls for the end user, the user would likely prefer to say things like
> > "please give me a frame exposed with flash". Since the timing is no longer
> > implemented by the user, the user would need to know which frames have been
> > exposed and how, at least in a general case. Getting around this could
> > involve configuring the sensor before starting streaming. Perhaps this is an
> > assumption we could accept now, before we have proper means for passing
> > frame-related parameters to user space.
> 
> Yes, right. This auto strobe control seems to be a higher level one, since
> we have a firmware program that is taking care of some things that normally
> would be done through the existing Flash class controls by a user space
> application/library.
> 
> I'm not really sure if we need a new class. It's even hard to name it.
> I don't see such an auto strobe control as a high level one, from an end 
> application POV. It's more like the existing controls are low level.

After thinking about it awhile, an alternative I see to this is to put it to
the camera class. It's got other high level controls as well, those related
to e.g. AF. I have to admit I'm not certain which one would be a better
choice in the long run. I'm leaning towards the camera class, though.

Say, if you'd create low level controls for lens movement, you probably
wouldn't put them to the existing camera class. They wouldn't seem to fit
there.

Laurent, Hans, others: do you have an opinion on this?

> With V4L2 device profiles, when eventually we create them... it might not
> matter if we create separate flash control class for flash controllers,
> camera sensors, each one low or high level.
> 
> I agree with your remarks regarding pre-configuring a sensor. Frame meta
> data could carry relevant information, but so far we don't have standard
> solution for that.

Agreed. But as long as we assume there's streamoff, we don't even need one.

> >>> V4L2_CID_FLASH_HW_STROBE_AUTO
> >>>
> >>> with options:
> >>> 	V4L2_FLASH_HW_STROBE_OFF
> >>> 	V4L2_FLASH_HW_STROBE_AUTO
> >>> 	V4L2_FLASH_HW_STROBE_ON
> >>
> >> The _HW prefix probably needs to be removed there.
> > 
> > V4L2_CID_FLASH_STROBE_AUTO sounds good to me as such.
> > 
> > Do you always need to streamoff first, after which these the sensors perform
> > a single capture with flash enabled, or how does it work? How about the
> > subsequent captures; will they be done with flash enabled as well (requiring
> > a possible flash cool-off time) or will the flash be disabled for them?
> 
> Currently a streamoff is needed in general. The pipeline needs to be
> reconfigured for different resolution/image format. The flash should be 
> fired as configured per each capture request. I imagine sensor could delay 
> actual capture when the Flash is not ready, due to required cool-off/
> re-charge time. Such an information would need to be provided to the sensor 
> somehow, e.g. with a private ioctl. I don't have much experience yet with 
> more advanced Flash circuits/controls. 

The simple flash controller chips I'm familiar with don't have such fancy
features. One just has to be patient with commanding the LED. :)

If there was a sensor that can do this automatically, then why not?

> So V4L2_FLASH_STROBE_ON would mean, for each executed capture request the 
> Flash is to be triggered unconditionally.
> 
> > For something more complex we'd require something else than a control
> > interface; possibly a private IOCTL to set frame-specific flash parameters.
> 
> Yes, I agree with that. Per frame meta data is needed to figure out, e.g. 
> which frame has been exposed with flash and which one without.

This was discussed in Cambourne last year. The frame parameters could be
given with a single IOCTL (possibly private or not), and the results would
be available on a plane of a multi-plane buffer. More in the meeting notes.

<URL:http://www.digipedia.pl/usenet/thread/18550/849/>

> > Albeit I think that this control would be very different from what the rest
> > of the controls in the class do, I don't see a better place for it either. I
> > wouldn't mind hearing others' opinions, though.
> 
> Maybe we could consider just documenting this kind of controls in a separate 
> section ?
> 
> >> OTOH it seems V4L2_CID_FLASH_LED_MODE and V4L2_CID_FLASH_TORCH_INTENSITY
> >> could do the same. V4L2_CID_FLASH_LED_MODE would be switching between
> >> Flash and Torch function and V4L2_CID_FLASH_TORCH_INTENSITY would be
> >> turning flash LED on/off.
> > 
> > You don't even need to set torch intensity. I'd suppose this is maximum by
> > default, or may not be controllable in the first place. All you need to do
> > to turn the flash off is to set the V4L2_CID_FLASH_LED_MODE to
> > V4L2_FLASH_LED_MODE_NONE. If you want torch, set it to
> > V4L2_FLASH_LED_MODE_TORCH.
> 
> Indeed, thanks for opening my eyes. :)
> 
> > I wonder if TC_FLASH_CONT_ENABLE enables torch, or something else.
> 
> Yes, it just enables the LED permanently.
> 
> > What about pre-flash? :-)
> 
> Good question, I think an interface to adjust this feature is needed as well.
> So parameters like pre-flash count, time period between pre-and main flash 
> strobe, or pre-flash status can be configured/retrieved. My knowledge is 
> rather limited on that topic yet though.

Same for me. I somehow feel we're not binding ourselves if we implement such
a control without considering pre-flash. I reckon pre-flash is often done
with a different sensor configuration (output resolution and frame rate).

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
