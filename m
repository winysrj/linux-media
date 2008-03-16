Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1Jazgu-0005NY-7R
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 21:42:51 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1708642tia.13
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 13:42:41 -0700 (PDT)
Message-ID: <abf3e5070803161342y4a68b638m1ae82e8b24cc9a4b@mail.gmail.com>
Date: Mon, 17 Mar 2008 07:42:39 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: insomniac <insomniac@slackware.it>
In-Reply-To: <20080316182618.2e984a46@slackware.it>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080316182618.2e984a46@slackware.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New unsupported device
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

On Mon, Mar 17, 2008 at 4:26 AM, insomniac <insomniac@slackware.it> wrote:
> Hi to everyone on the list,
>  this is my first post on the mailing list. I landed here after a lot of
>  searching for a working driver for my DVB-T USB stick. I bought a
>  Pinnacle PCTV Nano Stick (code: 73e) with HD capabilities, and I
>  discovered that it came on the market very recently (less than one month
>  ago).
>  As long as no google search, nor post search on linux-dvb mailing list
>  had success, it looks this is my last chance to get my card working on
>  GNU/Linux.
>
>  Here is the (actually useless) output I get from dmesg:
>  usb 1-1: new high speed USB device using ehci_hcd and address 5
>  usb 1-1: configuration #1 chosen from 1 choice
>
>  and here is my lsusb -v output about the card:
>  http://insomniac.slackware.it/lsusb.pinnacle.txt
>
>  In the hope that there's a light at the end of the tunnel, I thank you
>  all for your patience and your work.
>
>  Best regards,
>  --
>  Andrea Barberio
>

The best way you can help is to either tell us what the windows drivers
are, or open the device up and tell us what is written on both the
tuner chip and the main chip. They are generally the two biggest
chips on the board and they have writing on the top.

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
