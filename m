Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:57037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab1BPNty (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 08:49:54 -0500
Date: Wed, 16 Feb 2011 14:49:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Bhupesh SHARMA <bhupesh.sharma@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: soc-camera: Benefits of soc-camera interface over specific char
 drivers that use Gstreamer lib
In-Reply-To: <201102161444.01236.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1102161448260.20711@axis700.grange>
References: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com>
 <201102161444.01236.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 16 Feb 2011, Laurent Pinchart wrote:

> Hi Bhupesh,
> 
> On Wednesday 16 February 2011 06:57:11 Bhupesh SHARMA wrote:
> > Hi Guennadi,
> > 
> > As I mentioned in one of my previous mails , we are developing a Camera
> > Host and Sensor driver for our ST specific SoC and considering using the
> > soc-camera framework for the same. One of our open-source customers has
> > raised a interesting case though:
> > 
> > It seems they have an existing solution (for another SoC) in which they do
> > not use V4L2 framework and instead use the Gstreamer with framebuffer.
> > They specifically wish us to implement a solution which is compatible with
> > ANDROID applications.
> > 
> > Could you please help us in deciding which approach is preferable in terms
> > of performance, maintenance and ease-of-design.
> 
> That's a difficult question that can't be answered without more details about 
> your SoC. Could you share some documentation, such as a high-level block 
> diagram of the video-related blocks in the SoC ?

Laurent, IIUC, the choice above referred not to soc-camera vs. plain v4l2, 
but to v4l2 vs. original android-style video character device, which 
doesn't seem so difficult to me;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
