Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36442 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbdFZPWz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 11:22:55 -0400
Received: by mail-wm0-f66.google.com with SMTP id y5so832995wmh.3
        for <linux-media@vger.kernel.org>; Mon, 26 Jun 2017 08:22:54 -0700 (PDT)
Date: Mon, 26 Jun 2017 17:22:51 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, crope@iki.fi, jasmin@anw.at,
        Yasunari.Takiguchi@sony.com, tbird20d@gmail.com
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170626171701.58dac8d0@audiostation.wuest.de>
In-Reply-To: <22864.56056.222371.477817@morden.metzler>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
 <20170412212327.5b75be19@macbox>
 <20170507174212.2e45ab71@audiostation.wuest.de>
 <20170528234537.3bed2dde@macbox>
 <20170619221821.022fc473@macbox>
 <20170620093645.6f72fd1a@vento.lan>
 <20170620204121.4cff42d1@macbox>
 <20170620161043.1e6a1364@vento.lan>
 <20170621225712.426d3a17@audiostation.wuest.de>
 <22860.14367.464168.657791@morden.metzler>
 <20170624135001.5bcafb64@vento.lan>
 <20170625195259.1623ef71@audiostation.wuest.de>
 <20170626061920.2f0aa781@vento.lan>
 <22864.56056.222371.477817@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Resend since I received bad-mail-address bounces, sorry for any
duplicated email.

Am Mon, 26 Jun 2017 11:59:20 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Mauro Carvalho Chehab writes:
>  > 
>  > Splitting it is OK. Including a *.c file no. It shouldn't be hard
>  > to  
> [...]
> > change the makefile to:
>  > 	obj-ddbridge = ddbridge-main.o ddbridge-core.o
>  > ddbridge-i2c.o \ ddbridge-modulator.o and ddbridge-ns.o
>  > 
>  > The only detail is that "ddbridge.c" should be renamed to 
>  > ddbridge-core.c (or something similar) and some *.h files will
>  > be needed.  
> 
> Hmm, ddbridge -> ddbridge-main would be fine.

Funny, that's exactly the naming I had in mind when thinking about this
in the past :)

So, I'll propose a rough todo (commit list) for me (I will do and
care about this) then:

- 1/4: (Step 0) Since dddvb-0.9.9b besides the split also involved
  reordering the functions in the code, this will be repeated with the
  current mainline driver (helps keeping the diff with the actual code
  bump cleaner)
- 2/4: Do the split like done in 0.9.9 with the mainline driver, but do
  it by having multiple objects in the makefile, adding header files
  with prototypes where required
- 3/4: Bump the driver code with what is already there (means, the
  pre-cleaned variant w/o modulator and netstream/octonet stuff)
- 4/4 (or 4/x): Apply any additional patches (like the "enable msi by
  default Kconf opt, marked EXPERIMENTAL" thing I did to work around
  the still problematic MSI IRQ stuff to let users have a better
  experience)

When done, I'll post the patches for early review, but they'll have a
hard dependency on the stv0910/stv6111 demod/tuner drivers (don't feel
like ripping this out since we want that support anyway).

Additionally,I can do this for dddvb and submit it to the
DigitalDevices dddvb repository (GitHub Pull Request) so we're at least
in-sync wrt building the driver.

Ralph, Mauro, are you ok with this?

Mauro, in the meantime a decision should be made if the current
in-kernel ddbridge should be kept somewhere or not (ie. as legacy
driver). IMHO this is not absolutely neccessary since both driver
variants (dddvb directly and the "castrated" one) are in use by people
all around and besides MSI (which we can workaround until fixed
finally) I don't know of any complaints at all.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
