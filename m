Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L3GQW-0000sm-6q
	for linux-dvb@linuxtv.org; Thu, 20 Nov 2008 21:47:01 +0100
Received: by ik-out-1112.google.com with SMTP id c28so590148ika.1
	for <linux-dvb@linuxtv.org>; Thu, 20 Nov 2008 12:46:56 -0800 (PST)
Message-ID: <412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
Date: Thu, 20 Nov 2008 15:46:56 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linuxtv@hotair.fastmail.co.uk
In-Reply-To: <1227213591.29403.1285914127@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
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

On Thu, Nov 20, 2008 at 3:39 PM, petercarm
<linuxtv@hotair.fastmail.co.uk> wrote:
> I'll do a test build in the next hour or so and confirm behaviour with:
>
> - a Hauppauge Nova-T 500 (PCI)
> - a Hauppauge Nova-TD USB stick
>
> This will be my test gentoo system built from scratch with 2.6.25.
> Everything apart from remote was working correctly until I pulled a
> recent version down from mercurial.  My last build, based on Mercurial
> from a few days ago has got my Nova-T 500 bitching away with i2c errors
> if I stop of the lirc daemon.

The fix only went in on Sunday evening, so it's not surprising if you
had the issue with a relatively recent build.

Please do report back regarding how your testing goes.  Note that you
should not have any module options setup when you do the testing.

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
