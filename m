Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:33697 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2LSUOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 15:14:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAAQKjZMt+13oooEw39mOM1rF2=ss4ih1s7iVS362di-50h4+Hg@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com>
 <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
 <CAKMK7uF3Ahh8isvzZr4605X3wz-TQ2EHreTUnc5K_Z0DwrY6xw@mail.gmail.com> <CAAQKjZMt+13oooEw39mOM1rF2=ss4ih1s7iVS362di-50h4+Hg@mail.gmail.com>
From: =?ISO-8859-1?Q?St=E9phane_Marchesin?=
	<stephane.marchesin@gmail.com>
Date: Wed, 19 Dec 2012 12:13:20 -0800
Message-ID: <CACP_E++NmOgnNjmEbLvNU27N6Z1SNP2vigtSXxSE5DzVtcHQnA@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
To: Inki Dae <inki.dae@samsung.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 18, 2012 at 1:38 AM, Inki Dae <inki.dae@samsung.com> wrote:
>
>
> 2012/12/18 Daniel Vetter <daniel@ffwll.ch>
>>
>> On Tue, Dec 18, 2012 at 7:21 AM, Rob Clark <rob.clark@linaro.org> wrote:
>> >> The other thing I'd like you guys to do is kill the idea of fbdev and
>> >> v4l drivers that are "shared" with the drm codebase, really just
>> >> implement fbdev and v4l on top of the drm layer, some people might
>> >> think this is some sort of maintainer thing, but really nothing else
>> >> makes sense, and having these shared display frameworks just to avoid
>> >> having using drm/kms drivers seems totally pointless. Fix the drm
>> >> fbdev emulation if an fbdev interface is needed. But creating a fourth
>> >> framework because our previous 3 frameworks didn't work out doesn't
>> >> seem like a situation I want to get behind too much.
>> >
>> > yeah, let's not have multiple frameworks to do the same thing.. For
>> > fbdev, it is pretty clear that it is a dead end.  For v4l2
>> > (subdev+mcf), it is perhaps bit more flexible when it comes to random
>> > arbitrary hw pipelines than kms.  But to take advantage of that, your
>> > userspace isn't going to be portable anyways, so you might as well use
>> > driver specific properties/ioctls.  But I tend to think that is more
>> > useful for cameras.  And from userspace perspective, kms planes are
>> > less painful to use for output than v4l2, so lets stick to drm/kms for
>> > output (and not try to add camera/capture support to kms).. k, thx
>>
>> Yeah, I guess having a v4l device also exported by the same driver
>> that exports the drm interface might make sense in some cases. But in
>> many cases I think the video part is just an independent IP block and
>> shuffling data around with dma-buf is all we really need. So yeah, I
>> guess sharing display resources between v4l and drm kms driver should
>> be a last resort option, since coordination (especially if it's
>> supposed to be somewhat dynamic) will be extremely hairy.
>
>
> I think the one reason that the CDF was appeared is to avoid duplicating
> codes. For example, we should duplicate mipi-dsi or dbi drivers into drm to
> avoid ordering issue. And for this, those should be re-implemented in based
> on drm framework so that those could be treated as all one device. Actually,
> in case of Exynos, some guys tried to duplicate eDP driver into exynos drm
> framework in same issue.

If you're talking about us, this is misleading, as we didn't try to
duplicate the eDP driver. What we did is remove it from driver/video
and put it in DRM.

The reason for that is that it's not needed for fbdev, since KMS
helpers let you implement fbdev. So we can just remove all the exynos
graphics support from drivers/video since it becomes obsolete with the
KMS fbdev helpers. And everything can be in DRM. And later, we can
remove the multiple platform drivers from DRM as well, since they're
not needed either.

Stéphane

> So I think the best way is to avoid duplicating
> codes and resolve ordering issue such as s/r operations between all the
> various components.
>
> And the below is my opinion,
>
>
> -----------------------------------------------------
> Display
> Controller-------------CDF---------------|MIPI-DSI/DBI---------------LCD
> Panel|
>
> -----------------------------------------------------
>
> 1. to access MIPI-DSI/DBI and LCD Panel drivers.
>     - Display Controller is controlled by linux framebuffer or drm kms based
> specific drivers like now. And each driver calls some interfaces of CDF.
>
> 2. to control the power of these devices.
>     - drm kms based specific driver calls dpms operation and next the dpms
> operation calls fb blank operation of linux framebuffer.
>       But for this, we need some interfaces that it can connect between drm
> and linux framebuffer framework and you can refer to the below link.
>
> http://lists.freedesktop.org/archives/dri-devel/2011-July/013242.html
>     - linux framebuffer based driver calls fb blank operation.
>
>         fb blank(fb)------------------pm
> runtime(fb)--------------------fb_blank----------mipi and lcd
>         dpms(drm kms)------------pm runtime(drm
> kms)----------fb_blank----------mipi and lcd
>
>
> 3. suspend/resume
>     - pm suspend/resume are implemented only in linux framebuffer or drm kms
> based specific drivers.
>     - MIPI-DSI/DBI and LCD Panel drivers are controlled only by fb blank
> interfaces.
>
>         s/r(fb)-----------------------------------------------pm
> runtime(fb)----------------fb blank-------mipi and lcd
>         s/r(drm kms)--------dpms(drm kms)-------pm runtime(drm
> kms)------fb_blank------mipi and lcd
>
>
> We could resolve ordering issue to suspend/resume simply duplicating
> relevant drivers but couldn't avoid duplicating codes. So I think we could
> avoid the ordering issue using fb blank interface of linux framebuffer and
> also duplicating codes.
>
> Thanks,
> Inki Dae
>
>
>>
>> -Daniel
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
