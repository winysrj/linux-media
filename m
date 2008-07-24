Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KLxWN-00038R-82
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 11:54:03 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt3.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 4887B87100002B21 for linux-dvb@linuxtv.org;
	Thu, 24 Jul 2008 11:53:57 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Jul 2008 11:53:55 +0200
References: <3a665c760807240246x7bb3d442lac2b407dd138accf@mail.gmail.com>
In-Reply-To: <3a665c760807240246x7bb3d442lac2b407dd138accf@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807241153.55596.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] question about definition of section in PSI of
	Transport stream
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

On Thursday 24 July 2008 11:46:48 loody wrote:
> Dear all:
> I am reading iso13818-1 right now.
> But I cannot figure out what the section mean in PSI.
>
> In PAT, there is a N loop tell us how many programs in this TS and
> the corresponding pid of PMT.
> Is section equivalent to program?

each item identifies a program and a pid

> Suppose there is 10 loop in PAT, and there will be 10 sections,
> right?

no, the section is only needed to split overly long PATs and / or PMTs
in smaller pieces

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
