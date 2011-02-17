Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40807 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1BQNKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 08:10:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Re: soc-camera: Benefits of soc-camera interface over specific char drivers that use Gstreamer lib
Date: Thu, 17 Feb 2011 14:10:30 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com> <Pine.LNX.4.64.1102161448260.20711@axis700.grange> <D5ECB3C7A6F99444980976A8C6D896384DEE3E9237@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DEE3E9237@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171410.30444.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bhupesh,

On Wednesday 16 February 2011 14:57:12 Bhupesh SHARMA wrote:
> On Wednesday, February 16, 2011 7:20 PM Guennadi Liakhovetski wrote:
> > On Wed, 16 Feb 2011, Laurent Pinchart wrote:
> > > On Wednesday 16 February 2011 06:57:11 Bhupesh SHARMA wrote:
> > > > Hi Guennadi,
> > > > 
> > > > As I mentioned in one of my previous mails , we are developing a
> > > > Camera Host and Sensor driver for our ST specific SoC and considering
> > > > using the soc-camera framework for the same. One of our open-source
> > > > customers has raised a interesting case though:
> > > > 
> > > > It seems they have an existing solution (for another SoC) in which
> > > > they do not use V4L2 framework and instead use the Gstreamer with
> > > > framebuffer.
> > > >
> > > > They specifically wish us to implement a solution which is compatible
> > > > with ANDROID applications.
> > > > 
> > > > Could you please help us in deciding which approach is preferable
> > > > in terms of performance, maintenance and ease-of-design.
> > > 
> > > That's a difficult question that can't be answered without more details
> > > about your SoC. Could you share some documentation, such as a high-level
> > > block diagram of the video-related blocks in the SoC ?
> > 
> > Laurent, IIUC, the choice above referred not to soc-camera vs. plain
> > v4l2, but to v4l2 vs. original android-style video character device, which
> > doesn't seem so difficult to me;)
> 
> That's correct Guennadi :)
> The choice I have to make is to between v4ls (soc-camera)
> vs. a specific video char driver written to support android-style
> applications.
> 
> Also I am not sure about how gstreamer over framebuffer can interface with
> such a design and the respective merits/demerits.

GStreamer is often used on top of V4L2 devices. I'm not sure to understand 
what GStreamer over framebuffer is supposed to mean here, as you're looking 
for a solution for your camera driver, and the framebuffer API is used for 
video output only, not video capture.

-- 
Regards,

Laurent Pinchart
