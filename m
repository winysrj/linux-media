Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jackden@gmail.com>) id 1KXyUx-00030y-Oo
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 15:22:16 +0200
Received: by ti-out-0910.google.com with SMTP id w7so1696664tib.13
	for <linux-dvb@linuxtv.org>; Tue, 26 Aug 2008 06:22:09 -0700 (PDT)
Message-ID: <ede8a03f0808260622we595019p1289ce1d8bdbe50f@mail.gmail.com>
Date: Tue, 26 Aug 2008 21:22:09 +0800
From: jackden <jackden@gmail.com>
To: stev391@email.com
In-Reply-To: <20080825220305.429DA4782FC@ws1-5.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080825220305.429DA4782FC@ws1-5.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
	TV/FM capture card
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

2008/8/26  <stev391@email.com>:
>
--snip--
> Jackden,
>
> Thanks for completing the information on the wiki page.
>
> To use i2cdetect you need to load i2c_dev module (or something similar).  i2cdetect is part of lm sensors so maybe you should install this if you haven't already. (perhaps try Google for an answer...)
>
> From what you have posted I still think it is possible to support this card easily, but as you cannot provide me with the output of Regspy (which is windows) I will have do a little of trial and error.  So hopefully you are very patient. (I still need the output of i2cdetect before I create a patch).
>
> Regards,
> Stephen.
>
> --
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com
>
Stephen,

I update information on the wiki page of i2cdetect's output.

--
i2cdetect -l :

  i2c-0	unknown   	SMBus nForce2 adapter at 4c00   	N/A
  i2c-1	unknown   	SMBus nForce2 adapter at 4c40   	N/A
  i2c-2	unknown   	cx23885[0]                      	N/A
  i2c-3	unknown   	cx23885[0]                      	N/A
  i2c-4	unknown   	cx23885[0]                      	N/A
--
I guess i2c-0 and i2c-1 are asus motherboard (m2n4-sli) on board chip....


----=Jackden in Google=----
--=Jackden@Gmail.com=--

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
