Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L70t1-0000Fa-3C
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 05:59:56 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1343910nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 30 Nov 2008 20:59:51 -0800 (PST)
Message-ID: <412bdbff0811302059p23155b1dka4c67fcb8f17eb0e@mail.gmail.com>
Date: Sun, 30 Nov 2008 23:59:51 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linuxtv@hotair.fastmail.co.uk
In-Reply-To: <1227228030.18353.1285952745@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
	<412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
	<1227228030.18353.1285952745@webmail.messagingengine.com>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] dib0700 remote control support fixed
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

On Thu, Nov 20, 2008 at 7:40 PM, petercarm
<linuxtv@hotair.fastmail.co.uk> wrote:
> OK it is working on the Nova-T 500 but it is throwing up "Unknown remote
> controller key" messages in dmesg in amongst correctly processing the
> correct key presses.  I'll try using irrecord to work on a new
> lircd.conf and see if it goes away.

Hello Peter,

I am following up on your issue with your Nova-T 500.  I noticed the
following update to the linuxtv.org wiki:

http://www.linuxtv.org/wiki/index.php?title=Template:Firmware:dvb-usb-dib0700&curid=3008&diff=18052&oldid=17297

If there is a problem with the dib0700 1.20 firmware, I would like to
get to the bottom of it (and get Patrick Boettcher involved as
necessary).  I am especially concerned since this code is going into
2.6.27 and the behavior you are describing could definitely be
considered a regression.

As far as I have heard, most people have reported considerable
improvement with the 1.20 firmware, including users of the Nova-T 500.
 So I would like to better understand what is different about your
environment.

Could you please summarize the results of your testing on both
devices?  In particular, there should be no lircd involved, as this
device should be sending keystrokes directly via the kernel.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
