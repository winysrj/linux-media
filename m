Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.228])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <makosoft@googlemail.com>) id 1JrAKE-0001Rp-KK
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 13:18:18 +0200
Received: by rv-out-0506.google.com with SMTP id b25so270309rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 30 Apr 2008 04:18:09 -0700 (PDT)
Message-ID: <c8b4dbe10804300418xdb464d7t3b135df3e14a3d14@mail.gmail.com>
Date: Wed, 30 Apr 2008 12:18:09 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: andy <andy.white@gmail.com>
In-Reply-To: <d350e5180804290541q6455c0b3s63aafbbc17e424e2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <d350e5180804290541q6455c0b3s63aafbbc17e424e2@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hauppauge HVR 900H
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

2008/4/29 andy <andy.white@gmail.com>:
> Hi,  I got one of these at the weekend, not noticing it's a 'H' version, and
> isn't currently supported, an it looks like supplies of the non H version
> are low from the usual suppliers.
>
> From posts, It looks like this is tm6000 based, that I should add the usb id
> ( 0x2040, 0x6600 )  to tm6000-cards.c and extract the firmware from
> emBDA.sys (taken from driver CD).
>
> I am stalled at the firmware extraction, extract_xc3028.pl  doesn't
> recognize this and gives a hash error :-), and am confused to there being a
> single firmware if there are two chipsets (tm6000 and em28xx) covered in the
> one emBDA.sys ?
>
> I tried hvr 12x0 firmware and got
>  7377.869117] xc2028 0-0061: Loading 80 firmware images from
> tm6000-xc3028.fw, type: xc2028 firmware, ver 2.7
> [ 7377.869226] xc2028 0-0061: Firmware type SCODE (60000000), id 0 is
> corrupted (size=6704, expected 12586192)
>
> I also tried to compile firmware-tool, but it has problems compiling.
>
> Before I sink many more hours into this, has any made any progress with this
> card or can point me in the right direction ?

Hi,

The firmware you're referring to is for the xc3028 tuner chip, which
is used by lots of different hardware (including various em28xx and
tm6000 based hardware). IIRC, the tm6000-based hardware supposedly
needs a different firmware to the one used by anything else, but the
driver still shouldn't report the firmware file as corrupt.

Incidentally, if you're using http://linuxtv.org/hg/~mchehab/tm6000 I
suspect you should be using http://linuxtv.org/hg/~mchehab/tm6010
instead - it seems to be the more up-to-date version. (In particular,
the firmware file format may have changed since tm6000, which would
explain your problems.)

Aidan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
