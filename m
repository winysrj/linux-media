Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bvidinli@gmail.com>) id 1K1J9t-0004k5-Pn
	for linux-dvb@linuxtv.org; Wed, 28 May 2008 12:45:31 +0200
Received: by wa-out-1112.google.com with SMTP id n7so3061960wag.13
	for <linux-dvb@linuxtv.org>; Wed, 28 May 2008 03:45:23 -0700 (PDT)
Message-ID: <36e8a7020805280345x3d85ed08x704afbed5e9a9dc0@mail.gmail.com>
Date: Wed, 28 May 2008 13:45:23 +0300
From: bvidinli <bvidinli@gmail.com>
To: "Bug 220857" <220857@bugs.launchpad.net>, linux-dvb@linuxtv.org
In-Reply-To: <20080527203036.15120.80879.malone@gandwana.canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080423021731.19061.82477.malonedeb@gandwana.canonical.com>
	<20080527203036.15120.80879.malone@gandwana.canonical.com>
Subject: Re: [linux-dvb] [Bug 220857] Re: linuxtv.org mercurial repository
	wont build against hardy kernel due to "disagrees about
	version of symbol videobuf_*
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is an important issue, "being unable to compile linuxtv drivers on ubu=
ntu."

this also affects our trust to ubuntu and linux in future,
i try to build a set-top-box using ubuntu and mythtv, and i cannot do
it only because of this compilation issue.

So, i may also do a payment to linuxtv community or whoever solves
this issue permanently...
i think we must support linux/ubuntu community  (or Pardus in Turkiye/Turke=
y)

Thanks, see you

2008/5/27 Posh <jpontious@gmail.com>:
> Well new image came out (2.6.24-17).  Seems this bug was thought
> about...
>
>  * sound: Include config.h and config1.h into lum headers. This enables
>     third party modules to be built correctly against LUM ALSA headers.
>     This fix is a follow-on to the work done to correclty build cx88/saa1=
734
>     alsa modules.
>
> * Removed cx88/saa1734 media modules. Only build ALSA modules for these
> devices.
>     Building the media modules in LUM was causing problems for Mythbuntu
>     when they upgraded kernel video modules. They aren't needed in LUM
>     and have no ALSA dependencies. The cx88/saa1734 kernel modules are
>     indentical to those that were being built in LUM.
>
> So now it looks like the only problem is getting the cx88 and saa7134 als=
a modules to compile.
> I tried several things.  I have been unsuccessful in forcing them to comp=
ile at this point.  I tried sym linking everything from the LUM heaaders so=
und directory into the regular linux headers sound directory but that didn'=
t seem to help.  Maybe someone else out there can find a workaround for thi=
s.
>
> --
> linuxtv.org mercurial repository wont build against hardy kernel due to "=
disagrees about version of symbol videobuf_*
> https://bugs.launchpad.net/bugs/220857
> You received this bug notification because you are a direct subscriber
> of the bug.
>



-- =

=DD.Bahattin Vidinli
Elk-Elektronik M=FCh.
-------------------
iletisim bilgileri (Tercih sirasina gore):
skype: bvidinli (sesli gorusme icin, www.skype.com)
msn: bvidinli@iyibirisi.com
yahoo: bvidinli

+90.532.7990607
+90.505.5667711
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
