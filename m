Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:37928
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZHaTfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 15:35:48 -0400
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-Id: <AB5956FE-ADF6-4BDB-A589-50BA3A808999@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Steven Toth <stoth@kernellabs.com>
In-Reply-To: <4A9C1F1F.4060108@kernellabs.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: hvr-1800 disabling audio on pvr-500?
Date: Mon, 31 Aug 2009 15:34:11 -0400
References: <86BDC1B0-F181-4D45-AD8D-2D836EE998CB@wilsonet.com> <200908312004.38112.hverkuil@xs4all.nl> <4A9C1F1F.4060108@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Aug 31, 2009, at 3:06 PM, Steven Toth wrote:

>> Sigh...
>>
>> I'll see if I have time to fix this today or tomorrow.
>
> This might help:
>
> http://www.kernellabs.com/hg/~stoth/cx25840-fw/rev/38c5fb14c770

Haven't actually tested it, but at a glance through the code, yeah,  
that looks like a winner to me. I'll toss that in a kernel build for  
the original poster to test to confirm 100%, but for now:

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



