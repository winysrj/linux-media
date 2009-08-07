Return-path: <linux-media-owner@vger.kernel.org>
Received: from co203.xi-lite.net ([149.6.83.203]:45696 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbZHGImH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Aug 2009 04:42:07 -0400
Message-ID: <4A7BE1E7.60203@parrot.com>
Date: Fri, 7 Aug 2009 10:12:23 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: David Xiao <dxiao@broadcom.com>, Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is	get_user_pages()
 enough to prevent pages from being swapped out ?")
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>	<200908061506.23874.laurent.pinchart@ideasonboard.com>	<1249584374.29182.20.camel@david-laptop> <200908070929.53873.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200908070929.53873.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart a écrit :
> On Thursday 06 August 2009 20:46:14 David Xiao wrote:
> 
> Think about the simple following use case. An application wants to display 
> video it acquires from the device to the screen using Xv. The video buffer is 
> allocated by Xv. Using the v4l2 user pointer streaming method, the device can 
> DMA directly to the Xv buffer. Using driver-allocated buffers, a memcpy() is 
> required between the v4l2 buffer and the Xv buffer.
> 
v4l2 got an API (overlay IRRC) that allow drivers to write directly in
framebuffer memory.
BTW Xv buffer is not always in video memory and the X driver can do a
memcpy.


Matthieu
