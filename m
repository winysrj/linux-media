Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65263 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2GQMXU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 08:23:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120717122449.07489b50@pyramind.ukuu.org.uk>
References: <CANq1E4SbippxHHTaqLhpGjJLG12y94kWUFdB7P_EAG14o50vrQ@mail.gmail.com>
	<1497600.3Qx4Vx9if4@avalon>
	<20120717122449.07489b50@pyramind.ukuu.org.uk>
Date: Tue, 17 Jul 2012 14:23:18 +0200
Message-ID: <CANq1E4TMddx-+h5cGAn=R2VoNBQ274CBZDGV02Ku2Hgo_Hc3iA@mail.gmail.com>
Subject: Re: dma-buf/fbdev: one-to-many support
From: David Herrmann <dh.herrmann@googlemail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-fbdev@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Alan

On Tue, Jul 17, 2012 at 1:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> The main issue is that fbdev has been designed with the implicit assumption
>> that an fbdev driver will always own the graphics memory it uses. All
>> components in the stack, from drivers to applications, have been designed
>> around that assumption.
>>
>> We could of course fix this, revamp the fbdev API and turn it into a modern
>> graphics API, but I really wonder whether it would be worth it. DRM has been
>> getting quite a lot of attention lately, especially from embedded developers
>> and vendors, and the trend seems to me like the (Linux) world will gradually
>> move from fbdev to DRM.
>>
>> Please feel free to disagree :-)
>
> I would disagree on the "main issue" bit. All the graphics cards have
> their own formats and cache management rules. Simply sharing a buffer
> doesn't work - which is why all of the extra gloop will be needed.

This is exactly why I suggested adding an "owner" field. A driver
could then check whether the buffer it is supposed to share/takeover
is from a compatible (or even the same) driver/device. If it is not,
it would simply reject using the buffer. Then again, if we have
multiple devices that are incompatible, we are still unable to share
the buffer. So this attempt would only be useful if we have tons of
DisplayLink devices attached that all use the same driver, for
example.

Regarding DRM: In user-space I prefer DRM over fbdev. With the
introduction of the dumb-buffers there isn't even the need to have
mesa installed. However, fblog runs in kernel space and currently
cannot use DRM as there is no in-kernel DRM API. I looked at
drm-fops.c whether it is easy to create a very simple in-kernel API
but then I dropped the idea as this might be too complex for a simple
debugging-only driver. Another attempt would be making the
drm-fb-helper more generic so we can use this layer as in-kernel DRM
API.

I had a deeper look into this this weekend and so as a summary I think
all in-kernel graphics access is probably not worth optimizing it.
fbcon is already working great and fblog is only used during boot and
oopses/panics and can be restricted to a single device. I will have
another look at the drivers in a few weeks but if you tell me that
this is not easy to implement, I will probably have to let this idea
go.

Thanks
David
