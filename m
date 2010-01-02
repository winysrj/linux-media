Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:59905 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751064Ab0ABUn1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jan 2010 15:43:27 -0500
Date: Sat, 2 Jan 2010 15:43:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sean <knife@toaster.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
	<bugzilla-daemon@bugzilla.kernel.org>,
	<linux-media@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bugme-new] [Bug 14564] New: capture-example sleeping function
 called from invalid context at arch/x86/mm/fault.c
In-Reply-To: <4B3F0B20.4010805@toaster.net>
Message-ID: <Pine.LNX.4.44L0.1001021511320.9114-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2 Jan 2010, Sean wrote:

> Alan,
> 
> Thanks again. I was able to get the full dmesg output this time. I ran 
> capture-example three times and each time removing the webcam before 
> capture-example finished. On the third time I got the poisoned hash 
> message and I captured the output to a file. Attached is the dmesg output.

Okay.  Take a look at the following output:

$ egrep -n '[2e]e(80|9c)' dmesg2.log
680:pci 0000:00:0c.0: reg 14 io port: [0xee80-0xee83]
727:kobject: 'ieee80211' (c79d5e1c): kobject_add_internal: parent: 
'class', set: 'class'
728:kobject: 'ieee80211' (c79d5e1c): kobject_uevent_env
729:kobject: 'ieee80211' (c79d5e1c): fill_kobj_path: path = 
'/class/ieee80211'
4994:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6662e80
5027:ohci_hcd 0000:00:0b.0: hash c6662e80 to 58 -> (null)
5185:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c676ee80
5218:ohci_hcd 0000:00:0b.0: hash c676ee80 to 58 -> c6662e80
5276:ohci_hcd 0000:00:0b.0: td free c6662e80
5277:ohci_hcd 0000:00:0b.0: (58 1) c676ee9c -> (null)
5296:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6662e80
5329:ohci_hcd 0000:00:0b.0: hash c6662e80 to 58 -> c676ee80
5538:ohci_hcd 0000:00:0b.0: td free c676ee80
5539:ohci_hcd 0000:00:0b.0: (58 1) c6662e9c -> (null)
5558:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c676ee80
5591:ohci_hcd 0000:00:0b.0: hash c676ee80 to 58 -> c6662e80
5644:ohci_hcd 0000:00:0b.0: td free c6662e80
5645:ohci_hcd 0000:00:0b.0: (58 1) c676ee9c -> (null)
5720:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6662e80
5753:ohci_hcd 0000:00:0b.0: hash c6662e80 to 58 -> c676ee80
5900:ohci_hcd 0000:00:0b.0: td free c676ee80
5901:ohci_hcd 0000:00:0b.0: (58 1) c6662e9c -> (null)
5978:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c676ee80
6011:ohci_hcd 0000:00:0b.0: hash c676ee80 to 58 -> c6662e80
6072:ohci_hcd 0000:00:0b.0: td free c6662e80
6073:ohci_hcd 0000:00:0b.0: (58 1) c676ee9c -> (null)
6088:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6662e80
6121:ohci_hcd 0000:00:0b.0: hash c6662e80 to 58 -> c676ee80
6324:ohci_hcd 0000:00:0b.0: td free c676ee80
6325:ohci_hcd 0000:00:0b.0: (58 1) c6662e9c -> (null)
6343:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c676ee80
6376:ohci_hcd 0000:00:0b.0: hash c676ee80 to 58 -> c6662e80
6416:ohci_hcd 0000:00:0b.0: td free c6662e80
6417:ohci_hcd 0000:00:0b.0: (58 1) c676ee9c -> c676ee80
6492:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6662e80
6525:ohci_hcd 0000:00:0b.0: hash c6662e80 to 58 -> c676ee80
6686:ohci_hcd 0000:00:0b.0: td free c676ee80
6687:ohci_hcd 0000:00:0b.0: (58 1) c6662e9c -> c676ee80

Ignore the first few lines as being irrelevant.  Starting with line
5185 you can see that this shows two TDs being allocated, hashed,
freed, and unlinked over and over again, at addresses c6662e80 and
c676ee80.  When each one is hashed into the list, its td_hash member is
made to point to the other.  When each is removed from the hash list,
the other's td_hash member is set to NULL.

It's all very regular and repetitious until line 6417.  At that line,
the td_hash member of c676ee80 (which is at offset 1c from the start of
the structure, hence at c676ee9c) is made to point to its own
structure!  Thus later at line 6687, when c676ee80 is freed, the 
td_hash member of c6662e80 is set to point at the freed structure.  
This is what leads to poisoned pointer values later on.

So what went wrong at line 6417?  There's no way to know exactly.  My
guess is that the write at line 6325, where c6662e9c was supposed to be
set to NULL, never got recorded properly in the computer's memory.  
This would mean that c6662e9c still contained the c676ee80 value
assigned at line 6121, and hence the incorrect value was copied at line
6417.

In other words, I'm guessing that you're suffering from hardware memory
errors.  A possible way to test this is to modify the patch.  In
td_free() where it adds the line:

+			ohci_dbg(hc, "(%d %d) %p -> %p\n", hash, n, prev, *prev);

instead add this code:

+			barrier();
+			ohci_dbg(hc, "(%d %d) %p -> %p [%p]\n", hash, n,
+					prev, *prev, td->td_hash);

If we find that the value of *prev differs from the value of
td->td_hash then we'll know for certain.  (Or maybe the presence of the 
barrier() will cause the object code to change in a way that prevents 
the error from occurring.)

Alan Stern

