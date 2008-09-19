Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KgZah-0007vU-Pw
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 08:35:45 +0200
Date: Fri, 19 Sep 2008 08:35:01 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Thierry Merle <thierry.merle@free.fr>
In-Reply-To: <ce9f20ac2ae714295e7aeef3f4f7730e.squirrel@78.226.152.136:8080>
Message-ID: <alpine.LRH.1.10.0809190830370.8673@pub1.ifh.de>
References: <ce9f20ac2ae714295e7aeef3f4f7730e.squirrel@78.226.152.136:8080>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [RFC] cinergyT2 rework final review
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

Hi Thierry,

On Fri, 19 Sep 2008, Thierry Merle wrote:

> Hello all,
> About the rework from Tomi Orava I stored here:
> http://linuxtv.org/hg/~tmerle/cinergyT2
>
> since there seems to be no bug declared with this driver by testers (I
> tested this driver on AMD/Intel/ARM platforms for months), it is time for
> action.
> If I receive no problem report before 19th of October (in one month), I
> will push this driver into mainline.

Are you really sure you want to wait until October 19 with that? You heard 
Jonathan this morning, he is expecting a new release every day now, so the 
merge window will start quite soon. Maybe it would be better to shorten 
your deadline in favour of having the driver in-tree for 2.6.28. When it 
is inside it is still possible for at least 1.5 months to fix occuring 
problems.

> This modification uses the dvb-usb framework, this is
>
> To give you an idea of the code benefit, here is a diffstat of the
> cinergyT2 rework patch:
> linux/drivers/media/dvb/cinergyT2/Kconfig        |   85 -
> linux/drivers/media/dvb/cinergyT2/Makefile       |    3
> linux/drivers/media/dvb/cinergyT2/cinergyT2.c    | 1150
> ---------------------
> linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c |  230 ++++
> linux/drivers/media/dvb/dvb-usb/cinergyT2-fe.c   |  351 ++++++
> linux/drivers/media/dvb/dvb-usb/cinergyT2.h      |   95 +
> linux/drivers/media/dvb/Kconfig                    |    1
> linux/drivers/media/dvb/dvb-usb/Kconfig            |    8
> linux/drivers/media/dvb/dvb-usb/Makefile           |    4
> 9 files changed, 688 insertions(+), 1239 deletions(-)

Impressive. It means there are currently around 600 lines boilerplate code 
in the cinergyT2-driver (I like this word ;) )

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
