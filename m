Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:30357 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1ANVPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 16:15:25 -0500
Date: Fri, 14 Jan 2011 22:14:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH v2] hdpvr: reduce latency of i2c read/write w/recycled
 buffer
Message-ID: <20110114221435.3fc09243@endymion.delvare>
In-Reply-To: <20110114210838.GE9849@redhat.com>
References: <20110114200109.GB9849@redhat.com>
	<20110114210838.GE9849@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 14 Jan 2011 16:08:38 -0500, Jarod Wilson wrote:
> The current hdpvr code kmalloc's a new buffer for every i2c read and
> write. Rather than do that, lets allocate a buffer in the driver's
> device struct and just use that every time.
> 
> The size I've chosen for the buffer is the maximum size I could
> ascertain might be used by either ir-kbd-i2c or lirc_zilog, plus a bit
> of padding (lirc_zilog may use up to 100 bytes on tx, rounded that up
> to 128).
> 
> Note that this might also remedy user reports of very sluggish behavior
> of IR receive with hdpvr hardware.
> 
> v2: make sure (len <= (dev->i2c_buf)) [Jean Delvare]
> 
> Reported-by: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
