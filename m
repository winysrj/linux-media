Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:47320 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762089AbZC0ABD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 20:01:03 -0400
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
From: hermann pitton <hermann-pitton@arcor.de>
To: klaas de waal <klaas.de.waal@gmail.com>,
	Oliver Endriss <o.endriss@gmx.de>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org,
	erik_bies@hotmail.com
In-Reply-To: <7b41dd970903251353n46f55bbfg687c1cfa42c5b824@mail.gmail.com>
References: <7b41dd970903251353n46f55bbfg687c1cfa42c5b824@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 00:51:43 +0100
Message-Id: <1238111503.4783.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Klaas,

Am Mittwoch, den 25.03.2009, 21:53 +0100 schrieb klaas de waal:
> (2nd try, this should be now  in "plain text" instead of HTML)
> 
> Hi Hermann,
> 
> Thanks for your "howto" on making a proper patch.
> After a "make commit" in my local v4l-dvb tree, and filling in the
> template I got the following output.
> I confess I do not know if this has now ended up somewhere in
> linuxtv.org or that it is just local.
> However, here it is:

your patches are still local, but they are at least on the proper list
now. Without starting with [PATCH] in the subject Mauro's scripts to add
them to patchwork automatically likely will still not find them.

As said before, as long nobody has the documentation for that tuner and
knows better somehow, your attempt to improve it is valid in my eyes and
was usual practice in such cases previously.

It would of course be fine if Oliver and/or Michael could review it and
eventually give an ACK or NACK with some reasons.

I came to it, because you initially reported the problem erroneously on
the saa7134 driver, but I'm not sure how I can help further with it now,
except for eventually remaining checkpatch.pl stuff and such.

Cheers,
Hermann

> changeset:   11143:f10e05176a88
> tag:         tip
> user:        Klaas de Waal <klaas.de.waal@gmail.com>
> date:        Tue Mar 24 22:59:44 2009 +0100
> files:       linux/drivers/media/common/tuners/tda827x.c
> linux/drivers/media/dvb/ttpci/budget-ci.c
> description:
> Separate tuning table for DVB-C solves tuning problem at 388MHz.
> 
> From: Klaas de Waal <klaas.de.waal@gmail.com>
> 
> TechnoTrend C-1501 DVB-C card does not lock on 388MHz.
> I assume that existing frequency table is valid for DVB-T. This is suggested
> by the name of the table: tda827xa_dvbt.
> Added a table for DVB-C with the name tda827xa_dvbc.
> Added runtime selection of the DVB-C table when the tuner is type FE_QAM.
> This should leave the behaviour of this driver with with DVB_T tuners unchanged.
> This modification is in file tda827x.c
> 
> The tda827x.c gives the following warning message when debug=1 :
> 
> tda827x: tda827x_config not defined, cannot set LNA gain!
> 
> Solved this by adding a tda827x_config struct in budget-ci.c.
> 
> Priority: normal
> 
> Signed-off-by: Klaas de Waal <klaas.de.waal@gmail.com>
> 
> 
> I have attached the result of "hg diff > tda827x_dvb-c_tuning_table.patch.
> 
> Patch is based on the "hg clone" done 23 march.
> Tested again, now with Linux kernel 2.6.28.9.
> 
> Cheers,
> Klaas.

