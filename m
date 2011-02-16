Return-path: <mchehab@pedra>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:32801 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736Ab1BPOOV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 09:14:21 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 16 Feb 2011 21:54:02 +0800
Subject: RE: soc-camera: Benefits of soc-camera interface over specific char
 drivers that use Gstreamer lib
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DEE3E9234@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com>
 <201102161444.01236.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201102161444.01236.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Wednesday, February 16, 2011 7:14 PM
> To: Bhupesh SHARMA
> Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org
> Subject: Re: soc-camera: Benefits of soc-camera interface over specific
> char drivers that use Gstreamer lib
> 
> Hi Bhupesh,
> 
> On Wednesday 16 February 2011 06:57:11 Bhupesh SHARMA wrote:
> > Hi Guennadi,
> >
> > As I mentioned in one of my previous mails , we are developing a
> Camera
> > Host and Sensor driver for our ST specific SoC and considering using
> the
> > soc-camera framework for the same. One of our open-source customers
> has
> > raised a interesting case though:
> >
> > It seems they have an existing solution (for another SoC) in which
> they do
> > not use V4L2 framework and instead use the Gstreamer with
> framebuffer.
> > They specifically wish us to implement a solution which is compatible
> with
> > ANDROID applications.
> >
> > Could you please help us in deciding which approach is preferable in
> terms
> > of performance, maintenance and ease-of-design.
> 
> That's a difficult question that can't be answered without more details
> about
> your SoC. Could you share some documentation, such as a high-level
> block
> diagram of the video-related blocks in the SoC ?
> 

At the top-level the interface is very simple:

----------------  8-bit data interface  ------------
|Camera sensor |  <-------------------> | SoC (ARM Based)
|              |				    |		   |
|		   |	I2C control Interface |		   |
|	         |	<-------------------> |		   |
|              |				    |		   |
|		   |	SYNC signals (HSYNC, VSYNC)	   |
|	         |	------------------->  |		   |
|              |				    |		   |
|		   |	Pixel CLK		    |          |
|	         |	------------------->  |		   |
|              |				    |		   |
|		   |	Sensor CLK		    |          |
|	         |	<-------------------  |		   |
----------------				    ------------

The SoC itself has a simple interface to transfer the data received via system DMA and has buffer to store
an incoming line data. Also one can program the SoC logic to apply transformations on the input data.

Hope this helps.
Regards,
Bhupesh
