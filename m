Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:59021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab1BPH3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 02:29:47 -0500
Date: Wed, 16 Feb 2011 08:29:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: soc-camera: Benefits of soc-camera interface over specific char
 drivers that use Gstreamer lib
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com>
Message-ID: <Pine.LNX.4.64.1102160819530.20711@axis700.grange>
References: <D5ECB3C7A6F99444980976A8C6D896384DEE366DE6@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bhupesh

On Wed, 16 Feb 2011, Bhupesh SHARMA wrote:

> Hi Guennadi,
> 
> As I mentioned in one of my previous mails , we are developing a Camera Host and
> Sensor driver for our ST specific SoC and considering using the soc-camera framework
> for the same. One of our open-source customers has raised a interesting case though:
> 
> It seems they have an existing solution (for another SoC) in which they do not use V4L2
> framework and instead use the Gstreamer with framebuffer.

Don't see how gstreamer ("with framebuffer") can replace V4L2 source, I 
only know a fbdev _sink_ plugin for gstreamer, and no framebuffer source 
plugin. So, either this is a propriatory extension to gstreamer, or you 
mean something different here.

> They specifically wish us to
> implement a solution which is compatible with ANDROID applications.

AFAIU, android only specifies higher level Java application APIs, and it 
doesn't specify what you use at the device-node level. I know, that first 
(msm) android implementations didn't use V4L and used a custom character 
device for video data, which is totally incompatible with the mainline 
Linux.

> Could you please help us in deciding which approach is preferable in terms of
> performance, maintenance and ease-of-design.

Sorry, no, I have no idea about performance and ease of design, but it 
might be related to maintenance: your choice is basically between a custom 
character device, which only the specific android implementations know how 
to use, and a standard V4L2 (not necessarily soc-camera) implementation, 
which will immediately work for any Linux-based solution on your system. I 
believe, there have already been android ports, using V4L2 for video 
source, it is true, that some (mostly optional) android API calls don't 
have direct analogs in V4L2, and, therefore, have so far to be emulated, 
but I also think, there are a few users, that would be interested in 
extending V4L2 to better support those android API calls.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
