Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:49292 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbLQPVJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 10:21:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] [media] uapi/media.h: Use u32 for the number of graph objects
Date: Thu, 17 Dec 2015 16:20:34 +0100
Message-ID: <2294897.lftU8mbJHZ@wuerfel>
In-Reply-To: <20151217125806.3f4f879e@recife.lan>
References: <40e950dbb6a3b7f73da52e147fa51441b762131a.1450350558.git.mchehab@osg.samsung.com> <2035986.3qXU4Qokl3@wuerfel> <20151217125806.3f4f879e@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 17 December 2015 12:58:06 Mauro Carvalho Chehab wrote:
> > Can you clarify how the 'topology_version' is used here? Is that
> > the version of the structure layout that decides how we interpret the
> > rest, or is it a number that is runtime dependent?
> 
> No, topology_version is just a mononotonic counter that starts on 0
> and it is incremented every time a graph object is added or removed. 
> 
> It is meant to be used to track if the topology changes after a previous
> call to this ioctl.
> 
> On existing media controller embedded device hardware, it should
> always be zero, but on devices that allow dynamic hardware changes
> (some embedded DTV hardware allows that - also on devices with FPGA,
> with RISC CPUs or hot-pluggable devices) should use it to know if the
> hardware got modified. 
> 
> This is also needed on multi-function devices where different drivers 
> are used for each function. That's the case of au0828, with uses a
> media driver for video, and the standard USB Audio Class driver for
> audio. As the drivers are independent, the topology_version will
> be zero when the first driver is loaded, but it will change during
> at probe time on second driver. It will also be increased if one
> of the drivers got unbind.

Ok, got it. Thanks for the explanation.

	Arnd
