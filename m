Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54254 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757219Ab3EHQ0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 12:26:53 -0400
Date: Wed, 8 May 2013 19:26:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC] Motion Detection API
Message-ID: <20130508162648.GG1075@valkosipuli.retiisi.org.uk>
References: <201304121736.16542.hverkuil@xs4all.nl>
 <201305061541.41204.hverkuil@xs4all.nl>
 <2428502.07isB1rKTR@avalon>
 <201305071435.30062.hverkuil@xs4all.nl>
 <518909DA.8000407@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518909DA.8000407@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, May 07, 2013 at 04:04:10PM +0200, Sylwester Nawrocki wrote:
> On 05/07/2013 02:35 PM, Hans Verkuil wrote:
> > A metadata plane works well if you have substantial amounts of data (e.g. histogram
> > data) but it has the disadvantage of requiring you to use the MPLANE buffer types,
> > something which standard apps do not support. I definitely think that is overkill
> > for things like this.
> 
> Standard application could use the MPLANE interface through the libv4l-mplane
> plugin [1]. And meta-data plane could be handled in libv4l, passed in raw form 
> from the kernel.
> 
> There can be substantial amount of meta-data per frame and we were considering
> e.g. creating separate buffer queue for meta-data, to be able to use mmaped 
> buffer at user space, rather than parsing and copying data multiple times in 
> the kernel until it gets into user space and is further processed there.

What kind of metadata do you have?

> I'm actually not sure if performance is a real issue here, were are talking
> of 1.5 KiB order amounts of data per frame. Likely on x86 desktop machines
> it is not a big deal, for ARM embedded platforms we would need to do some
> profiling.
> 
> I'm not sure myself yet how much such motion/object detection data should be 
> interpreted in the kernel, rather than in user space. I suspect some generic
> API like in your $subject RFC makes sense, it would cover as many cases as 
> possible. But I was wondering how much it makes sense to design a sort of 
> raw interface/buffer queue (similar to raw sockets concept), that would allow
> user space libraries to parse meta-data.

This was proposed as one possible solution in the Cambourne meeting.

<URL:http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/36587>

I'm in favour of using a separate video buffer queue for passing low-level
metadata to user space.

> The format of meta-data could for example have changed after switching to
> a new version of device's firmware. It might be rare, I'm just trying to say 
> I would like to avoid designing a kernel interface that might soon become a 
> limitation.

On some devices it seems the metadata consists of much higher level
information.

-- 
kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
