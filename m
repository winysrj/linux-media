Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JdCH4-0005u1-QG
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 23:33:16 +0100
Date: Sat, 22 Mar 2008 23:32:36 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
In-Reply-To: <47B0A591.9030408@web.de>
Message-ID: <Pine.LNX.4.64.0803222155310.26601@pub6.ifh.de>
References: <47B0A591.9030408@web.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="579696143-1016109125-1206219332=:26601"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] reworked patch to support TT connect S-2400
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

--579696143-1016109125-1206219332=:26601
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-1; FORMAT=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by znsun1.ifh.de id m2MMWaMZ002028

Hi Andre,

thanks for your patch - I just committed it and ask Mauro for pulling it=20
to the main v4l-dvb-tree - it should go into 2.6.25.

Patrick.

On Mon, 11 Feb 2008, Andr=E9 Weidemann wrote:
> Hi all,
> thanks to Patrick Boettcher I finally managed to get both, the Pinnacle=
 400e=20
> and the TT connect S-2400 working on the same machine.
>
> I attached a patch which should apply cleanly against current HG.
> Please test the attached patch.
> I extracted the necessary firmware file from the TT driver and put it h=
ere:=20
> http://ilpss8.dyndns.org/dvb-usb-tt-s2400-01.fw
>
> Any comments on the patch are welcome.
>
> Thank you.
>  Andr=E9
>
--579696143-1016109125-1206219332=:26601
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--579696143-1016109125-1206219332=:26601--
