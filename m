Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57634 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab2HZWPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 18:15:47 -0400
Subject: Re: RFC: Core + Radio profile
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Sun, 26 Aug 2012 18:15:29 -0400
In-Reply-To: <201208250921.52422.hverkuil@xs4all.nl>
References: <201208221140.25656.hverkuil@xs4all.nl>
	 <1345855036.2491.86.camel@palomino.walls.org>
	 <201208250921.52422.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1346019333.2466.33.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, 2012-08-25 at 09:21 +0200, Hans Verkuil wrote:
> On Sat August 25 2012 02:37:15 Andy Walls wrote:
> > On Wed, 2012-08-22 at 11:40 +0200, Hans Verkuil wrote:
 
> > > This RFC is my attempt to start this process by describing three profiles:
> > > the core profile that all drivers must adhere to, a profile for a radio
> > > receiver and a profile for a radio transmitter.
> > 
> > I was thinking that profiles based on applications types might be more
> > useful, but then I saw that applications were basically already handling
> > different device types differently.  So prfoiles for hardware device
> > types seems the reasonable choice.
> > 
> > MythTV seems to care about 4 classes of device
> > http://www.mythtv.org/wiki/Video_capture_card
> > 
> > 	Analog Framebuffer
> > 	Analog Hardware Encoder
> > 	Digital Capture
> > 	Digital Tuner
> > 
> > VLC seems to be similar to MythTV in terms of classes:
> > http://www.videolan.org/doc/streaming-howto/en/images/global-diagram.jpg
> > 
> > I suppose there would also be profiles to support device classes for:
> > 
> > 	webcams
> > 	webcams that provide video in a container format (AVI, MJPEG, whatever)
> > 	integrated cameras (I'm thinking smart-phones, but I'm out of my depth here)
> 
> Looking at the current set of V4L drivers I come up with the following
> profiles:
> 
> - Core Profile (mandatory for all)
> - Radio Receiver Profile (with optional RDS support (sub-profile?))

I would avoid the use of the word "optional" in a profile.

I would imagine the profile would say something like: "If the device and
driver support RDS, then applications can determine this by [some method
consistent with the V4L2 spec] and the driver will implement the
following ioctl()s: [...]; and provide data in the following manner:
[...]"

So nothing is really optional, if the device and driver can support RDS.

That way you also don't get a proliferation of profiles - Radio Receiver
with RDS and also Radio Receiver w/o RDS - or subprofiles. (As a group,
numerous profiles begin to create the option inconsistency problem all
over again.) 

Again, I'm coming from the viewpoint that every "option" holds potential
for an application <-> driver interoperability problem.  Profiles need
to set clear expectations for both applications and driver.  Stating
that something is optional in a profile is undersireable, IMO.


> - Radio Transmitter Profile (with optional RDS support)
> - Webcam Profile
> - Video Capture Profile (with optional tuner/overlay/vbi support)
> - Video Output Profile (with optional vbi support)

Ditto, regarding "optional".


> - Memory-to-Memory Profile (for hardware codecs)
> - Complex Profile (for SoCs with complex video hardware requiring the use
>   of the Media Controller API and a supporting library)
> 
> I wonder if e.g. optional tuner support and similar optional features
> should be defined as full profiles or as sub-profiles.

I would suggest you avoid a proliferation of profiles.  Fewer profiles
go farther in enhancing application <-> driver inetroperability.

I like your list above.  Using your example of tuner support, you would
include that in the Video Capture Profile.  The language I would use is
again something like:

"If the device has a supported analog broadcast TV tuner, then
applications can detect this by [some method consistent with the V4L2
spec], and the following ioctl()s must be supported: [...].


> In theory it is possible to have, say, a device that just captures VBI and
> no video. So there is something to be said for making it a full profile
> and allow drivers to support multiple profiles (although not all combinations
> are allowed).

IMO, Combinations of profiles, just creates uncertainty and thus
interoperability problems.

My first inclination would be to just handle a VBI-only capture device
under the Video Capture profile, with a properly worded profile.

There is probably a similar situation with Video Capture devices that
output raw frames vs. video capture devices that output conatiner
formats (MPEG PS, MPEG TS, AVI).  I think that can be handled in a
single Video Capture profile as well.



> > > I am not certain where these profile descriptions should go. Should we add
> > > this to DocBook, or describe it in Documentation/video4linux? Or perhaps
> > > somehow add it to v4l2-compliance, since that tool effectively verifies
> > > the profile.
> > 
> > Don't bury the authoritative profile in a tool, profiles should be
> > documents easily accessed by implementors.
> > 
> > Interoperability is promoted via clearly documentation requirments for
> > implementors.  Interoperability is assessed with tools.

I would like to temper my above statements.

Given the reality of man-power to write documents for Open Source
software, my above recommendations might not be realistic.  I've been
living in a "big, up-front design" world lately.

Also Steven Toth's Viewcast Osprey PULL request has shown how a good
tool can help speed compliance after the fact.  (Although good profile
documents may have prevented the back & forth in the first place.)

 

> > > Core Profile
> > > ============
 

> > > VIDIOC_LOG_STATUS is optional, but recommended for complex drivers.
> > 
> > Not OK.  I would avoid making anything in a profile optional.
> > 
> > Given that the output of LOG_STATUS does not enhance interoperability,
> > as its output is not readily readable by the calling application, I
> > recommend dropping mention of LOG_STATUS from the core profile.
> > 
> > 
> > > VIDIOC_DBG_G_CHIP_IDENT, VIDIOC_DBG_G/S_REGISTER are optional and are
> > > primarily used to debug drivers.
> > 
> > Drop mention of these from the Core profile as well.  These can be, and
> > usually are, compiled out of stock distro kernel with a kernel build
> > configuration option.
> > 
> > Normal end user applications cannot rely on the being there, so they do
> > not enhance interoperability.
> > 
> > If you wish to add a Debug profile that builds upon the Core profile,
> > them these ioctl()s and _LOG_STATUS would fit nicely in that.
> 
> A Debug Profile sounds good.

I'm having second thoughts on this.

The only real advantage I can see is that we could recommend to
application developers to test against drivers that support the Debug
profile, to enhance troubleshooting, support requests, and bug reports.

Given a previous email I saw from you, I guess supporting USERPTR would
also be a good thing to add to a Debug profile.


> > > 
> > > Video nodes only control video, radio nodes only control radio and RDS, vbi
> > > nodes only control VBI (raw and/or sliced).
> > 
> > If that is the case, then does the profile need to say something about
> > multiple open of radio nodes?  (I'm thinking of the legacy /dev/video24
> > nodes here, which are really interoperabily losers in terms of existing
> > FM radio apps anyway.)
> 
> I made a follow-up to this profile that adds that.
> 
> Regards,
> 
> 	Hans


Regards,
Andy


