Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60267 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbZCBOPc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2009 09:15:32 -0500
Subject: Re: General protection fault on rmmod cx8800
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090302133936.00899692@hyperion.delvare>
References: <20090215214108.34f31c39@hyperion.delvare>
	 <20090302133936.00899692@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 09:16:05 -0500
Message-Id: <1236003365.3071.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-03-02 at 13:39 +0100, Jean Delvare wrote:
> On Sun, 15 Feb 2009 21:41:08 +0100, Jean Delvare wrote:
> > Hi all,
> > 
> > Today I have hit the following general protection fault when removing
> > module cx8800:
> 
> This has just happened to me again today, with kernel 2.6.28.7. I have
> opened a bug in bugzilla:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12802
> 

I'll try to look at it later today.  But right off the bat, I think
here's a problem:


void cx88_ir_stop(struct cx88_core *core, struct cx88_IR *ir)
{
[...]
        if (ir->polling) {
                del_timer_sync(&ir->timer);   <--- Wrong order?
                flush_scheduled_work();       <--- Wrong order?
        }
}

static void cx88_ir_work(struct work_struct *work)
{
        struct cx88_IR *ir = container_of(work, struct cx88_IR, work);

        cx88_ir_handle_key(ir);
        mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
}


mod_timer() acts like del_timer(); mumble; add_timer();  If there was
any work flushed when stopping the IR, a new timer gets added.  That
seems wrong.

Regards,
Andy

