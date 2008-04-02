Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1Jh6uY-00050Y-NF
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 19:38:11 +0200
Received: by fg-out-1718.google.com with SMTP id 22so2386647fge.25
	for <linux-dvb@linuxtv.org>; Wed, 02 Apr 2008 10:38:07 -0700 (PDT)
Message-ID: <854d46170804021031w56d056e9s788b08e1b2ac9566@mail.gmail.com>
Date: Wed, 2 Apr 2008 19:31:52 +0200
From: "Faruk A" <fa@elwak.com>
To: "=?ISO-8859-1?Q?Jens_Krehbiel-Gr=E4ther?=" <linux-dvb@okg-computer.de>
In-Reply-To: <47F3902E.6060002@okg-computer.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <JQH8LK$96D0E7F415C0B19866A44914B01BB54A@libero.it>
	<4720EEC9.7040004@gmail.com> <47F3902E.6060002@okg-computer.de>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Problems compiling hacked szap.c
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Try the szap2
hg clone http://linuxtv.org/hg/dvb-apps

It's under test directory.

If that oesn't help try using multiproto changeset 7207 and under that
did trick for me.

Faruk


On Wed, Apr 2, 2008 at 3:54 PM, Jens Krehbiel-Gr=E4ther
<linux-dvb@okg-computer.de> wrote:
> Hi!
>
>  I have problems compiling szap.c for multiproto. I use kernel 2.6.24
>  I followed the instructions of Manu posted to the list a few months ago:
>
>  > Make sure you have the updated headers (frontend.h, version.h in your =
include path)
>  > (You need the same headers from the multiproto tree)
>  >
>  > wget http://abraham.manu.googlepages.com/szap.c
>  > copy lnb.c and lnb.h from dvb-apps to the same folder where you downlo=
aded szap.c
>  >
>  > cc -c lnb.c
>  > cc -c szap.c
>  > cc -o szap szap.o lnb.o
>  >
>  > That's it
>  >
>  > Manu
>
>  but it won't work.
>
>  I get the following error:
>
>  dev:/usr/src/szap# cc -c szap.c
>  szap.c: In function 'zap_to':
>  szap.c:368: error: 'struct dvbfe_info' has no member named 'delivery'
>  szap.c:372: error: 'struct dvbfe_info' has no member named 'delivery'
>  szap.c:376: error: 'struct dvbfe_info' has no member named 'delivery'
>  szap.c:401: error: 'struct dvbfe_info' has no member named 'delivery'
>  szap.c:412: error: 'struct dvbfe_info' has no member named 'delivery'
>  dev:/usr/src/szap#
>
>  lnb.c compiles without error.
>
>  I have compiled szap under older kernel without error, but when I use
>  this compiled szap now (under 2.6.24) I get the following error:
>
>  dev:~# szap ProSieben
>  reading channels from file '/root/.szap/channels.conf'
>  zapping to 208 'ProSieben':
>  sat 0, frequency =3D 12544 MHz H, symbolrate 22000000, vpid =3D 0x01ff, =
apid
>  =3D 0x0200 sid =3D 0x445d
>  Querying info .. Delivery system=3DDVB-S
>  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  ioctl DVBFE_GET_INFO failed: Operation not supported
>  dev:~#
>
>  I've successfully compiled multiproto drivers with the compat.h patch
>  f=FCr 2.6.24 kernel. The modules load without errors, but I can not szap
>  to any channel.
>
>  Can you help me??
>
>  Thanks,
>   Jens
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
