Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37026 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2GQLVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 07:21:08 -0400
Date: Tue, 17 Jul 2012 12:24:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: David Herrmann <dh.herrmann@googlemail.com>,
	linux-fbdev@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: dma-buf/fbdev: one-to-many support
Message-ID: <20120717122449.07489b50@pyramind.ukuu.org.uk>
In-Reply-To: <1497600.3Qx4Vx9if4@avalon>
References: <CANq1E4SbippxHHTaqLhpGjJLG12y94kWUFdB7P_EAG14o50vrQ@mail.gmail.com>
	<1497600.3Qx4Vx9if4@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The main issue is that fbdev has been designed with the implicit assumption 
> that an fbdev driver will always own the graphics memory it uses. All 
> components in the stack, from drivers to applications, have been designed 
> around that assumption.
> 
> We could of course fix this, revamp the fbdev API and turn it into a modern 
> graphics API, but I really wonder whether it would be worth it. DRM has been 
> getting quite a lot of attention lately, especially from embedded developers 
> and vendors, and the trend seems to me like the (Linux) world will gradually 
> move from fbdev to DRM.
> 
> Please feel free to disagree :-)

I would disagree on the "main issue" bit. All the graphics cards have
their own formats and cache management rules. Simply sharing a buffer
doesn't work - which is why all of the extra gloop will be needed.

Alan
