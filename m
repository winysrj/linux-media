Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36210 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab0G3LC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:02:56 -0400
Subject: Re: [PATCH 04/13] IR: fix locking in ir_raw_event_work
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <1280457769.15737.72.camel@localhost>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
	 <1280456235-2024-5-git-send-email-maximlevitsky@gmail.com>
	 <1280457769.15737.72.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 14:02:50 +0300
Message-ID: <1280487770.3646.1.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-29 at 22:42 -0400, Andy Walls wrote: 
> On Fri, 2010-07-30 at 05:17 +0300, Maxim Levitsky wrote:
> > It is prefectly possible to have ir_raw_event_work
> > running concurently on two cpus, thus we must protect
> > it from that situation.
> 
> Yup, the work is marked as not pending (and hence reschedulable) just
> before the work handler is run.
> 
> 
> > Maybe better solution is to ditch the workqueue at all
> > and use good 'ol thread per receiver, and just wake it up...
> 
> I suppose you could also use a single threaded workqueue instead of a
> mutex, and let a bit test provide exclusivity.  With the mutex, when the
> second thread finally obtains the lock, there will likely not be
> anything for it to do.
Mutex there is for another reason, to protect against decoder
insert/removal.

However, I think its best just to use a bare kthread for the purpose of
this.

Best regards,
Maxim Levitsky


