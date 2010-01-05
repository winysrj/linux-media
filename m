Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:3197 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0AEUIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 15:08:11 -0500
Message-ID: <4B439BA6.3010609@toaster.net>
Date: Tue, 05 Jan 2010 12:05:58 -0800
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
References: <Pine.LNX.4.44L0.1001051003080.3002-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001051003080.3002-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> On Mon, 4 Jan 2010, Sean wrote:
>
>   
>> Alan Stern wrote:
>>     
>>> Um, when you say it does the job, what do you mean?
>>>       
>> It traps the error and prevents the kernel from crashing.
>>     
>
> As did some of the earlier patches, right?
>
>   
Yes, but this one is good because it works without a debug kernel.
> Still, at this point I'm not sure it's worthwhile to pursue this any
> farther.  I'm convinced it's a hardware problem.  Do you want to 
> continue, or are you happy to switch computers and forget about it?
>   
Thanks so much for your help Alan. I also think this is definitely a bug 
in the hardware. Let's leave it at that, I'm happy.

Sean
