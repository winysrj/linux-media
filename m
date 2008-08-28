Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KYjMA-0002C9-4g
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 17:24:20 +0200
Received: by gv-out-0910.google.com with SMTP id n29so32298gve.16
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 08:24:14 -0700 (PDT)
Message-ID: <412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>
Date: Thu, 28 Aug 2008 11:24:14 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Thomas Goerke" <tom@goeng.com.au>
In-Reply-To: <004f01c90921$248fe2b0$6dafa810$@com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV-NOVA-T-500 New Firmware
	(dvb-usb-dib0700-1.20.fw) causes problems
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

2008/8/28 Thomas Goerke <tom@goeng.com.au>:
> I have been using the dvb-usb-dib0700-1.10.fw firmware for the past month
> with no issues.  After following the instructions on
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500 and updating
> the firmware to dvb-usb-dib0700-1.20.fw the card was no longer useable.
> When using Mythbuntu backend the card was not detected correctly and gave an
> unknown error.  Rolling back to dvb-usb-dib0700-1.10.fw corrected the
> problem.

Well I'm glad the 1.20 support didn't just get checked in then.
Thanks for doing this testing.

Do you happen to have the dmesg output from the failed attempt, which
might have information on the nature of the failure?  I would like to
get to the bottom of the issue.

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
