Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1Jdtba-0005Ra-IP
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 21:49:23 +0100
Received: by ug-out-1314.google.com with SMTP id o29so3232542ugd.20
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 13:49:15 -0700 (PDT)
Message-ID: <47E813C7.6070208@googlemail.com>
Date: Mon, 24 Mar 2008 20:49:11 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, o.endriss@gmx.de
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
Subject: [linux-dvb] [PATCH] 2/3: implement DMX_SET_BUFFER_SIZE for dvr
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

linux-dvb-request@linuxtv.org wrote:

 > What about this fragment:
 > 	...
 > 	if (!size)
 > 		return -EINVAL;
 >
 > 	mem = vmalloc(size);
 > 	if (!mem)
 > 		return -ENOMEM;
 >
 > 	mem2 = buf->data;
 >
 >       spin_lock_irqsave(&dmxdev->lock);
 >       buf->pread = buf->pwrite = 0;
 > 	buf->data = mem;
 > 	buf->size = size;
 > 	spin_unlock_irqrestore(&dmxdev->lock);
 >
 > 	vfree(mem2);
 > 	return 0;

Maybe I can think of one reason while the current code is not implemented this way:

In your version the new buffer is allocated before the old one is released.
In the current implementation the old buffer is released and afterwards the new one allocated.

One could argue that the new implementation has a maximum memory requirement higher than the old one.
It's not much but I am not too familiar with kernel development, so I don't know how important that 
could be.

What do you think?

About the spin_lock_irqsave: currently it is not used anywhere in the code for the demux in dmxdev.c.
I am always a bit scared when I introduce something new, maybe I am missing the current logic.

Cheers

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
