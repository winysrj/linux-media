Return-path: <linux-media-owner@vger.kernel.org>
Received: from eumx.net ([91.82.101.43]:33452 "EHLO owm.eumx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608AbcFJQOy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 12:14:54 -0400
Subject: Re: i.mx6 camera interface (CSI) and mainline kernel
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tim Harvey <tharvey@gateworks.com>
References: <20160223114943.GA10944@frolo.macqel>
 <20160223141258.GA5097@frolo.macqel> <4956050.OLrYA1VK2G@avalon>
 <56D79B49.50009@mentor.com> <56D7E59B.6050605@xs4all.nl>
 <20160303083643.GA4303@frolo.macqel> <56D87824.8000707@mentor.com>
 <CAJ+vNU2kPgESnjTZokU3qNR6QAbU3G8HGwc7ahg4jDpeS_xjHg@mail.gmail.com>
 <56DF852A.30702@mentor.com>
 <CAJ+vNU0cWUZNcP=suP0rnhG-EqVov5ODk0fKpd4rqf9Setw7Gw@mail.gmail.com>
 <56E0BBE5.4060104@mentor.com>
 <CAJ+vNU2U3TRXzDJsau22qghUmwx2WQkOp8NVzZ=PxrhxV0yozg@mail.gmail.com>
 <57503AEE.1040907@xs4all.nl> <575063DA.9040001@mentor.com>
 <5755A945.5080302@mentor.com>
Cc: Philippe De Muyter <phdm@macq.eu>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
From: Jack Mitchell <ml@embed.me.uk>
Message-ID: <1c46af68-cf9d-5918-7ff5-567ffea662c6@embed.me.uk>
Date: Fri, 10 Jun 2016 16:58:28 +0100
MIME-Version: 1.0
In-Reply-To: <5755A945.5080302@mentor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


<snip>

>
> Hi all, I need a few more days. I would like to bring in the video-switch
> subdev from Pengutronix, which will replace the platform data set_video_mux
> method. Also re-org the device-tree to better define all the possible
> hardware
> connections, and split out mx6-encode.c into mx6-smfc and mx6-ic subdevs.
> Once this is done we should have a better base for adding media control
> later. I should have this done by end of this week.
>
> Steve
>

Hi Steve,

Just a heads up that I've also tested and confirmed partially working 
support on a sabrelite + mipi ov5640. The two gotchas I came across were 
dma_allocations fail in the higher resolutions (4x1080p buffers), a 
limit may need to be upped somewhere, the code says it should be able to 
handle up to 64MB? Secondly I can't get the 5MP resolution by default as 
in ov5640_find_nearest_mode, the array ov5640_mode_info_data is hard 
coded to 0.

I gave your v2 branch a quick whirl also but it fails to compile.

Thanks for the awesome work so far.

Cheers,
Jack.

---

Jack Mitchell
Tuxable Ltd
London, UK
