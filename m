Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1JapVs-0005H6-P4
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 10:50:45 +0100
Received: by fg-out-1718.google.com with SMTP id 22so3821932fge.25
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 02:50:41 -0700 (PDT)
Message-ID: <47DCED6F.6020704@googlemail.com>
Date: Sun, 16 Mar 2008 10:50:39 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <JXST28$838B51422BBDA91CE4FD6588B0A61AB2@libero.it>
In-Reply-To: <JXST28$838B51422BBDA91CE4FD6588B0A61AB2@libero.it>
Subject: Re: [linux-dvb] big problem with dexatek sphere dk-5701 bt878 sat
 card
Reply-To: thomas.schorpp@googlemail.com
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

abc336633@libero.it wrote:
> Hallo, I'm having a big trouble with dexatek sphere dk-5701 card. 
> When I have this pci card plugged in motherboard, when trying to
> install or boot (after having installed without the card)ubuntu (any
> version) the system freezes when it has to recognize the card giving
> this message: bttv0: subsytsem 0000:2001 unknown card detected=0 
> bt878 (rev 17) irq 17 latency 32 mmio 0xfdaff000 I can't find a
> driver that make it works neither a way to disable the card just to
> boot ubuntu. The only way to use ubuntu for me at the moment is to
> unplug the card!
> 

1. this is about v4l-dvb linux kernel driver not about distros like ubuntu.
state kernel (v4l-dvb hg) version pls. 

2. searching the list-archives before opening new threads is mandatory, 
ive reported this issue about a year ago. thx for the confirmation.

use SysReq keys and report where the kernel freezes (stacktrace), 
if You want to have boot fixed. i dont have got this card anymore.

this card uses a unknown? pci-bridge and a sharp tuner. 
dexatek and sharp refused to release programming information 
about their products to us, so creating a driver would require 
reverse engineering with a pci-extender and i2c sniffing.

since there are many supported cards available for only 5-10 bucks more 
this is an uneconomical effort, so throw this card back to the 
seller until dexatek and sharp provide support to linux developers.

sorry
y
tom




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
