Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64303 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1JLOez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 10:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAF6AEGsK25wk28YmiwsZTenecKqCt6irx66nR-8nOFMo6Z=Dkw@mail.gmail.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
	<1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
	<CAPM=9tzHOa5Dbe=SQz+AURMMbio4L7qoS8kUT3Ek0+HdtkrH4g@mail.gmail.com>
	<CAF6AEGs6kkGp85NoNVuq5W9i=WE86V8wvAtKydX=D3bQOc+6Pw@mail.gmail.com>
	<CAPM=9twft0eBEUoCD11a2gTZHwOaPzFmZvBfE032dfK10eQ27Q@mail.gmail.com>
	<CAF6AEGuwMt6Snq=YSN4iddTv_Cu56aR_2BY1d3hjVvTdkom5MQ@mail.gmail.com>
	<CAPM=9tyKjodxf9MKjG=5bBDZTuqOx4Nu31L5iNN9LrO9fsp+FA@mail.gmail.com>
	<CAF6AEGsK25wk28YmiwsZTenecKqCt6irx66nR-8nOFMo6Z=Dkw@mail.gmail.com>
Date: Wed, 12 Oct 2011 15:34:54 +0100
Message-ID: <CAPM=9tyAiUZ9tNaer=_52WmiLKpJKG+3EXvZzotwGwvqkJFmOQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Dave Airlie <airlied@gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
	jesse.barker@linaro.org, daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 12, 2011 at 3:24 PM, Rob Clark <robdclark@gmail.com> wrote:
> On Wed, Oct 12, 2011 at 9:01 AM, Dave Airlie <airlied@gmail.com> wrote:
>>> But then we'd need a different set of accessors for every different
>>> drm/v4l/etc driver, wouldn't we?
>>
>> Not any more different than you need for this, you just have a new
>> interface that you request a sw object from,
>> then mmap that object, and underneath it knows who owns it in the kernel.
>
> oh, ok, so you are talking about a kernel level interface, rather than
> userspace..
>
> but I guess in this case I don't quite see the difference. �It amounts
> to which fd you call mmap (or ioctl[*]) on.. �If you use the dmabuf fd
> directly then you don't have to pass around a 2nd fd.
>
> [*] there is nothing stopping defining some dmabuf ioctls (such as for
> synchronization).. although the thinking was to keep it simple for
> first version of dmabuf
>

Yes a separate kernel level interface.

Well I'd like to keep it even simpler. dmabuf is a buffer sharing API,
shoehorning in a sw mapping API isn't making it simpler.

The problem I have with implementing mmap on the sharing fd, is that
nothing says this should be purely optional and userspace shouldn't
rely on it.

In the Intel GEM space alone you have two types of mapping, one direct
to shmem one via GTT, the GTT could be even be a linear view. The
intel guys initially did GEM mmaps direct to the shmem pages because
it seemed simple, up until they
had to do step two which was do mmaps on the GTT copy and ended up
having two separate mmap methods. I think the problem here is it seems
deceptively simple to add this to the API now because the API is
simple, however I think in the future it'll become a burden that we'll
have to workaround.

Dave.
