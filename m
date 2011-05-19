Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2027 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab1ESG4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 02:56:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Re: Audio Video synchronization for data received from a HDMI receiver chip
Date: Thu, 19 May 2011 08:55:57 +0200
Cc: "Charlie X. Liu" <charlie@sensoray.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <D5ECB3C7A6F99444980976A8C6D896384DF1137013@EAPEX1MAIL1.st.com> <201105180832.52333.hverkuil@xs4all.nl> <D5ECB3C7A6F99444980976A8C6D896384DF11B615E@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DF11B615E@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105190855.58027.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, May 19, 2011 07:39:32 Bhupesh SHARMA wrote:
> > On Wednesday, May 18, 2011 06:10:43 Bhupesh SHARMA wrote:
> > > Hi,
> > >
> > > (adding alsa mailing list in cc)
> > >
> > > > On Thursday, May 12, 2011 18:59:33 Charlie X. Liu wrote:
> > > > > Which HDMI receiver chip?
> > > >
> > > > Indeed, that's my question as well :-)
> > >
> > > We use Sil 9135 receiver chip which is provided by Silicon Image.
> > > Please see details here:
> > http://www.siliconimage.com/products/product.aspx?pid=109
> > >
> > > > Anyway, this question comes up regularly. V4L2 provides timestamps
> > for
> > > > each
> > > > frame, so that's no problem. But my understanding is that ALSA does
> > not
> > > > give
> > > > you timestamps, so if there are processing delays between audio and
> > > > video, then
> > > > you have no way of knowing. The obvious solution is to talk to the
> > ALSA
> > > > people
> > > > to see if some sort of timestamping is possible, but nobody has
> > done
> > > > that.
> > >
> > > I am aware of the time stamping feature provided by V4L2, but I am
> > also
> > > not sure whether the same feature is supported by ALSA. I have
> > included
> > > alsa-mailing list also in copy of this mail. Let's see if we can get
> > > some sort of confirmation on this from them.
> > >
> > > > This is either because everyone that needs it hacks around it
> > instead
> > > > of trying
> > > > to really solve it, or because it is never a problem in practice.
> > >
> > > What should be the proper solution according to you to solve this
> > issue.
> > > Do we require a Audio-Video Bridge kind of utility/mechanism?
> > 
> > I don't believe so. All you need is reliable time stamping for your
> > audio
> > and video streams. That's enough for userspace to detect AV sync
> > issues.
> > 
> 
> Hi Hans,
> 
> I have another doubt regarding the framework choice for the entire
> system that I have, especially the video part of the system. The overall
> system is similar to the one depicted below:
> 
> HDMI data --> HDMI receiver chip --> Video Port IP on SoC --> System DDR
> 
> HDMI data is received from external world (from say a set-up box or dvd player),
> which is fed to the HDMI receiver chip on-board and then parallel data lines feed
> this data to a Video Port IP on the SoC which has a DMA master interface and
> hence can push the data thus received directly on system DDR.
> 
> Now, I can figure out that there will be two drivers required here:
> # HDMI receiver chip driver (which is essentially a v4l2 subdev being controller via I2C)
> # Video Port driver (which is a v4l2 bridge driver)
> 
> Is my understanding correct?

Yes.

> Are there any HDMI receiver subdev driver and video bridge driver already available which I can 
> use for reference?

Video bridge drivers are easier: examples are in drivers/media/video/s5p-fimc
or in drivers/media/video/davinci. Note that you should use the new videobuf2
framework instead of the older videobuf framework. s5p-fimc is using vb2 already.
but the vpif capture and display drivers in the davinci directory do not.

With regards to HDMI receivers: these are still under development. One example
is here: http://git.linuxtv.org/hverkuil/cisco.git?a=shortlog;h=refs/heads/cobalt

This tree contains a driver for the adv7604 HDMI/Graphics receiver. It is fairly
simplistic at the moment, our internal driver is developed a lot further but I
haven't had the chance yet to update the git tree with our latest code (Cisco
is developing this driver). In addition the HDMI API for V4L2 is still under
development. It requires some V4L2 core support to be merged first (control events)
before we can continue with that.

> 
> Also will the audio ALSA driver fit as a subdev driver in the entire system?

No, although I have heard that the ALSA developers are looking at a subdev-like
approach. There are several V4L drivers that support ALSA as a separate driver
(cx18 for example). This is usually not a problem.

Regards,

	Hans
