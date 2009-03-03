Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:50176 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZCCHig (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 02:38:36 -0500
Message-ID: <49ACDE66.6040903@nokia.com>
Date: Tue, 03 Mar 2009 09:38:14 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
Reply-To: sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
To: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
References: <5e9665e10903021848u328e0cd4m5186344be15b817@mail.gmail.com>	 <19F8576C6E063C45BE387C64729E73940427BC9B86@dbde02.ent.ti.com> <5e9665e10903022113r17e36afh7861fd00cd8ef0f7@mail.gmail.com>
In-Reply-To: <5e9665e10903022113r17e36afh7861fd00cd8ef0f7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DongSoo(Nathaniel) Kim wrote:
> This is quite confusing because in case of mine, I wanna make
> switchable between different cameras attached to omap camera
> interface.

Currently the ISP doesn't have a very neat way of controlling its use. 
In the recent patches, there's a change that allows just one isp_get() 
--- subsequent calls return -EBUSY.

So in practice, if you open the first device, you can't open the second 
one before the first one is closed. That's not very elegant but at least 
it prevents problematic concurrent access to the ISP.

In theory (AFAIK) the ISP *can* be used to receive data from multiple 
sources at the same time, but there are limitations.

In practice, if you have a hardware mux, you can switch it to a specific 
sensor when the camera driver tells the slave to go to some state that's 
not V4L2_POWER_OFF.

> Which idea do I have to follow? Comparing with multiple video input
> devices and multiple cameras attached to single camera interface is
> giving me no answer.
> 
> Perhaps multiple cameras with single camera interface couldn't make
> sense at the first place because single camera interface can go with
> only one camera module at one time.
> But we are using like that. I mean dual cameras with single camera
> interface. There is no choice except that when we are using dual
> camera without stereo camera controller.

Yup, I know, some mobile devices have front and back cameras. :)

> By the way, I cannot find any API documents about
> VIDIOC_INT_S_VIDEO_ROUTING but it seems to be all about "how to route
> between input device with output device".

That, I guess, is meant for video output devices.

> What exactly I need is "how to make switchable with multiple camera as
> an input for camera interface", which means just about an input
> device. In my opinion, those are different issues each other..(Am I
> right?)
> Cheers,


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
