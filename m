Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KWNga-0004gP-VC
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 05:51:41 +0200
Received: by ik-out-1112.google.com with SMTP id c21so197023ika.1
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 20:51:37 -0700 (PDT)
Message-ID: <412bdbff0808212051i4cfcfe7cnebc6bd0b1c957abc@mail.gmail.com>
Date: Thu, 21 Aug 2008 23:51:37 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <37219a840808211329j697556fcj760057bb1c7b58a8@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1219330331.15825.2.camel@dark> <48ADCC81.5000407@nafik.cz>
	<37219a840808211321k34590d38v7ada0fb9655e5dfe@mail.gmail.com>
	<412bdbff0808211325h64d454d5m3353d8756b9eb737@mail.gmail.com>
	<37219a840808211329j697556fcj760057bb1c7b58a8@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 and analog broadcasting
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

On Thu, Aug 21, 2008 at 4:29 PM, Michael Krufky
> Lets sync up when you get to that point -- I have a good chunk of code
> written that will add analog support to the dvb-usb framework as an
> optional additional adapter type.
>
> Hopefully I'll get more work done on it before then, but if not, this
> is at least a good starting point.
>
> The idea is to add support to the framework so that the sub-drivers
> (such as dib0700, cxusb et al) can all use the common code.
>
> CX25843 is already supported, just the dvb-usb framework currently
> lacks a v4l2 interface.

Will do.  I'm going back and forth now with Patrick to get his new
firmware and i2c interface integrated which will hopefully cause my
xc5000 to start working.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
