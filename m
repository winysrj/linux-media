Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:40043 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbZJ0X0z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 19:26:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Linux-uvc-devel] again "Logitech QuickCam Pro for Notebooks 046d:0991"
Date: Wed, 28 Oct 2009 00:27:38 +0100
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1255514751.15164.17.camel@zwerg> <1256557968.12179.5.camel@zwerg> <4AE5ACF1.3080606@redhat.com>
In-Reply-To: <4AE5ACF1.3080606@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910280027.38292.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 26 October 2009 15:06:41 Hans de Goede wrote:
> On 10/26/2009 12:52 PM, Alexey Fisher wrote:
> > Am Sonntag, den 25.10.2009, 14:21 +0100 schrieb Hans de Goede:

[snip]

> > > fwiw I'm a v4l kernel developer, but I'm not involved in the UVC driver,
> > > I'm however a contributor to cheese, I thought that my input that cheese
> > > would give up even if the driver has a long enough timeout would be
> > > helpful.
> > >
> > > To try and see if this (the cheese timeout is the issue), you will need
> > > to re-compile cheese from source, after unpacking cheese, edit
> > > src/cheese-webcam.c and goto line 716 (in 2.28.0)
> > >
> > > And change the "10 * GST_SECOND" there in something bigger. I also see
> > > that I'm mistaken and the timeout in cheese is not 3 but 10 seconds, it
> > > might have changed recently, or my memory has been playing tricks on me.
> > >
> > > I still believe this might be the cause, the trace you have posted seems
> > > consistent with cheese's behaviour. Also noticed that there never is a
> > > successfull DQBUF the first time cheese opens the device. If cheese
> > > (or rather gstreamer) does not manage to DQBUF the first time, then
> > > cheese will not work with the device. There is a limitation in gstreamer
> > > (or maybe in the way cheese uses it) where gstreamer needs to be
> > > streaming before cheese can tell the properties of the cam. If the
> > > stream does not start within the first 10 seconds, then cheese will fail
> > > to get the properties.
> > >
> > > If you go to cheese's edit ->  preferences menu, and your cam has no
> > > resolutions listed there (the resolution drop down is grayed out). This
> > > is what is happening.
> > >
> > > As for empathy, I'm not familiar with that. But if we can get cheese to
> > > work first I'm sure that that would be a good step in the right
> > > direction.
> >
> > Hallo Hans,
> > thank you for your constructive response,
> > I increased timeout to 15 seconds i now i can't reproduce camera freeze,
> > i'll play with it more to be sure. There is still one issue with it - on
> > cold start the image is zoomed in.
> > I need to close cheese and open it again to get normal zoom. The
> > resolution seems to be the same.

Zoomed in ? Really ? As far as I know the QuickCam Pro for Notebooks has no 
optical or digital zoom. Could you please send me lsusb's output for your 
device ?

> That definitely sounds like a camera bug, but maybe we can do something
> on the driver side (like forcing a resolution change even if not necessary)
> to work around this. Laurent ?

The driver already sends a video format and resolution set request to the 
device when starting the video stream.

> Note re-adding the mailing list and Laurent to the CC, they somehow got
> dropped.

Thanks.

-- 
Regards,

Laurent Pinchart
