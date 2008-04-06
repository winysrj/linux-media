Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JiVN7-0007Pk-CE
	for linux-dvb@linuxtv.org; Sun, 06 Apr 2008 15:57:30 +0200
Date: Sun, 6 Apr 2008 15:56:44 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Greg Thomas <Greg@TheThomasHome.co.uk>
In-Reply-To: <e28a31000804060623u141fc8e2hd6405809ce6fe477@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804061551510.23914@pub4.ifh.de>
References: <e28a31000804060623u141fc8e2hd6405809ce6fe477@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579715599-846709373-1207490204=:23914"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] WinTV-NOVA-TD & low power muxes
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579715599-846709373-1207490204=:23914
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by znsun1.ifh.de id m36DuiW3025072

Hi Greg,

Do you have the possibility to try the device with the Hauppauge Windows=20
driver?

The linux driver is maybe not configuring the device optimally, because i=
t=20
is more generic, whereas the manufacturer's driver is specifically for=20
this particular device.

There have been some updates some time ago to improve the sensitivity. Ca=
n=20
you try a more recent driver (v4l-dvb from hg or 2.6.25).

THe reported SNR of zero is expected: the driver does not set the=20
indicator to something useful.

Patrick.


On Sun, 6 Apr 2008, Greg Thomas wrote:

> I have a WinTV-NOVA-TD stick
> (http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-TD-Stick)
> - running off the Sudbury transmitter (uk-sudbury at
> http://linuxtv.org/hg/dvb-apps/file/2686c080e0b5/util/scan/dvb-t/).
>
> If I follow the "Testing your DVB device" Wiki page, it works fine for
> muxes 2 & 4 (the higher power ones), but can find no channels at all
> on the other muxes - whilst my cheap =A320 supermarket DVB-T STB works
> just fine. Is it that
>
> (a) USB DVB-T sticks are just less sensitive than an STB,
> (b) The NOVA-TD is just less sensitive than normal for a USB stick, or
> (c) Something else I'm completely missing.
>
> Sorry if this is a stupid question, but I'm kind of new at all this!
>
> Also, I noticed that tzap always reports the snr as 0000 for those
> channels it can find; that seems a little unlikely at best, to me!
>
> Thanks,
>
> Greg
> Kernel: 2.6.24-15-generic
> Firmware: /lib/firmware/2.6.24-15-generic/dvb-usb-dib0700-1.10.fw
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--579715599-846709373-1207490204=:23914
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--579715599-846709373-1207490204=:23914--
