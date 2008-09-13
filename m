Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n33.bullet.mail.ukl.yahoo.com ([87.248.110.166])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KeYya-00059K-T2
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 19:32:05 +0200
Date: Sat, 13 Sep 2008 13:29:56 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <682529.97908.qm@web55601.mail.re4.yahoo.com>
In-Reply-To: <682529.97908.qm@web55601.mail.re4.yahoo.com> (from
	o_lucian@yahoo.com on Tue Sep  9 10:31:06 2008)
Message-Id: <1221326996l.12125l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Cc: Manu Abraham <abraham.manu@gmail.com>
Subject: [linux-dvb] Re :  TT S2-3200 driver
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

Le 09.09.2008 10:31:06, lucian orasanu a =E9crit=A0:
> Hy all
> =

>  Maybe if we post logs, from stb08900 driver tunning to diferent
> transponders that dose not work will help Manu Abraham to solve the
> problem. Right??
> =

> Regards Lucian.

OK, here we go. Attached are several logs: two successes for "good" =

transponders, even if lock is a bit slow to come (freqs: 11093MHz and =

11555MHz)
Two others which are failures for 11495 and 11499 MHz (the actual =

transponder is announced at 11495Mhz freq). As you can see it gets the =

carrier OK (after a while though) but fails to get the data. This =

transponder has the same characteristic (symbol rate is 30000, =

polarisation is vertical) than the 2 others with the only diff being =

the FEC which is 5/6 instead of the more common 3/4.
HTH
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
