Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48742 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2GRAlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 20:41:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-fbdev@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: dma-buf/fbdev: one-to-many support
Date: Wed, 18 Jul 2012 02:41:29 +0200
Message-ID: <5893060.WVaAFZ7hde@avalon>
In-Reply-To: <CANq1E4TMddx-+h5cGAn=R2VoNBQ274CBZDGV02Ku2Hgo_Hc3iA@mail.gmail.com>
References: <CANq1E4SbippxHHTaqLhpGjJLG12y94kWUFdB7P_EAG14o50vrQ@mail.gmail.com> <20120717122449.07489b50@pyramind.ukuu.org.uk> <CANq1E4TMddx-+h5cGAn=R2VoNBQ274CBZDGV02Ku2Hgo_Hc3iA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

On Tuesday 17 July 2012 14:23:18 David Herrmann wrote:
> On Tue, Jul 17, 2012 at 1:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> The main issue is that fbdev has been designed with the implicit
> >> assumption that an fbdev driver will always own the graphics memory it
> >> uses. All components in the stack, from drivers to applications, have
> >> been designed around that assumption.
> >> 
> >> We could of course fix this, revamp the fbdev API and turn it into a
> >> modern graphics API, but I really wonder whether it would be worth it.
> >> DRM has been getting quite a lot of attention lately, especially from
> >> embedded developers and vendors, and the trend seems to me like the
> >> (Linux) world will gradually move from fbdev to DRM.
> >> 
> >> Please feel free to disagree :-)
> > 
> > I would disagree on the "main issue" bit. All the graphics cards have
> > their own formats and cache management rules. Simply sharing a buffer
> > doesn't work - which is why all of the extra gloop will be needed.
> 
> This is exactly why I suggested adding an "owner" field. A driver
> could then check whether the buffer it is supposed to share/takeover
> is from a compatible (or even the same) driver/device. If it is not,
> it would simply reject using the buffer. Then again, if we have
> multiple devices that are incompatible, we are still unable to share
> the buffer. So this attempt would only be useful if we have tons of
> DisplayLink devices attached that all use the same driver, for
> example.
> 
> Regarding DRM: In user-space I prefer DRM over fbdev. With the
> introduction of the dumb-buffers there isn't even the need to have
> mesa installed. However, fblog runs in kernel space and currently
> cannot use DRM as there is no in-kernel DRM API. I looked at
> drm-fops.c whether it is easy to create a very simple in-kernel API
> but then I dropped the idea as this might be too complex for a simple
> debugging-only driver. Another attempt would be making the
> drm-fb-helper more generic so we can use this layer as in-kernel DRM
> API.
> 
> I had a deeper look into this this weekend and so as a summary I think
> all in-kernel graphics access is probably not worth optimizing it.
> fbcon is already working great and fblog is only used during boot and
> oopses/panics and can be restricted to a single device. I will have
> another look at the drivers in a few weeks but if you tell me that
> this is not easy to implement, I will probably have to let this idea
> go.

My gut feeling is that, given the effort required to add new APIs, it would be 
more interesting to work on an in-kernel DRM API to make drmcon and drmlog 
implementations possible without any fbdev compatibility layer. That's rather 
a long term goal though.

-- 
Regards,

Laurent Pinchart

