Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.coote.org ([93.97.186.182]:62660 "EHLO mercury.coote.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753427Ab0EGLJz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 07:09:55 -0400
Cc: linux-media@vger.kernel.org
Message-Id: <23EB58B6-DED9-46E4-AE75-F1EE342039EE@coote.org>
From: Tim Coote <tim@coote.org>
To: Paul Shepherd <paul@whitelands.org.uk>
In-Reply-To: <4BE31526.6020602@whitelands.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: setting up a tevii s660
Date: Fri, 7 May 2010 12:09:29 +0100
References: <4BE31526.6020602@whitelands.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 6 May 2010, at 20:14, Paul Shepherd wrote:
> [snip]
> I downloaded version from tevii.com and it worked for me on laptop
> running win 7.  Had problems with HD on an XP machine but I assumed it
> was because the video card was old/slow.
that seems a fair test. you've got to know that the device itself's  
working first
>
[snip]
>
> I tried on Ubuntu 9.10 but had problems which I documented here on 16
> april. Loading the firmware worked fine but there were problems with
> remote control messages being logged continually as well as stability
> problems. The card would tune (with scan) and worked with mythtv  
> (for a
> day or so)
I get this output, too. I think that it's debugging code that's been  
left in. I'd guess that the driver polls the device periodically and  
spits out the results. If that's right, then you can remove the  
messages from dmesg and /var/log/messages by commenting out the  
relevant info lines in the source (should be lines 1131, 1137 and 1155  
of ./linux=tevii-ds3000/linux/drivers/media/dev/dvb-usb/dw2102.c). I  
think that line 84 implies that there was an intent for these messages  
to be debug rather than info, but I'm not familiar with the coding  
standards enough to fix that. I'd guess that the crash that you  
experienced comes from something else, but goodness knows what or how  
to debug it.
>
>> I believe that I need to load up the modules ds3000 and dvb-usb- 
>> dw2102,
>> + add a rule to /etc/udev/rules.d and a script to /etc/udev/scripts.
>
> I didn't touch rules.d
Since my initial post, I've tried a vanilla xubuntu 10.04, (at the  
suggestion of a member of the list who'd got it working with this  
build) which still only populates /dev/dvb/adapter0/{demux0 drv0 net0}  
and not frontend0. See below.
[snip]
>
>
> Had no problem with Ubuntu recognising the device and the correct .fw
> file being downloaded.
>
> There are various versions of dw2102.c from tevii, etc.  I think I  
> tried
> all of them. I did change the timeout on RC messages (dw2102.c?) which
> helped but did not cure the problem.
>
> Also tried the s2-liplianin library as well which seemed promising but
> also did not cure the problem.
>
I'm less sure now about my conclusions about downloading the .fw.  
Certainly on xubuntu *something* is happening as I get a blue led  
flash on plugging in the tevii.
>> [snip]

>> didn't have the knowledge (or time) to decide if the problem was in
> the firmware or the v4l drivers or perhaps some strange interaction  
> with
> my dvb-t usb box.
>
> Exchanged some emails with tevii guys who had posted here however they
> appear to take the view that if it works under windows then the device
> is fine and offer no other solution.
>
> In the end I bought a Nova S2 PCI card which works fine but would be
> interested in trying to get the S660 working.
>
I don't have a pc that's big enough to take a pci card, and the  
hardware clearly works. However, to debug what's going wrong, there  
needs to be a repeatable test process, and a baseline system where the  
different failure modes can be tied down. That's why I set up the  
xubuntu system and used a .config file thats known to work. However,  
there's still other stuff to load on a vanilla box, including:
build-essentials
linux-headers-2.6.32-22-generic
and possibly libncurses5-dev and a complete kernel source tree,  
although I've avoided this by reusing the .config file.

I'm still assuming that 'working' means that I can use dvbscan (which  
needs the frontend0 file, I think, although the reported error on  
xubuntu is different from mythbuntu and it just says "Failed to open  
frontend".

I'm afraid that in a situation like this, I don't know what I don't  
know. And I don't know what I can rely on or what success is. Not a  
great recipe for getting anything to do what you want.

I can understand tevii's point of view, but I need to get this working  
on Linux.  I don't think that Tevii wrote the code and it is slightly  
modified from the mercurial code, so there needs to be some sort of  
merge back if and when it is ever made to work.
> paul

