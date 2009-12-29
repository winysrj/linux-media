Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:4338 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZL2Tuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 14:50:50 -0500
Message-ID: <4B3A5D23.8050300@toaster.net>
Date: Tue, 29 Dec 2009 11:48:51 -0800
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
References: <Pine.LNX.4.44L0.0912171011410.3055-100000@iolanthe.rowland.org> <4B39C98B.9050107@toaster.net>
In-Reply-To: <4B39C98B.9050107@toaster.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




> Alan Stern wrote:
>> The patch doesn't fix anything.  The point was to gather enough 
>> information to figure out what's going wrong.  Without the debug 
>> messages, there's no information.
>>
>> Perhaps things will slow down less if you change the new ohci_info() 
>> calls in the patch to ohci_dbg().  Or perhaps you can increase the 
>> timeout values in capture-example.c.
>>
>> You should also apply this patch (be sure to enable CONFIG_USB_DEBUG):
>>
>>     http://marc.info/?l=linux-usb&m=126056642931083&w=2
>>
>> It probably won't make any difference, but including it anyway is
>> worthwhile.
>>
>> Alan Stern
>>   
> The early return in td_free that is in the patch will trap the error.
>
> I changed the debug statements to ohci_dbg and I was able to capture 
> the full output with klogd. It is attached.
>
> Sean
Sean wrote:

In looking at the log file it seems that there is a mismatch of td_alloc 
calls and td_free calls.

Sean
