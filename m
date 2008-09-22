Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KhowZ-0005hn-71
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 19:11:30 +0200
Date: Mon, 22 Sep 2008 19:10:48 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: =?ISO-8859-15?Q?Javier_G=E1lvez_Guerrero?=
	<javier.galvez.guerrero@gmail.com>
In-Reply-To: <145d4e1a0809220502v56020205o54fd186b227bdee7@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0809221902461.6414@pub3.ifh.de>
References: <145d4e1a0809220101j4063c300s7ec63ab13362bdf9@mail.gmail.com>
	<670024.49326.qm@web38804.mail.mud.yahoo.com>
	<145d4e1a0809220502v56020205o54fd186b227bdee7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579696399-1083264165-1222103448=:6414"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-H support
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

--579696399-1083264165-1222103448=:6414
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by znsun1.ifh.de id m8MHAmYK029637

Hi Javier,

On Mon, 22 Sep 2008, Javier G=E1lvez Guerrero wrote:
> Regarding the ESG I don't know how to deal with it as I'm a complete=20
> novice with LinuxTV/dvb-utils. First I wanted to know if it was possibl=
e=20
> to get DVB-H streams with it and what hardware would be proper. I=20
> supposed that demuxing and selecting the contents would be nearly the=20
> same that in DVB-T, as the main difference is the time slicing in DVB-H=
=20
> streams.

It is very different from DVB-T (where the audio/video stream is=20
transmitted with MPEG-2 packet stream sections).

In DVB-H you need to discover the IP services with some scan utility (*)=20
and then you need to feed the service's IP data (which was requested over=
=20
a multicast join request, for example).

Everything you want is existing as of today, though it might not be easy=20
to find it (*). You can use dvbsnoop to get the information of which=20
section / PID carries which IP service and then you can run dvbnet to hav=
e=20
this MPE-section demuxed and get the IP-data on the IP-stack.

In dvb-apps you'll find a project called libesg which can be used to=20
process the ESG which is carried in a certain section. To receive the ESG=
=20
you need to use a FLUTE-application (e.g. mad flute).

Patrick.

(*) - I'm currently working on a very very basic implementation of a=20
daemon which is doing the service recovery and the=20
ip-request-to-mpe-section lookup for DVB-H. The project was on standby,=20
but I'm planning to fix the latest stuff and commit it to dvb-apps this=20
weekend...
--579696399-1083264165-1222103448=:6414
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--579696399-1083264165-1222103448=:6414--
