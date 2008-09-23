Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n7.bullet.ukl.yahoo.com ([217.146.182.187])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KiCwn-0005cT-UJ
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 20:49:20 +0200
Date: Tue, 23 Sep 2008 14:48:40 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <48D8A4FF.9010502@jcz.nl> <48D8B08B.6090602@konto.pl>
	<48D8BBED.3010109@jcz.nl>
In-Reply-To: <48D8BBED.3010109@jcz.nl> (from jaap@jcz.nl on Tue Sep 23
	05:50:37 2008)
Message-Id: <1222195720l.6287l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  TT Budget S2-3200 CI: failure with CAM module
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 23.09.2008 05:50:37, Jaap Crezee a =E9crit=A0:
> > Jaap Crezee wrote:
> >> Again, when I remove the CAM module, everything works fine (as for
> FTA =

> >> channels...). Tools like dvbdate, dvbtraffic and mplayer =

> >> /dev/dvb/adapter0/dvr0 work fine.
> =

> I just created a patch to add a budget-ci module param to the driver
> to disable the CI interface at module load time. =

> This way I can still use the card when the CAM module is inserted.
> Maybe it is good enough to integrated it with the current hg tree?
> =

> > I've got SkystarHD+CI Slot+Aston 2.18 and it works OK (for decoding
> some =

> > channels like HBO/MINIMINI I must wait very long time, but it =

> works)
> =

> I have waited long enough (more than 6 hours) and still no results.
> Anyone got it working with a TT S2-3200 and AstonCrypt CAM module?

Yes here (CanalSatellite in the French Caribbean Islands): AstonCrypt =

2.18 (IIRC), works great (I can even decode 2 channels =

simultaneously!).
I use Manu's multiproto treee but I dont think that there is something =

different for the CI/CAM stack in this driver.
I think I've read that some older AstonCrypt cards (version < 2.18) =

dont play well... =

Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
