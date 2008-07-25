Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2a.orange.fr ([80.12.242.138])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KMHKB-0005bT-VZ
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 09:02:48 +0200
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Fri, 25 Jul 2008 09:02:15 +0200
References: <3a665c760807242347o4dc9bed2p62e5454fb432bece@mail.gmail.com>
In-Reply-To: <3a665c760807242347o4dc9bed2p62e5454fb432bece@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807250902.15858.hftom@free.fr>
Subject: Re: [linux-dvb] question about section command in dvbsnoop
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

Le Friday 25 July 2008 08:47:53 loody, vous avez =E9crit=A0:
> Dear all:
> I try to get section information in my TS streams.
> The commands I use are:
> dvbsnoop.exe -n 1 -if F:\driver_source\TS_stream\mux1-cp.ts 0x00 >
> PAT_0.log dvbsnoop.exe -n 1 -if F:\driver_source\TS_stream\Monza.trp 0x00=
 >
> PAT_1.log
>
> But after changing the command mode to TS, I can get what I need.
> dvbsnoop.exe -s ts -N 1 -if F:\driver_source\TS_stream\mux1-cp.ts 0x00
>
> > PAT_0_ts.log
>
> dvbsnoop.exe -s ts -N 1 -if F:\driver_source\TS_stream\Monza.trp 0x00
>
> > PAT_1_ts.log
>
> Is there any option I should use but I forget?

-tssubdecode

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
