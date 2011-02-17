Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40790 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1BQNHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 08:07:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera: Benefits of soc-camera interface over specific char drivers that use Gstreamer lib
Date: Thu, 17 Feb 2011 14:07:50 +0100
Cc: Bhupesh SHARMA <bhupesh.sharma@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com> <201102161444.01236.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1102161448260.20711@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102161448260.20711@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171407.51015.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Wednesday 16 February 2011 14:49:51 Guennadi Liakhovetski wrote:
> On Wed, 16 Feb 2011, Laurent Pinchart wrote:
> > On Wednesday 16 February 2011 06:57:11 Bhupesh SHARMA wrote:
> > > Hi Guennadi,
> > > 
> > > As I mentioned in one of my previous mails , we are developing a Camera
> > > Host and Sensor driver for our ST specific SoC and considering using
> > > the soc-camera framework for the same. One of our open-source
> > > customers has raised a interesting case though:
> > > 
> > > It seems they have an existing solution (for another SoC) in which they
> > > do not use V4L2 framework and instead use the Gstreamer with
> > > framebuffer. They specifically wish us to implement a solution which
> > > is compatible with ANDROID applications.
> > > 
> > > Could you please help us in deciding which approach is preferable in
> > > terms of performance, maintenance and ease-of-design.
> > 
> > That's a difficult question that can't be answered without more details
> > about your SoC. Could you share some documentation, such as a high-level
> > block diagram of the video-related blocks in the SoC ?
> 
> Laurent, IIUC, the choice above referred not to soc-camera vs. plain v4l2,
> but to v4l2 vs. original android-style video character device, which
> doesn't seem so difficult to me;)

I assume that the Android video character device uses a proprietary API with 
an OMX layer on top of it.

I obviously think V4L2 is a better option than any proprietary 
kernel/userspace interface. This being said, the complexity of the hardware 
sometimes leads people to believe that a custom API would be better (or at 
least easier to implement). I asked for more information about the hardware to 
get a better picture on this.

-- 
Regards,

Laurent Pinchart
