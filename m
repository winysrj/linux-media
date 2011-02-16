Return-path: <mchehab@pedra>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:55094 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391Ab1BPOOX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 09:14:23 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 16 Feb 2011 21:57:12 +0800
Subject: RE: soc-camera: Benefits of soc-camera interface over specific char
 drivers that use Gstreamer lib
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DEE3E9237@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com>
 <201102161444.01236.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1102161448260.20711@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102161448260.20711@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> Sent: Wednesday, February 16, 2011 7:20 PM
> To: Laurent Pinchart
> Cc: Bhupesh SHARMA; linux-media@vger.kernel.org
> Subject: Re: soc-camera: Benefits of soc-camera interface over specific
> char drivers that use Gstreamer lib
> 
> On Wed, 16 Feb 2011, Laurent Pinchart wrote:
> 
> > Hi Bhupesh,
> >
> > On Wednesday 16 February 2011 06:57:11 Bhupesh SHARMA wrote:
> > > Hi Guennadi,
> > >
> > > As I mentioned in one of my previous mails , we are developing a
> Camera
> > > Host and Sensor driver for our ST specific SoC and considering
> using the
> > > soc-camera framework for the same. One of our open-source customers
> has
> > > raised a interesting case though:
> > >
> > > It seems they have an existing solution (for another SoC) in which
> they do
> > > not use V4L2 framework and instead use the Gstreamer with
> framebuffer.
> > > They specifically wish us to implement a solution which is
> compatible with
> > > ANDROID applications.
> > >
> > > Could you please help us in deciding which approach is preferable
> in terms
> > > of performance, maintenance and ease-of-design.
> >
> > That's a difficult question that can't be answered without more
> details about
> > your SoC. Could you share some documentation, such as a high-level
> block
> > diagram of the video-related blocks in the SoC ?
> 
> Laurent, IIUC, the choice above referred not to soc-camera vs. plain
> v4l2,
> but to v4l2 vs. original android-style video character device, which
> doesn't seem so difficult to me;)
> 

That's correct Guennadi :)
The choice I have to make is to between v4ls (soc-camera)
vs. a specific video char driver written to support android-style applications.

Also I am not sure about how gstreamer over framebuffer can interface with 
such a design and the respective merits/demerits.

Regards,
Bhupesh
