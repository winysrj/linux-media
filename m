Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43736 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753035AbdLPN6L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 08:58:11 -0500
Date: Sat, 16 Dec 2017 11:58:04 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ralph Metzler <rjkm@metzlerbros.de>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org
Subject: Re: [bug report] drx: add initial drx-d driver
Message-ID: <20171216115804.64636ac0@recife.lan>
In-Reply-To: <23090.62262.800851.660592@morden.metzler>
References: <20171214080316.nadtlgwyng3r7gro@mwanda>
        <23090.62262.800851.660592@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Dec 2017 22:55:02 +0100
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Hello Dan Carpenter,
> 
> Dan Carpenter writes:
>  > Hello Ralph Metzler,
>  > 
>  > The patch 126f1e618870: "drx: add initial drx-d driver" from Mar 12,
>  > 2011, leads to the following static checker warning:
>  > 
>  > 	drivers/media/dvb-frontends/drxd_hard.c:1305 SC_WaitForReady()
>  > 	info: return a literal instead of 'status'
>  > 
>  > drivers/media/dvb-frontends/drxd_hard.c
>  >   1298  static int SC_WaitForReady(struct drxd_state *state)
>  >   1299  {
>  >   1300          int i;
>  >   1301  
>  >   1302          for (i = 0; i < DRXD_MAX_RETRIES; i += 1) {
>  >   1303                  int status = Read16(state, SC_RA_RAM_CMD__A, NULL, 0);
>  >   1304                  if (status == 0)
>  >   1305                          return status;
>  >                                 ^^^^^^^^^^^^^
>  > The register is set to zero when ready?  The answer should obviously be
>  > yes, but it wouldn't totally surprise me if this function just always
>  > looped 1000 times...  Few of the callers check the return.  Anyway, it's
>  > more clear to just "return 0;"
>  > 
>  >   1306          }
>  >   1307          return -1;
>  >                        ^^
>  > -1 is not a proper error code.
>  > 
>  >   1308  }
>  > 
>  > regards,
>  > dan carpenter  
> 
> I think I wrote the driver more than 10 years ago and somebody later submitted it
> to the kernel.
> 
> I don't know if there is a anybody still maintaining this. Is it even used anymore?
> I could write a patch but cannot test it (e.g. to see if it really always
> loops 1000 times ...)

It seems that it is used on this board (besides ngene):
	EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2
	a. k. a.: Hauppauge WinTV HVR 900 (R2)

I might have a HVR-900 rev 2 somewhere, but if so, it is not at the
usual place. I moved a few times since when I touched at the
drxd driver, at the time it was merged upstream. Maybe Michael or
someone at Hauppauge could test a patch for it, if they still have
this device.

Thanks,
Mauro
