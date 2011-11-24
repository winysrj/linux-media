Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9786 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1KXJRc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 04:17:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LV500F99R558H40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 09:17:29 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV5002NWR55FR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 09:17:29 +0000 (GMT)
Date: Thu, 24 Nov 2011 10:17:29 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Query] V4L2 Integer (?) menu control
In-reply-to: <0acb6fa3fc87692f1f8ac7f1a908e1e7@chewa.net>
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>
Message-id: <4ECE0BA9.90207@samsung.com>
References: <4ECD730E.3080808@gmail.com>
 <0acb6fa3fc87692f1f8ac7f1a908e1e7@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2011 07:24 AM, Rémi Denis-Courmont wrote:
> On Wed, 23 Nov 2011 23:26:22 +0100, Sylwester Nawrocki <snjw23@gmail.com>
> wrote:
>> I don't seem to find a way to implement this in current v4l2 control
>> framework.  Such functionality isn't there, or is it ?
> 
> You can use the menu control type, but you will need to remap the control
> values so they are continuous.

Yes, but what I'm missing is a method for the drivers to inform the application
how the mapping looks like. Something like custom queryctrl for standard control CID.

So for instance if we have a standard control V4L2_CID_CAMERA_ISO, two devices could
support different series of values, e.g.

50, 200, 400, 800, ..
100, 180, 300, 600, ...

Currently the menu items are hard coded in the kernel for standard controls,
and AFAIU we can only query the control names.

In fact the continuous enumeration in the driver might do, which would be then
mapped to register values. But the meaning of this values need to be made known
to the applications.

--
Thanks,
Sylwester
