Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KWcJz-0000gY-AJ
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 21:29:20 +0200
Received: by nf-out-0910.google.com with SMTP id g13so632300nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 12:29:16 -0700 (PDT)
Message-ID: <412bdbff0808221229l3cd3bdf9u5d4739dae2b5bbec@mail.gmail.com>
Date: Fri, 22 Aug 2008 15:29:15 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: mailgk@xs4all.nl
In-Reply-To: <1219433126.3724.37.camel@gk-sem3.gkall.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <1219433126.3724.37.camel@gk-sem3.gkall.nl>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] dib0700_devices.c patched for xc5000
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

I am actively working on the Pinnacle 801e, which uses the xc5000 on
the dib0700.  I have been working through issues with Steven Toth (the
xc5000) maintainer as well as Patrick Boettcher (the dib0700
maintainer).

As soon as I have code that works I will post it.  Firmware loading is
working but I am dealing with various i2c related issues.

Devin

On Fri, Aug 22, 2008 at 3:25 PM, Gerard <mailgk@xs4all.nl> wrote:
> Hello,
>
> Question is if somebody has done already some updates/patches to the
> dib0700_devices.c file for interface with the xc5000.
>
> I am interrested to use it for testing the Pinnacle 340e (with xc4000).
>
> --
> --------
> m.vr.gr.
> Gerard Klaver
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
