Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n35.bullet.mail.ukl.yahoo.com ([87.248.110.168])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KUAXH-0008M5-Mr
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 03:24:56 +0200
Date: Fri, 15 Aug 2008 21:24:17 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <468178.93567.qm@web36102.mail.mud.yahoo.com>
In-Reply-To: <468178.93567.qm@web36102.mail.mud.yahoo.com> (from
	knueffle@yahoo.com on Fri Aug 15 14:39:56 2008)
Message-Id: <1218849857l.17885l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  how to save epg data directly from dvb device?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 15.08.2008 14:39:56, Jody Gugelhupf a =E9crit=A0:
> Hi there, =

> i got a dvb-s pci card, I want to get all the epg data available from
> several satellites, all the channels they got. I got two questions.
> =

> 1. Is it possible using dvbstream to save the raw epg data in a file?
>   1.1 if yes, how?
>   1.2 if no, how can i save the raw epg data from dvb-s?
> 2. What kind of converters are there already, that convert raw epg
> data into any usable format e.g. xml ? and which ones are those?
> =

> thx for any help and please any hints tips are welcome :)
> jody :D

You can probably use dvbsnoop on the correct pid (dont remember now but =

easy to find I guess) and set the filters correctly to get the eit =

tables only. Use -b to get the raw stream (without it dvbsnoop will =

decode it for you that might help you in the process).
HTH
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
