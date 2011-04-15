Return-path: <mchehab@pedra>
Received: from mailfe02.c2i.net ([212.247.154.34]:54853 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752894Ab1DOIsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2011 04:48:25 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC v3] V4L2 API for flash devices
Date: Fri, 15 Apr 2011 10:47:19 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
References: <4DA7F5AD.1050104@maxwell.research.nokia.com>
In-Reply-To: <4DA7F5AD.1050104@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104151047.19658.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 15 April 2011 09:37:17 Sakari Ailus wrote:
> Hi,
> 
> This is a third proposal for an interface for controlling flash devices
> on the V4L2/v4l2_subdev APIs. My plan is to use the interface in the
> ADP1653 driver, the flash controller used in the Nokia N900.
> 
> Thanks to everyone who commented the previous version of this RFC! I
> hope I managed to factor in everyone's comments. Please bug me if you
> think I missed something. :-)
> 
> Comments and questions are very, very welcome as always. There are still
> many open questions which I would like to resolve. I've written my
> proposal on the two last ones below the question itself.
> 

Hi,

I looked through your specification and did not find the answer to my 
question. Do you support more than one flasher per webcam/camera?

--HPS
