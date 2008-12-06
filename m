Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1L915y-00078L-NN
	for linux-dvb@linuxtv.org; Sat, 06 Dec 2008 18:37:35 +0100
Date: Sat, 06 Dec 2008 18:37:01 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <c74595dc0812060928l467825fbq79a0a62d5882df8d@mail.gmail.com>
Message-ID: <20081206173701.69400@gmx.net>
MIME-Version: 1.0
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <4938C8BB.5040406@verbraak.org>
	<c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>
	<20081206170753.69410@gmx.net>
	<c74595dc0812060928l467825fbq79a0a62d5882df8d@mail.gmail.com>
To: "Alex Betis" <alex.betis@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan (possible
	diseqc	problem)
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

> > I have a Twinhan 1041 card and I have problems with the s2-liplianin
> driver
> > which I have not fully understood yet.
> >
> > 1) Scan-s2 works for a while but in a long scan I eventually I start
> > getting
> > "Slave RACK Fail !" messages in dmesg and scan-s2 hangs. Perhaps
> increasing
> > to
> > msleep(15) in mantis_ack_wait helps (it hasn't eliminated the problem),
> but
> > I am not sure.
> > There are messages in /var/log/messages from
> > stb6100_[set/get]_[frequency/bandwidth]
> > which say "Invalid parameter". Only shutting down the computer and
> > restarting seems to
> > recover from this once it has happened.
> =

> I never had that "Slave RACK" problem, =


Strange, I have always (since forever) had that problem. Can anyone =

comment on what's going on?

> but I think I saw some messages
> that
> says it was solved.

Do you have a link? I couldn't find it.

> Do you use the latest drivers?

Yes latest drivers, and latest versions of scan-s2 and szap-s2, so if the p=
roblem has been
solved it is not implemented in s2-liplianin.

Hans
-- =

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
