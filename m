Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbZLFD1m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Dec 2009 22:27:42 -0500
Message-ID: <4B1B24A9.2040304@redhat.com>
Date: Sun, 06 Dec 2009 01:27:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: Heads up, I'm adding IR stuff to cx23885 and cx25840
References: <1260068865.3105.50.camel@palomino.walls.org>
In-Reply-To: <1260068865.3105.50.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> Mauro,
> 
> I noticed you've added some changes to th v4l-dvb tree for IR.
> 
> Just to let you know, I've added an NEC protocol implementation to
> cx23885-input.c.   The two relevant changes are here:
> 
> 	cx23885: Convert from struct card_ir to struct cx23885_ir_input for IR Rx
> 	http://linuxtv.org/hg/~awalls/cx23885-ir/rev/c51daeba32cb
> 
> 	cx23885: Add NEC protocol decoding for IR Rx
> 	http://linuxtv.org/hg/~awalls/cx23885-ir/rev/6cba2fc1ea99
> 
> I haven't kept track with all your changes so far, but just wanted to
> let you know these would be ready sometime before Christmas for
> hopefully the HVR-1800 and TeVii S470.  Hopefully, the changes will also
> be brought up to date with your changes by then too.

By looking on your code, as you're calling:
	ir_input_init(input_dev, &ir->ir, ir_type, ir_codes);

You'll already be using my new code. However, you'll need to add a call to ir_input_free(input_dev),
at the IR unregistering code, and on an error condition.

You should notice that you're not limited to use only 128 scancodes from 0 to 127, as the
previous versions of the ir-common allowed. The new version supports 32 bits for scancodes,
and use dynamic allocation to allow adding/removing codes from the table.

Cheers,
Mauro.
