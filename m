Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KhrYq-0007cN-HJ
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 21:59:10 +0200
Received: by ey-out-2122.google.com with SMTP id 25so461308eya.17
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 12:59:05 -0700 (PDT)
Date: Mon, 22 Sep 2008 21:58:48 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: =?ISO-8859-15?Q?Javier_G=E1lvez_Guerrero?=
	<javier.galvez.guerrero@gmail.com>
In-Reply-To: <145d4e1a0809221142l4bea2ba8oacee793ec9e8855@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809222133560.25926@ybpnyubfg.ybpnyqbznva>
References: <145d4e1a0809220101j4063c300s7ec63ab13362bdf9@mail.gmail.com>
	<670024.49326.qm@web38804.mail.mud.yahoo.com>
	<145d4e1a0809220502v56020205o54fd186b227bdee7@mail.gmail.com>
	<alpine.LRH.1.10.0809221902461.6414@pub3.ifh.de>
	<145d4e1a0809221142l4bea2ba8oacee793ec9e8855@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-H support
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

On Mon, 22 Sep 2008, Javier G=E1lvez Guerrero wrote:

> *Barry*, did you refer to this <http://limbos.wiki.sourceforge.net/>?

Thanks for the pointer -- something new for me to learn from...
This is well ahead of where I am now, which is drawing out a
diagram of available multicast IPs and how I get there from
the different PIDs, and trying to make sense of it all...


> (Limbos project). I was looking for a specific Terratec DVB-T receiver to
> get it working but I can't find it (many versions of Terratec receivers a=
nd
> Limbos site doesn't specify which one was used). Which device did you used
> to receive DVB-H streams?

If I understand what you are asking, as far as I know in the
area where I am, all DVB-H services are broadcast with
modulation parameters that makes it possible to receive them
with any DVB-T device that can be used with Linux-DVB, so
you do not need to search for a specific receiver.  Any will
work, and I deliberately chose *not* to use my TerraTec to
verify that I could tune DVB-H on something else not specifically
intended for that as well as DVB-T.

I do not know (without looking) if this is always the case,
that DVB-H modulation can always be received by DVB-T --
just as I don't know what is the difference between a DVB-H-
capable receiver used with Linux-DVB and today's DVB-T devices.
Someone else would have to clarify that, if it's important.

I hope that's what you asked :-)


> *Uri* and *Patrick*, I thought that dvb-utils (LINUX TV) provided with a
> scan application that worked both with DVB-T and DVB-H as shown in Limbos

The scan application *can* provide useful information for
DVB-H, provided the broadcaster actually sends out that
information, but the existing `scan' only gives a useful
service ID that I can see.  Which isn't always as useful
as the example of the ORS multiplex...


> project site. I thought that through the linux TV API and applications I
> could get the PIDs and the ESG properly. Anyway, getting the ESG with
> MADFLUTE, parsing it with libxml and then getting the IP stream through t=
he
> PAT/PID (dvb-utils) could be possible?

Based on what I see so far, you need to rely heavily on
external applications, but as long as they can parse the
data within the PIDs that I'm trying to trace the flow of,
I think the existing API can get you there.

Of course, I could be speaking complete rubbish, so I'll
let someone else correct me -- I'm still working my way
through the PAT->PMT->etc->UDP-payload path by hand.


barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
