Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KYqqD-00019o-JD
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 01:23:50 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: "'Devin Heitmueller'" <devin.heitmueller@gmail.com>
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>
In-Reply-To: <412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>
Date: Fri, 29 Aug 2008 07:24:18 +0800
Message-ID: <007f01c90965$344da360$9ce8ea20$@com.au>
MIME-Version: 1.0
Content-Language: en-au
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

> 
> Well I'm glad the 1.20 support didn't just get checked in then.
> Thanks for doing this testing.
> 
> Do you happen to have the dmesg output from the failed attempt, which
> might have information on the nature of the failure?  I would like to
> get to the bottom of the issue.
> 
> Devin
> 
Devin,  I looked at the dmesg output and it showed no errors.  So I tested
it again using both symbolic link and hard copy.  This time it worked
correctly.  I am not sure what was causing the problem before but rolling
back to the .10 definitely fixed it.  Apologies for the multicast on this
but all seems ok now using the .20 firmware.

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
