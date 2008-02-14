Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JPaYd-0005nX-Hq
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 10:39:07 +0100
Received: by rn-out-0910.google.com with SMTP id j40so520481rnf.20
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 01:39:03 -0800 (PST)
Message-ID: <8ceb98f20802140139j307e02c8t473f12496d37cdcb@mail.gmail.com>
Date: Thu, 14 Feb 2008 10:39:02 +0100
From: "Filippo Argiolas" <filippo.argiolas@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <8ceb98f20802140120s4fdc9912wc1f30baa4c8d4da4@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1202892942.22746.37.camel@tux>
	<8ceb98f20802140120s4fdc9912wc1f30baa4c8d4da4@mail.gmail.com>
Subject: Re: [linux-dvb] wintv nova-t stick, dib0700 and remote controllers..
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I'm asking this because calling dib0700_rc_setup after each keypress
poll resets the ir data into the  device to  0 0 0 0. What I'd like to
know since I know almost nothing about dvb devices if is this going to
someway damage my device if called each 150ms (period of the poll).
If not I'll write a patch to support some of my remotes as well
repeated keys events as soon I'll have some spare time.
Does any of you know a different method to erase last received data
from the device?



2008/2/14, Filippo Argiolas <filippo.argiolas@gmail.com>:
> No answer?
>  Please could someone tell me if is it dangerous to call
>  dib0700_rc_setup (from dib0700core.c) every 100ms to reset remote
>  control data? Do you know any other method to reset data about last
>  key received from the ir sensor?
>  Thanks
>
> Filippo
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
