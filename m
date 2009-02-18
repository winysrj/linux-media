Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:65378 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZBRL41 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 06:56:27 -0500
Subject: Re: not demuxing from interrupt context
From: Andy Walls <awalls@radix.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0902180305300.24268@shell2.speakeasy.net>
References: <Pine.LNX.4.58.0902180305300.24268@shell2.speakeasy.net>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 06:57:19 -0500
Message-Id: <1234958239.3091.14.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-02-18 at 03:09 -0800, Trent Piepho wrote:
> Here's an attempt to fix the pluto2 driver to not do this.  I don't have
> the hardware or information about the hardware so I'm not sure if it's
> right.  It's not that major of an undertaking.  It would have been easier
> if the driver was already double buffering like it should have been.


So here's something, not unique to pluto, that I've had a question about
with a lot of the drivers:

With only one queueable work object, or in this case an indicator that
only communicates that last incoming bit of work that needs to be done:
pluto->dmx_buf_num, can't you loose buffers on a busy system if the work
handler doesn't process things immediately?

Or is it just improbable that a system could every get that busy?


I'm also asking in the case of the recent PVRx50, KWorld 115 thread.  I
haven't looked tat the KWorld 115's driver yet to see if that may be a
possible cause of the problem.


Regards,
Andy

