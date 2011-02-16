Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37657 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1BPNoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 08:44:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Re: soc-camera: Benefits of soc-camera interface over specific char drivers that use Gstreamer lib
Date: Wed, 16 Feb 2011 14:44:00 +0100
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102161444.01236.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bhupesh,

On Wednesday 16 February 2011 06:57:11 Bhupesh SHARMA wrote:
> Hi Guennadi,
> 
> As I mentioned in one of my previous mails , we are developing a Camera
> Host and Sensor driver for our ST specific SoC and considering using the
> soc-camera framework for the same. One of our open-source customers has
> raised a interesting case though:
> 
> It seems they have an existing solution (for another SoC) in which they do
> not use V4L2 framework and instead use the Gstreamer with framebuffer.
> They specifically wish us to implement a solution which is compatible with
> ANDROID applications.
> 
> Could you please help us in deciding which approach is preferable in terms
> of performance, maintenance and ease-of-design.

That's a difficult question that can't be answered without more details about 
your SoC. Could you share some documentation, such as a high-level block 
diagram of the video-related blocks in the SoC ?

-- 
Regards,

Laurent Pinchart
