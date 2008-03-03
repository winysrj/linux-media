Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JWGf7-0002X0-BX
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 20:49:31 +0100
Received: by gv-out-0910.google.com with SMTP id o2so189137gve.16
	for <linux-dvb@linuxtv.org>; Mon, 03 Mar 2008 11:49:18 -0800 (PST)
Message-ID: <47CC5636.3030807@googlemail.com>
Date: Mon, 03 Mar 2008 19:49:10 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.7.1204534746.20845.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.7.1204534746.20845.linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Help using DMX_SET_BUFFER_SIZE
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
> 
> 
> Possible solutions:
> 
> 2) enable the resize of a live ring buffer.
> Currently:
> 
> dvb_dvr_write DOES     lock the mutex (dmxdev->mutex)
> dvb_dvr_read  DOES NOT lock the mutex (the code to lock the mutex is there, but commented out, why?)
> 
> Is it enough to lock the mutex in dvb_dvr_read?

No, it isn't!

dvb_dmxdev_ts_callback is the function writing in the dvr_buffer, not dvb_dvr_write (which must be a 
system call I think).

Things get more complicated... I've understood that a callback function cannot sleep, so a mutex 
must not be used.
And a relocation of the buffer counts as reading and writing.

> Then the new function to change the buffer size could just lock the mutex, change the size and unlock.

How many readers of the dvr can there be? It looks like only 1 (otherwise the mutex would not be 
commented out).
Is it legal to write an application that reads dvr from one thread/process, and calls other ioctl 
from an other? I guess not, for the same reason why it cannot read from 2 threads.

So, if the above is true, I only need to synchronize with dvb_dmxdev_ts_callback, i.e. acquire the 
same spin_lock.

Does it make sense?

PS: It seems that I am replying my own emails... and I do that while I discover and understand more 
about the architecture of the dvr/demux.
What is a good starting point to get an idea about all those synchronization issues?
My next reading is the "Unreliable Guide To Locking".

More to follow...


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
