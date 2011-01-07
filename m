Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40362 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1AGOgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 09:36:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Yupeng Yan <yyan@codeaurora.org>
Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.
Date: Fri, 7 Jan 2011 15:37:30 +0100
Cc: Markus Rechberger <mrechberger@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Haibo Zhong <hzhong@codeaurora.org>,
	Shuzhen Wang <shuzhenw@codeaurora.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <000601cba2d8$eaedcdc0$c0c96940$@org> <201101050115.57699.laurent.pinchart@ideasonboard.com> <4D26586E.3080500@codeaurora.org>
In-Reply-To: <4D26586E.3080500@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101071537.31198.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Friday 07 January 2011 01:03:58 Yupeng Yan wrote:
> Thanks for the comments - certainly good arguments to our lawyers :-)...
> actually the information of how to config the ISP HW is requested to be
> protected for now, we are working on certain degree of openness.
> 
> The HW config code is just a small part of the user space (daemon)
> tasks, the user space code also processes ISP states, carries out 3A
> algorithm and perform post processing features, etc. which will have to
> be protected, this is the reason why the daemon is used in QC solution.

That's fine. Having closed-source userspace 3A and post-processing isn't an 
issue as far as the Linux driver is concerned.

We have the exact same requirements for the OMAP3. The 3A and image quality 
enhancement algorithms are implemented in userspace, in a library that can be 
used by applications (currently either through an open-source LGPL GStreamer 
element that links to the closed-source library, or through a libv4l plugin).

There is no legal need to implement this in a daemon. LGPL software can be 
linked to closed-source libraries, there is no risk there. If you insist on 
implementing a daemon (I really can't understand why that would be needed), 
the best solution would be to provide a library that applications can use to 
communicate with the daemon. That library (and the daemon) should handle 3A 
and post-processing tasks only. All ISP control (configuring the pipeline(s), 
starting/stopping the stream(s), handling the video buffers, getting/setting 
controls, reading statistics data, ...) must be implemented in the open-source 
kernel driver.

-- 
Regards,

Laurent Pinchart
