Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:49760 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbbHXBSB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 21:18:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: poma <pomidorabelisima@gmail.com>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Laura Abbott <labbott@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: WARNING: CPU: 1 PID: 813 at kernel/module.c:291 module_assert_mutex_or_preempt+0x49/0x90()
In-Reply-To: <55D6FBB0.5000709@gmail.com>
References: <55C916F0.8010303@gmail.com> <55D6FBB0.5000709@gmail.com>
Date: Mon, 24 Aug 2015 10:47:46 +0930
Message-ID: <87h9npjxhh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

poma <pomidorabelisima@gmail.com> writes:
>> Ref.
>> https://bugzilla.redhat.com/show_bug.cgi?id=1252167
>> https://bugzilla.kernel.org/show_bug.cgi?id=102631
>> 
>
> You guys are really something.

Hi Poma,

        I understand your frustration!

I got involved via the other thread which didn't mention your bug report
anywhere.  I'm sure Laura was trying to be helpful by creating a minimal
report, but the resulting patch erred in not crediting you.

> First of all, as is evident here, I am the original reporter, not Laura Abbott <labbott@redhat.com>.

Thanks for clarifying that.  I have fixed the commit message to credit
you.  See below.

> -All- your comments including the final patch on this issue, are just plain wrong.[1]
> 
> This patch only hides the actual problem with this particular device - the dual tuner combination driven by dvb_usb_af9015 & mxl5007t, broken by design since day one.

Oh, there's definitely a real issue in the driver; this one is cosmetic.

> Read the entire https://bugzilla.redhat.com/show_bug.cgi?id=1252167
> and stop this nonsense.
>
> NACK "module: Fix locking in symbol_put_addr()"

Yeah, I've had days like this, too :(

Anyway, thanks for finding this bug: if the driver init hadn't been
screwed it wouldn't have taken that path and found this for us.

Good luck with the other issue!
Rusty.

>From 275d7d44d802ef271a42dc87ac091a495ba72fc5 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 20 Aug 2015 10:34:59 +0930
Subject: [PATCH] module: Fix locking in symbol_put_addr()

Poma (on the way to another bug) reported an assertion triggering:

  [<ffffffff81150529>] module_assert_mutex_or_preempt+0x49/0x90
  [<ffffffff81150822>] __module_address+0x32/0x150
  [<ffffffff81150956>] __module_text_address+0x16/0x70
  [<ffffffff81150f19>] symbol_put_addr+0x29/0x40
  [<ffffffffa04b77ad>] dvb_frontend_detach+0x7d/0x90 [dvb_core]

Laura Abbott <labbott@redhat.com> produced a patch which lead us to
inspect symbol_put_addr(). This function has a comment claiming it
doesn't need to disable preemption around the module lookup
because it holds a reference to the module it wants to find, which
therefore cannot go away.

This is wrong (and a false optimization too, preempt_disable() is really
rather cheap, and I doubt any of this is on uber critical paths,
otherwise it would've retained a pointer to the actual module anyway and
avoided the second lookup).

While its true that the module cannot go away while we hold a reference
on it, the data structure we do the lookup in very much _CAN_ change
while we do the lookup. Therefore fix the comment and add the
required preempt_disable().

Reported-by: poma <pomidorabelisima@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Fixes: a6e6abd575fc ("module: remove module_text_address()")
Cc: stable@kernel.org

diff --git a/kernel/module.c b/kernel/module.c
index b86b7bf1be38..8f051a106676 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1063,11 +1063,15 @@ void symbol_put_addr(void *addr)
 	if (core_kernel_text(a))
 		return;
 
-	/* module_text_address is safe here: we're supposed to have reference
-	 * to module from symbol_get, so it can't go away. */
+	/*
+	 * Even though we hold a reference on the module; we still need to
+	 * disable preemption in order to safely traverse the data structure.
+	 */
+	preempt_disable();
 	modaddr = __module_text_address(a);
 	BUG_ON(!modaddr);
 	module_put(modaddr);
+	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(symbol_put_addr);
 
