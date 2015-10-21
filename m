Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35063 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbJUP6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2015 11:58:02 -0400
Received: by lbbes7 with SMTP id es7so41870150lbb.2
        for <linux-media@vger.kernel.org>; Wed, 21 Oct 2015 08:58:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.20.1510220132490.6421@namei.org>
References: <1445419340-11471-1-git-send-email-benjamin.gaignard@linaro.org>
	<alpine.LRH.2.20.1510220132490.6421@namei.org>
Date: Wed, 21 Oct 2015 17:58:00 +0200
Message-ID: <CA+M3ks5ffmT6DOM3VK2b51xJzb2LLUpf34n=uisggQpCoeUMkQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] RFC: Secure Memory Allocation Framework
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: James Morris <jmorris@namei.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Cooksey <tom.cooksey@arm.com>,
	Daniel Stone <daniel.stone@collabora.com>,
	linux-security-module@vger.kernel.org,
	Xiaoquan Li <xiaoquan.li@vivantecorp.com>,
	Laura Abbott <labbott@redhat.com>,
	Tom Gall <tom.gall@linaro.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-10-21 16:34 GMT+02:00 James Morris <jmorris@namei.org>:
> On Wed, 21 Oct 2015, Benjamin Gaignard wrote:
>
>>
>> The outcome of the previous RFC about how do secure data path was the need
>> of a secure memory allocator (https://lkml.org/lkml/2015/5/5/551)
>>
>
> Have you addressed all the questions raised by Alan here:
>
> https://lkml.org/lkml/2015/5/8/629

SMAF create /dev/smaf where all allocations could be done and is the
owner of the dmabuf.
Secure module is called to check permissions before that the CPU could
access to the memory.

I hope this cover what Alan expected but I can't speak form him.

>
> Also, is there any application of this beyond DRM?
>

If you don't use the secure part you can consider that SMAF is a
central allocator with helpers to select
the best allocator for your hardware devices.
While SMAF doesn't rely on DRM concepts (crypto, CENC, keys etc...) we
can use it outside this context but obviously it that been first
designed for DRM uses cases.

>
> - James
> --
> James Morris
> <jmorris@namei.org>
>



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
