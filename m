Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:40263 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3EQETy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 May 2013 00:19:54 -0400
Received: by mail-ia0-f171.google.com with SMTP id k10so2817372iag.16
        for <linux-media@vger.kernel.org>; Thu, 16 May 2013 21:19:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF6AEGuBexKUpTwm9cjGjkxCTKgEaDhAakeP0RN=rtLS6Qy=Mg@mail.gmail.com>
References: <CAAQKjZNNw4qddo6bE5OY_CahrqDtqkxdO7Pm9RCguXyj9F4cMQ@mail.gmail.com>
	<51909DB4.2060208@canonical.com>
	<025201ce4fbb$363d0390$a2b70ab0$%dae@samsung.com>
	<5190B7D8.3010803@canonical.com>
	<027a01ce4fcc$5e7c7320$1b755960$%dae@samsung.com>
	<5190D14A.7050904@canonical.com>
	<028a01ce4fd4$5ec6f000$1c54d000$%dae@samsung.com>
	<CAF6AEGvWazezZdLDn5=H8wNQdQSWV=EmqE1a4wh7QwrT_h6vKQ@mail.gmail.com>
	<CAAQKjZP=iOmHRpHZCbZD3v_RKUFSn0eM_WVZZvhe7F9g3eTmPA@mail.gmail.com>
	<CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
	<006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
	<CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
	<00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
	<CAF6AEGuBexKUpTwm9cjGjkxCTKgEaDhAakeP0RN=rtLS6Qy=Mg@mail.gmail.com>
Date: Fri, 17 May 2013 06:19:53 +0200
Message-ID: <CAKMK7uHRER_wmBcEN1JRqtkLxA_0SHBp16Z1Z_GqVbYw-YAZSA@mail.gmail.com>
Subject: Re: Introduce a new helper framework for buffer synchronization
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Clark <robdclark@gmail.com>
Cc: Inki Dae <inki.dae@samsung.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	YoungJun Cho <yj44.cho@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 15, 2013 at 4:06 PM, Rob Clark <robdclark@gmail.com> wrote:
> So while it seems nice and orthogonal/clean to couple cache and
> synchronization and handle dma->cpu and cpu->cpu and cpu->dma in the
> same generic way, but I think in practice we have to make things more
> complex than they otherwise need to be to do this.  Otherwise I think
> we'll be having problems with badly behaved or crashing userspace.

I haven't read through the entire thread careful but imo this is very
important. If we add a fence interface which allows userspace to block
dma this is a no-go. The only thing we need is to sync up with all
outstanding dma operations and flush caches for cpu access. If broken
userspace starts to issue new dma (or multiple thread stomp onto each
another) that's not a problem dma fences/syncpoints should try to
solve. This way we can concentrate on solving the (already
challenging) device-to-device sync issues without additional
complexities which cpu->cpu sync would impose.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
