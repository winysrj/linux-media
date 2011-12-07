Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab1LGLfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 06:35:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Date: Wed, 7 Dec 2011 11:34:54 +0000
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linux@arm.linux.org.uk, jesse.barker@linaro.org,
	m.szyprowski@samsung.com, rob@ti.com, daniel@ffwll.ch,
	t.stanislaws@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com> <201112071011.03525.arnd@arndb.de> <CAB2ybb9yiHLzB9iW_EhBvEkvo3n82phkfS+d1J7yXi+ZZt=kDw@mail.gmail.com>
In-Reply-To: <CAB2ybb9yiHLzB9iW_EhBvEkvo3n82phkfS+d1J7yXi+ZZt=kDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112071134.54352.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 07 December 2011, Semwal, Sumit wrote:
> Right; that would be ideal, but we may not be able to ask each user to
> do so - especially when the sharing part might be interspersed in
> existing buffer handling code. So for now, I would like to keep it as
> it-is.

Ok, fair enough. It certainly doesn't hurt.

	Arnd
