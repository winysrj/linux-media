Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n9a.bullet.ukl.yahoo.com ([217.146.183.157])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KMKyD-0005pT-T1
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 12:56:22 +0200
Date: Fri, 25 Jul 2008 06:52:44 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <3a665c760807240246x7bb3d442lac2b407dd138accf@mail.gmail.com>
	<200807241153.55596.Nicola.Sabbi@poste.it>
	<3a665c760807250212i1902e4fdud47da351262c140f@mail.gmail.com>
In-Reply-To: <3a665c760807250212i1902e4fdud47da351262c140f@mail.gmail.com>
	(from miloody@gmail.com on Fri Jul 25 05:12:53 2008)
Message-Id: <1216983164l.6000l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : question about definition of section in PSI of
 Transport stream
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

Le 25.07.2008 05:12:53, loody a =E9crit=A0:
> Hi:
> thanks for your explanation.
> BTW, I find all my Ts only have one section, section_number and
> last_section_number are both 0.
> =

> Would you please tell me where I can get multi-sections TS for
> tracing?
> =

> appreciate your help,
> miloody
> =

> =

> 2008/7/24 Nico Sabbi <Nicola.Sabbi@poste.it>:
> > On Thursday 24 July 2008 11:46:48 loody wrote:
> >> Dear all:
> >> I am reading iso13818-1 right now.
> >> But I cannot figure out what the section mean in PSI.
> >>
> >> In PAT, there is a N loop tell us how many programs in this TS and
> >> the corresponding pid of PMT.
> >> Is section equivalent to program?
> >
> > each item identifies a program and a pid
> >
> >> Suppose there is 10 loop in PAT, and there will be 10 sections,
> >> right?
> >
> > no, the section is only needed to split overly long PATs and / or
> PMTs
> > in smaller pieces
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >

Other tables like EIT are split over several sections (pid is 0x12 =

IIRC)
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
