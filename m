Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35424 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbcCUHut (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 03:50:49 -0400
Received: by mail-oi0-f42.google.com with SMTP id w20so77670015oia.2
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2016 00:50:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56EFA571.1010104@xs4all.nl>
References: <CAO_48GGT48RZaLjg9C+51JyPKzYkkDCFCTrMgfUB+PxQyV8d+Q@mail.gmail.com>
	<1458545443-3302-1-git-send-email-daniel.vetter@ffwll.ch>
	<56EFA571.1010104@xs4all.nl>
Date: Mon, 21 Mar 2016 08:50:48 +0100
Message-ID: <CAKMK7uEV7sWtNotcp0oKW6QjFmEjMQrpkGiDx4=hsMqdueZQnw@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Update docs for SYNC ioctl
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Tiago Vignatti <tiago.vignatti@intel.com>,
	=?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
	David Herrmann <dh.herrmann@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 21, 2016 at 8:40 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> +    For correctness and optimal performance, it is always required to use
>> +    SYNC_START and SYNC_END before and after, respectively, when accessing the
>> +    mapped address. Userspace cannot on coherent access, even when there are
>
> "Userspace cannot on coherent access"? Do you mean "cannot do"? Sorry, the
> meaning isn't clear to me.

"cannot rely on". I'll send out v2 asap (and let's hope the coffee
works this time around).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
