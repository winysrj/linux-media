Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33321 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1BQNVv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 08:21:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Re: soc-camera: Benefits of soc-camera interface over specific char drivers that use Gstreamer lib
Date: Thu, 17 Feb 2011 14:21:50 +0100
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com> <201102161444.01236.laurent.pinchart@ideasonboard.com> <D5ECB3C7A6F99444980976A8C6D896384DEE3E9234@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DEE3E9234@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171421.50480.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bhupesh,

On Wednesday 16 February 2011 14:54:02 Bhupesh SHARMA wrote:
> On Wednesday, February 16, 2011 7:14 PM Laurent Pinchart wrote:
> > On Wednesday 16 February 2011 06:57:11 Bhupesh SHARMA wrote:
> > > Hi Guennadi,
> > > 
> > > As I mentioned in one of my previous mails , we are developing a
> > > Camera Host and Sensor driver for our ST specific SoC and considering
> > > using the soc-camera framework for the same. One of our open-source
> > > customers has raised a interesting case though:
> > > 
> > > It seems they have an existing solution (for another SoC) in which
> > > they do not use V4L2 framework and instead use the Gstreamer with
> > > framebuffer.
> > >
> > > They specifically wish us to implement a solution which is compatible
> > > with ANDROID applications.
> > > 
> > > Could you please help us in deciding which approach is preferable in
> > > terms of performance, maintenance and ease-of-design.
> > 
> > That's a difficult question that can't be answered without more details
> > about your SoC. Could you share some documentation, such as a high-level
> > block diagram of the video-related blocks in the SoC ?
> 
> At the top-level the interface is very simple:
> 
> -----------------  8-bit data interface -------------------
> | Camera sensor | <-------------------> | SoC (ARM Based) |
> |               |                       |                 |
> |               | I2C control Interface |                 |
> |               | <-------------------> |                 |
> |               |                       |                 |
> |               | SYNC signals (HS/VS)  |                 |
> |               | ------------------->  |                 |
> |               |                       |                 |
> |               | Pixel CLK             |                 |
> |               | ------------------->  |                 |
> |               |                       |                 |
> |               | Sensor CLK            |                 |
> |               | <-------------------  |                 |
> -----------------                       -------------------
> 
> The SoC itself has a simple interface to transfer the data received via
> system DMA and has buffer to store an incoming line data. Also one can
> program the SoC logic to apply transformations on the input data.

If the SoC just writes incoming data to memory using DMA, a V4L2 driver should 
be pretty easy to develop. If your SoC can capture images in different 
formats, possible applying complex processing (such as scaling the image) and 
supports memory-to-memory processing modes, you might need the media 
controller API in addition to the V4L2 API.

-- 
Regards,

Laurent Pinchart
