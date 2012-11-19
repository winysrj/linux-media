Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:37775 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab2KSW0u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 17:26:50 -0500
Message-ID: <50AAB221.6060604@users.sourceforge.net>
Date: Mon, 19 Nov 2012 23:26:41 +0100
From: Philippe Valembois - Phil <lephilousophe@users.sourceforge.net>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV HVR 900 (M/R 65018/B3C0) doesn't work anymore
 since linux 3.6.6
References: <50A3FF56.3070703@users.sourceforge.net> <20121116021323.GB492@kroah.com>
In-Reply-To: <20121116021323.GB492@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 16/11/2012 03:13, Greg KH a écrit :
> On Wed, Nov 14, 2012 at 09:30:14PM +0100, Philippe Valembois - Phil wrote:
>> Hello,
>> I have posted a bug report here :
>> https://bugzilla.kernel.org/show_bug.cgi?id=50361 and I have been told
>> to send it to the ML too.
>>
>> The commit causing the bug has been pushed to kernel between linux-3.5
>> and linux-3.6.
>>
>> Here is my bug summary :
>>
>> The WinTV HVR900 DVB-T usb stick has stopped working in Linux 3.6.6.
>> The tuner fails at tuning and no DVB channel can be watched.
>>
>> Reverting the commit 3de9e9624b36263618470c6e134f22eabf8f2551 fixes the
>> problem
>> and the tuner can tune again. It still seems there is some delay between the
>> moment when the USB stick is plugged and when it can tune : running
>> dvbscan too
>> fast makes the first channels tuning fail but after several seconds it tunes
>> perfectly.
>>
>> Don't hesitate to ask me for additional debug.
> 
> Does this also fail on Linus's tree?  If so, this patch should be
> reverted from there too.
> 
> thanks,
> 
> greg k-h
> 
Hello,
sorry for the late reply, I finally compiled fresh Linus' tree and did a
fast test : it seems to work. I will now try to find the commit that
made it work so you can maybe commit it in the stable branch?

Regards,
Philippe Valembois
