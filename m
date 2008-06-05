Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n36.bullet.mail.ukl.yahoo.com ([87.248.110.169])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1K4Lbx-0001eK-IG
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 21:59:04 +0200
Date: Thu, 05 Jun 2008 15:58:05 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
References: <1212610778l.7239l.1l@manu-laptop>
	<200806052047.30008.ajurik@quick.cz>
In-Reply-To: <200806052047.30008.ajurik@quick.cz> (from ajurik@quick.cz on
	Thu Jun  5 14:47:29 2008)
Message-Id: <1212695886l.9365l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : No lock on a particular transponder with TT S2-3200
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

Le 05.06.2008 14:47:29, Ales Jurik a =E9crit=A0:
> On Wednesday 04 of June 2008, manu wrote:
> > 	Hi all,
> > one more datapoint for the TT 3200 tuning problems. I solved all my
> > locking problems by add 4MHz to the reported frequencies (coming
> from
> > the stream tables); note that one of the transponders always locked
> > even without this correction (its freq is 11093MHz, the others =

> are :
> > 11555, 11635, 11675MHz), so as you see the others are much higher.
> > Now there is another transponder at 11495MHz but this one I cant
> lock
> > on it even with my correction. =

> =

> Hi,
> =

> I have a little more problems with TT S2-3200 under linux. At DVB-S
> exists =

> transponders to which is not possible to switch directly (when
> changing =

> satellite), it is necessary to tune first to another transponder at
> same =

> position (I'm using diseqc switch). At these transponders changing =

> the
> =

> frequency is not helpful.
> =

> At DVB-S2 transponders are some transponders at which is possible to
> get lock =

> without problems. Also at some transponders it is possible to get =

> lock
> when =

> changing frequency by 4-5MHz after some minutes (typically 2 min.).
> But there =

> exists some transponders where is practically impossible to get lock. =

> Interesting is that those problematic transponders were without
> problems =

> receivable some time ago. The change appeared when transponders were
> switched =

> from Thor2 to Thor5 (same frequency but only FEC changed from 2/3 to
> 3/4 and =

> pilot was switched off), also one transponder at HB 13.0E which was =

> receivable two months ago is not receivable any more (don't know if
> pilot was =

> switched off but other paremeters are the same).
> =


Well so this would point to a problem involving FEC. But is that a =

problem to get a lock? I mean FEC is just involved after a successful =

tuning, right? So even tuning is a problem IMHO and FEC might be =

another one.
I hope that someone else can elaborate/confirm or not.
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
