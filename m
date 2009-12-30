Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:1691 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZL3AjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 19:39:11 -0500
Message-ID: <4B3AA0BE.1000305@toaster.net>
Date: Tue, 29 Dec 2009 16:37:18 -0800
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
References: <Pine.LNX.4.44L0.0912291539450.7093-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912291539450.7093-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> You did not get the full output.  That's why I tell people to use dmesg
> instead of klogd or the kernel log files.  If necessary you can always
> increase the size of the dmesg log buffer by changing
> CONFIG_LOG_BUF_SHIFT.  I tend to set it to 18; you might want to go 
> even higher.
>
>
> That's because you didn't get the full output.  Here's an enhanced 
> version of the patch.  It will provide more information and perhaps a 
> smoking gun.
>
> Alan Stern
>   
Alan,

Thanks for the debug patch. I'll send you the dmesg.log output in 
another email. It is 2MB.

Sean


