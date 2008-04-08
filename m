Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JjMIW-0003cC-90
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 00:28:19 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Wed, 9 Apr 2008 00:22:40 +0200
References: <200803292240.25719.janne-dvb@grunau.be>
	<200804080213.26671.linuxdreas@launchnet.com>
	<37219a840804080818x729fd503ka3ba048c46169bcb@mail.gmail.com>
In-Reply-To: <37219a840804080818x729fd503ka3ba048c46169bcb@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804090022.40805@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second try
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Michael Krufky wrote:
> On Tue, Apr 8, 2008 at 5:13 AM, Andreas <linuxdreas@launchnet.com> wrote:
> > Am Dienstag, 08. April 2008 01:30:04 schrieb Janne Grunau:
> >  > ping.
> >
> >  pong
> >
> >
> >  > Any interest in this change? Anything speaking against merging this
> >  > except the potential duplication of udev functinality?
> >
> >  Janne, I have no clue at all how a udev rule can be written that reflects
> >  the structure of adapter[n]/frontend[n]. And if Google is any indicator,
> >  this is either not possible or it is a lost art. Speaking as a user of
> >  mythtv & subsequently the linux dvb drivers, I would like to see this patch
> >  integrated rather sooner than later.
> >
> >  Thanks for creating the patch!
> 
> I would really like to see this patch get merged.
> 
> If nobody has an issue with this, I plan to push this into a mercurial
> tree at the end of the week and request that it be merged into the
> master branch.

Correct me if I'm wrong, but afaik the option should be named
'adapter_no', not 'adapter_nr'.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
