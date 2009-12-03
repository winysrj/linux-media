Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:1328 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZLCFuc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 00:50:32 -0500
Message-ID: <4B175111.9070800@toaster.net>
Date: Wed, 02 Dec 2009 21:48:01 -0800
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
	bugzilla-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org,
	USB list <linux-usb@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bugme-new] [Bug 14564] New: capture-example sleeping function
 called from invalid context at arch/x86/mm/fault.c
References: <Pine.LNX.4.44L0.0911121058210.3000-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911121058210.3000-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there anything I can do to help? This is a show stopping bug for me.

Thanks,
Sean Lazar

Alan Stern wrote:
> On Wed, 11 Nov 2009, Andrew Morton wrote:
>
>   
>>> http://bugzilla.kernel.org/show_bug.cgi?id=14564
>>>
>>>            Summary: capture-example sleeping function called from invalid
>>>                     context at arch/x86/mm/fault.c
>>>       
>
>   
>> We oopsed in td_free() (see below).  But as part of that oops
>> processing the kernel entered do_page_fault() and emitted a
>> might_sleep() warning because we took a pagefault with local interrupts
>> disabled.
>>
>> This is undesirable behaviour from the low-level x86 fault code and I
>> don't think it normally happens.
>>
>> Did we break something in x86 land, or is this oops sufficiently weird
>> and whacky to bypass existing checks for this false positive?
>>     
>
> No, what happened was a structure containing a linked-list entry got
> freed while it was still on the list.  Then when the driver walked
> through the list, it attempted to dereference a list pointer that had
> been poisoned.  More or less by coincidence, the poison value
> represented a paged-out address rather than an invalid address, so a
> page fault occurred.  That's what caused the oops.
>
>   
>>> BUG: unable to handle kernel paging request at a7a7a7c3                         
>>> IP: [<c11c5cef>] td_free+0x23/0x75                                              
>>>       
>
>   
>>>  [<c1155a42>] ? tty_ldisc_deref+0x8/0xa                                         
>>>  [<c1150c1c>] ? tty_write+0x1b1/0x1c2                                           
>>>  [<c1152d69>] ? n_tty_write+0x0/0x2e6                                           
>>>  [<c1150a6b>] ? tty_write+0x0/0x1c2                                             
>>>  [<c106431d>] ? vfs_write+0xe3/0xfa                                             
>>>  [<c1002858>] ? restore_all_notrace+0x0/0x18                                    
>>>  [<c106e3e2>] ? sys_ioctl+0x2c/0x45                                             
>>>  [<c1002825>] ? syscall_call+0x7/0xb                                            
>>> Code: e5 e8 bf 7b e9 ff 5d c3 55 89 e5 57 89 c7 56 89 d6 53 8b 42 28 89 c2 c1
>>> ea 06 31 d0 83 e0 3f 8d 94 87 cc 00 00 00 eb 03 8d 50 1c <8b> 02 85 c0 74 0b 39 
>>> EIP: [<c11c5cef>] td_free+0x23/0x75 SS:ESP 0068:c6785cb8                        
>>> CR2: 00000000a7a7a7c3                                                           
>>>       
>> And here's the real oops.  drivers/usb/host/ohci-mem.c:td_free()
>> dereferenced a7a7a7c3.  Which looks like
>>
>> /********** drivers/base/dmapool.c **********/
>> #define	POOL_POISON_FREED	0xa7	/* !inuse */
>> #define	POOL_POISON_ALLOCATED	0xa9	/* !initted */
>>     
>
> If I'm reading this correctly, the bad dereference occurred in the
> second source line:
>
> 		prev = &(*prev)->td_hash;
> 	if (*prev)
>
> The original value in *prev was 0xa7a7a7a7 and the offset of td_hash is
> 0x1c, causing the offending address to be 0xa7a7a7c3.
>
> I have no idea why a struct td would have been freed while it was still 
> in use.
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
