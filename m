Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:59045 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1KAMpJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Nov 2011 08:45:09 -0400
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 01 Nov 2011 13:36:50 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <201111011324.36742.laurent.pinchart@ideasonboard.com>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com>
Message-ID: <b3e1d11fbdb6c1fe02954f7b2dd29b01@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   Hello,



On Tue, 1 Nov 2011 13:24:35 +0100, Laurent Pinchart

<laurent.pinchart@ideasonboard.com> wrote:

> We should instead fix the V4L2 specification to mandate the use of a

> monotonic clock (which could then also support hardware timestamps when

> they are available). Would such a change be acceptable ?



I'd rather have the real time clock everywhere, than a driver-dependent

clock, if it comes to that.

Nevertheless, I agree that the monotonic clock is better than the real

time clock.

In user space, VLC, Gstreamer already switched to monotonic a while ago as

far as I know.



And I guess there is no way to detect this, other than detect ridiculously

large gap between the timestamp and the current clock value?



-- 

Rémi Denis-Courmont

http://www.remlab.net/
