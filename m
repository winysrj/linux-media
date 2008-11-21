Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L3KPx-0005uN-O8
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 02:02:42 +0100
Received: by ik-out-1112.google.com with SMTP id c28so677468ika.1
	for <linux-dvb@linuxtv.org>; Thu, 20 Nov 2008 17:02:38 -0800 (PST)
Message-ID: <412bdbff0811201702n6893fb87je2e93538dae1cdc4@mail.gmail.com>
Date: Thu, 20 Nov 2008 20:02:37 -0500
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

Please stop top posting - it is a violation of mailing list policy.

Lirc is not required for this device.  It is automatically hooked into
the keyboard driver.

Which remote control are you using?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
