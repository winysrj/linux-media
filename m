Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ag-out-0708.google.com ([72.14.246.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mijhail.moreyra@gmail.com>) id 1KZEGI-0006ey-4h
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 02:24:19 +0200
Received: by ag-out-0708.google.com with SMTP id 8so2835692agc.0
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 17:24:13 -0700 (PDT)
Message-ID: <753031600808291724k352c6fa4k25456da284287c3a@mail.gmail.com>
Date: Fri, 29 Aug 2008 19:24:13 -0500
From: "Mijhail Moreyra" <mijhail.moreyra@gmail.com>
To: "Tim Lucas" <lucastim@gmail.com>
In-Reply-To: <e32e0e5d0808291401x39932ab6q6086882e81547f84@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <e32e0e5d0808291401x39932ab6q6086882e81547f84@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
	HVR-1500
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

2008/8/29, Tim Lucas <lucastim@gmail.com>:
> Can this code for cx23885 analog support be adapted for the DViCO Fusion
> HDTV7 Dual Express which also uses the cx23885?  Currently the driver for
> that card is digital only and I am stuck with a free antiquated large
> satellite system that is analog only in my apartment. I am willing to put in
> the work if someone can point me in the right direction.  Thank you,
>
> --Tim
>

The patch should add analog TV and audio support for any cx23885 based
card but currently it assumes a xc3028 tuner so an appropiate tuner
callback must be set up if needed.

The patch should also work with 23887 based cards but needs some
configuration for the SRAM TV audio channel.

Regards,

Mijhail Moreyra

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
