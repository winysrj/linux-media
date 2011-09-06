Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51080 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab1IFJJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 05:09:16 -0400
Date: Tue, 6 Sep 2011 12:09:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Bastian Hecht <hechtb@googlemail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH] media: Add camera controls for the ov5642 driver
Message-ID: <20110906090910.GD1393@valkosipuli.localdomain>
References: <20110831212010.GS12368@valkosipuli.localdomain>
 <Pine.LNX.4.64.1109010911550.21309@axis700.grange>
 <20110901084722.GV12368@valkosipuli.localdomain>
 <4E5F4CE0.8050909@samsung.com>
 <20110901120801.GA12368@valkosipuli.localdomain>
 <CABYn4sx8s0nX5iooKM4XHs1Ard_nLS4ppB848EpGLS4bQbemyw@mail.gmail.com>
 <20110906065313.GB1393@valkosipuli.localdomain>
 <CABYn4sxWHRWqNTtsisNvwUr+ZG5djLA-f5GNCf72i6q983tGNg@mail.gmail.com>
 <20110906082739.GC1393@valkosipuli.localdomain>
 <CABYn4sxob_OXJ3cHF+CmOB+68C2T4XznjcXm7s1n_YwbXAwYwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABYn4sxob_OXJ3cHF+CmOB+68C2T4XznjcXm7s1n_YwbXAwYwg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 06, 2011 at 09:01:15AM +0000, Bastian Hecht wrote:
> 2011/9/6 Sakari Ailus <sakari.ailus@iki.fi>:
> > On Tue, Sep 06, 2011 at 07:56:40AM +0000, Bastian Hecht wrote:
> >> Hello Sakari!
> >
> > Hi Bastian,
> >
> >> 2011/9/6 Sakari Ailus <sakari.ailus@iki.fi>:
> >> > Hi Bastian,
> >> >
> >> > On Mon, Sep 05, 2011 at 09:32:55AM +0000, Bastian Hecht wrote:
> >> >> 2011/9/1 Sakari Ailus <sakari.ailus@iki.fi>:
> >> >> > On Thu, Sep 01, 2011 at 11:14:08AM +0200, Sylwester Nawrocki wrote:
> >> >> >> Hi Sakari,
> >> >> >>
> >> >> >> On 09/01/2011 10:47 AM, Sakari Ailus wrote:
> >> >> >> > On Thu, Sep 01, 2011 at 09:15:20AM +0200, Guennadi Liakhovetski wrote:
> >> >> >> >> On Thu, 1 Sep 2011, Sakari Ailus wrote:
> >> >> >> >>
> >> >> >> >>> On Wed, Aug 31, 2011 at 03:27:49PM +0000, Bastian Hecht wrote:
> >> >> >> >>>> 2011/8/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> >> >> >> >>> [clip]
> >> >> >> >>>>> If I'm not mistaken V4L2_CID_PRIVATE_BASE is deprecated.
> >> >> >> >>>>
> >> >> >> >>>> I checked at http://v4l2spec.bytesex.org/spec/x542.htm, googled
> >> >> >> >>>> "V4L2_CID_PRIVATE_BASE deprecated" and read
> >> >> >> >>>> Documentation/feature-removal-schedule.txt. I couldn't find anything.
> >> >> >> >>>
> >> >> >> >>> Hmm. Did you happen to check when that has been written? :)
> >> >> >> >>>
> >> >> >> >>> Please use this one instead:
> >> >> >> >>>
> >> >> >> >>> <URL:http://hverkuil.home.xs4all.nl/spec/media.html>
> >> >> >> >>
> >> >> >> >> "Drivers can also implement their own custom controls using
> >> >> >> >> V4L2_CID_PRIVATE_BASE and higher values."
> >> >> >> >>
> >> >> >> >> Which specific location describes V4L2_CID_PRIVATE_BASE differently there?
> >> >> >> >
> >> >> >> > That was a general comment, not related to the private base. There's no
> >> >> >> > use for a three-year-old spec as a reference!
> >> >> >> >
> >> >> >> > The control framework does not support private controls, for example. The
> >> >> >> > controls should be put to their own class in videodev2.h nowadays, that's my
> >> >> >> > understanding. Cc Hans.
> >> >> >>
> >> >> >> Is this really the case that we close the door for private controls in
> >> >> >> the mainline kernel ? Or am I misunderstanding something ?
> >> >> >> How about v4l2_ctrl_new_custom() ?
> >> >> >>
> >> >> >> What if there are controls applicable to single driver only ?
> >> >> >> Do we really want to have plenty of such in videodev2.h ?
> >> >> >
> >> >> > We have some of those already in videodev2.h. I'm not certain if I'm happy
> >> >> > with this myself, considering e.g. that we could get a few truckloads of
> >> >> > only camera lens hardware specific controls in the near future.
> >> >>
> >> >> So in my case (as these are controls that might be used by others too)
> >> >> I should add something like
> >> >>
> >> >> #define V4L2_CID_BLUE_SATURATION              (V4L2_CID_CAMERA_CLASS_BASE+19)
> >> >> #define V4L2_CID_RED_SATURATION               (V4L2_CID_CAMERA_CLASS_BASE+20)
> >> >
> >> > What do these two controls do? Do they control gain or something else?
> >>
> >> Hmm. Maybe I named them a bit unsharp. It is the U Saturation and V
> >> Saturation. To me it looks like turning up the saturation in HSV
> >> space, but only for either the blue or the red channel. This would
> >> correspond to V4L2_CID_{RED,BLUE}_BALANCE when I read the docs. They
> >> say it is "{Red,Blue} chroma balance".
> >>
> >> I have other controls for that I used V4L2_CID_{RED,BLUE}_BALANCE.
> >> These are gains. So in fact I should swap them in my code and the
> >> remaining question is, how to name the red and blue gain controls.
> >
> > I think Laurent had a similar issue in his Aptina sensor driver. In my
> > opinion we need a class for low level controls such as the gain ones. Do I
> > understand correctly they control the red and blue pixel gain in the sensor
> > pixel matrix? Do you also have gain controls for the two greens?
> 
> Yes, I assume that this is done there. Either in the analog circuit by
> decreasing the preload or digitally then. Don't know exactly. There
> are registers for the green pixels as well. As I used the
> V4L2_CID_{RED,BLUE}_BALANCE controls and there was no
> V4L2_CID_GREEN_BALANCE, I just skipped green as one can
> increase/decrease the global gain and get an arbitrary mix as well.
> 
> So for these gain settings we should add these?
> V4L2_CID_RED_GAIN
> V4L2_CID_BLUE_GAIN
> V4L2_CID_GREEN_GAIN

