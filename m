Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35650 "EHLO
	pyramind.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754361Ab1LIOYJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 09:24:09 -0500
Date: Fri, 9 Dec 2011 14:24:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	"Semwal, Sumit" <sumit.semwal@ti.com>, linux@arm.linux.org.uk,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer
 sharing mechanism
Message-ID: <20111209142405.6f371be6@pyramind.ukuu.org.uk>
In-Reply-To: <201112091413.03736.arnd@arndb.de>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<201112071340.35267.arnd@arndb.de>
	<CAKMK7uFQiiUbkU-7c3Os0d0FJNyLbqS2HLPRLy3LGnOoCXV5Pw@mail.gmail.com>
	<201112091413.03736.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I still don't think that's possible. Please explain how you expect
> to change the semantics of the streaming mapping API to allow multiple
> mappers without having explicit serialization points that are visible
> to all users. For simplicity, let's assume a cache coherent system

I would agree. It's not just about barriers but in many cases where you
have multiple mappings by hardware devices the actual hardware interface
is specific to the devices. Just take a look at the fencing in TTM and
the graphics drivers.

Its not something the low level API can deal with, it requires high level
knowledge.

Alan
