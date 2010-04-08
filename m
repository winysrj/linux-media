Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:53042 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0DHMnT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 08:43:19 -0400
Date: Thu, 8 Apr 2010 14:43:15 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC2] Teach drivers/media/IR/ir-raw-event.c to use durations
Message-ID: <20100408124315.GA21540@hardeman.nu>
References: <20100407201835.GA8438@hardeman.nu>
 <4BBD6550.6030000@infradead.org>
 <20100408112305.GA2803@hardeman.nu>
 <4BBDC318.4040709@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BBDC318.4040709@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 08, 2010 at 08:50:48AM -0300, Mauro Carvalho Chehab wrote:
> >-	size = sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE * 2;
> >-	size = roundup_pow_of_two(size);
> >+	ir->raw->input_dev = input_dev;
> >+	INIT_WORK(&ir->raw->rx_work, ir_raw_event_work);
> > 
> >-	rc = kfifo_alloc(&ir->raw->kfifo, size, GFP_KERNEL);
> >+	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(int) * MAX_IR_EVENT_SIZE,
> >+			 GFP_KERNEL);
> 
> kfifo logic requires a power of two buffer to work, so, please keep the
> original roundup_pow_of_two() logic, or add a comment before MAX_IR_EVENT_SIZE.

No, kfifo_alloc() takes care of the rounding up. See the code for 
kfifo_alloc() in kernel/kfifo.c.

-- 
David H�rdeman
