Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:55969 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZEXIjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 04:39:08 -0400
Message-ID: <4A1906DE.8000701@unsolicited.net>
Date: Sun, 24 May 2009 09:35:42 +0100
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: Alan Stern <stern@rowland.harvard.edu>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net, leonidv11@gmail.com,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
 down
References: <Pine.LNX.4.44L0.0905231657210.22430-100000@netrider.rowland.org>	 <4A189187.4020407@unsolicited.net> <1243126473.3705.6.camel@pc07.localdom.local>
In-Reply-To: <1243126473.3705.6.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton wrote:
> Hi,
>
> Am Sonntag, den 24.05.2009, 01:15 +0100 schrieb David:
>   
>> Alan Stern wrote:
>>     
>>> It's not obvious what could be causing this, so let's start out easy.  
>>> Try collecting two usbmon traces (instructions are in
>>> Documentation/usb/usbmon.txt), showing what happens with and without
>>> the reversion.  Maybe some difference will stick ou
>>>   
>>>       
>> Traces attached. Took a while as my quad core hangs solid when 0u is
>> piped to a file (I had to compile on a laptop and take the logs there).
>>
>> Cheers
>> David
>>
>>
>>     
>
> just a note, since you said it is some ATI chipset.
>
> Is it the SB700?
>
> We have lots of reports about disconnects, but then also claimed to be
> fixed in between, and i don't know the current status ...
>   
The latest trace is from an Intel dual core (SL9400) laptop, so the
problem exists across Nvidia, ATI and Intel USB Hardware.

The ATI system with the quad core (AMD 790FX, Phenom)  hangs solid when
trying to use usbmon though (if that's what you are getting at)?

David
