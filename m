Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay004-omc2s10.hotmail.com ([65.54.190.85]:63354 "EHLO
	BAY004-OMC2S10.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbaGDJav convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jul 2014 05:30:51 -0400
Message-ID: <BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Divneil Wadhawan <divneil@outlook.com>
Subject: RE: No audio support in struct v4l2_subdev_format
Date: Fri, 4 Jul 2014 15:00:50 +0530
In-Reply-To: <53B65DCA.6010803@xs4all.nl>
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>,<53B65DCA.6010803@xs4all.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


> To my knowledge nobody has done much if any work on this. Usually the
> audio part is handled by alsa, but it is not clear if support is also
> needed from the V4L2 API.

Actually, the application needs to know when to ask the capture device to start capturing.

Let's say, the cable is already plugged in/or plugged out.

So, any events will be missed as the driver state machine starts during boot up and app is not started.

App starts later, registers for (V4L2_EVENT_SOURCE_CHANGE back ported to 3.10) and listens, but will not receive any as they are already generated.


So, the application is in a blind spot whether to start capture or not.

If we get the same interface as video it's good. I mean G_FMT with a union for audio as well.

Otherwise, I can go with a proprietary control/ioctl indicating whether audio is valid or not. 

ioctl seems to be an easy choice, because this subdev is not exposing any controls, so, registration with ctrl framework for a single one seems a bit of overload.


Regards,

Divneil 		 	   		  