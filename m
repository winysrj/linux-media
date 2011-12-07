Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1LGKL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 05:11:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Date: Wed, 7 Dec 2011 10:11:03 +0000
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linux@arm.linux.org.uk, jesse.barker@linaro.org,
	m.szyprowski@samsung.com, rob@ti.com, daniel@ffwll.ch,
	t.stanislaws@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com> <201112051718.48324.arnd@arndb.de> <CAB2ybb8-0_HupO95UUvLN9ovVxnU+uvn4UXbwqZLSFuC9MZs0w@mail.gmail.com>
In-Reply-To: <CAB2ybb8-0_HupO95UUvLN9ovVxnU+uvn4UXbwqZLSFuC9MZs0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112071011.03525.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 07 December 2011, Semwal, Sumit wrote:
> >
> > Do you have a use case for making the interface compile-time disabled?
> > I had assumed that any code using it would make no sense if it's not
> > available so you don't actually need this.
>
> Ok. Though if we keep the interface compile-time disabled, the users
> can actually check and fail or fall-back gracefully when the API is
> not available; If I remove it, anyways the users would need to do the
> same compile time check whether API is available or not, right?

If you have to do a compile-time check for the config symbol, it's better
to do it the way you did here than in the caller.

My guess was that no caller would actually require this, because when you
write a part of a subsystem to interact with the dma-buf infrastructure,
you would always disable compilation of an extire file that deals with 
everything related to struct dma_buf, not just stub out the calls.

	Arnd