Do you have two or just one green gains? In all sensors I've seen there are
two.

I think I could send an RFC on this to the list and cc you and Laurent.

> >> >> #define V4L2_CID_GRAY_SCALE_IMAGE             (V4L2_CID_CAMERA_CLASS_BASE+21)
> >> >
> >> > V4L2_CID_COLOR_KILLER looks like something which would fit for the purpose.
> >>
> >> Oh great! So I just take this.
> >>
> >> >> #define V4L2_CID_SOLARIZE_EFFECT              (V4L2_CID_CAMERA_CLASS_BASE+22)
> >> >
> >> > Sounds interesting for a sensor. I wonder if this would fall under a menu
> >> > control, V4L2_CID_COLORFX.
> >>
> >> When I read the the possible enums for V4L2_CID_COLORFX, it indeed
> >> sounds very much like my solarize effect should be added there too. I
> >> found V4L2_COLORFX_BW there, too. Isn't that a duplicate of the color
> >> killer control then?
> >
> > In my opinion V4L2_CID_COLORFX should never be implemented in drivers for
> > which the hardware doesn't implement these effects in a non-parametrisable
> > way. This control was originally added for the OMAP 3 ISP driver but the
> > driver never implemented it.
> 
> Your triple negation (never, doesn't, non-) is quite tricky xD
> If I get it right, you say that one should not use V4L2_CID_COLORFX
> for hardware with parametrisable effects.

Yes. I could have written that in a more clear way. ;-)

> My BW and Solarize effects are non-parametrisable and they can be
> turned on together (which makes not so much sense though - but these
> fun-effects like "solarize" aren't here to make sense, I guess :-) ).

Good.

The OMAP 3 ISP actually provides a way to set gamma tables, any effects
implemented using them are more or less use case specific. There are also
other uses for those same gamma tables, making a driver implementation for
effects using them non-functional in practice.

> > I think you have a valid case using this control. I think the main
> > difference between the two is that V4L2_COLORFX_BW is something that you
> > can't use with other effects while V4L2_CID_COLOR_KILLER can be used with
> > any of the effects.
> 
> > Based on your original proposal the black/white should stay as a separate
> > control but the solarise should be configurable through V4L2_CID_COLORFX
> > menu control. So it boils down to the question whether you can use them at
> > the same time.
> 
> I can - so it is still working to enable V4L2_COLORFX_BW and
> V4L2_CID_COLORFX with a new enum value, right? Is that the way to go
> now?

That's my opinion, yes.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
