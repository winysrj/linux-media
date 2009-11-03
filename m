Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx38.mail.ru ([94.100.176.52]:56074 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbZKCMil (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2009 07:38:41 -0500
Date: Tue, 3 Nov 2009 15:43:17 +0300
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Struggling with Astra 2D (Freesat) / Happauage
 Nova-HD-S2
Message-ID: <20091103154317.74e56bd5@bk.ru>
In-Reply-To: <hcnsfa$v70$1@ger.gmane.org>
References: <hcnd9s$c1f$1@ger.gmane.org>
	<20091102231735.63fd30c4@bk.ru>
	<hcnsfa$v70$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I forgot to mention that you should use the transponders lists - ini file (for scan-s2) and xml file (for dvb2010) from
here

http://www.vdr-settings.com/download/channels/CLyngsatSP.tar.bz2


Goga



> > you have to use scan-s2
> > http://mercurial.intuxication.org/hg/scan-s2
> 
> Hi, and thanks for your quick reply.
> 
> I tried it but no better:
> <snip>
> initial transponder DVB-S  12692000 V 19532000 1/2 AUTO AUTO
> initial transponder DVB-S2 12692000 V 19532000 1/2 AUTO AUTO
> ----------------------------------> Using DVB-S
> >>> tune to: 11720:hC34S0:S0.0W:29500:
> DVB-S IF freq is 1120000
> WARNING: >>> tuning failed!!!
> >>> tune to: 11720:hC34S0:S0.0W:29500: (tuning failed)
> 
> and the channels.conf was no better than before - it didn't include *one* BBC
> channel, for example.
> 
> >
> > or
> >
> > dvb2010 scan
> > http://hg.kewl.org/dvb2010/
> 
> Once I got it working, same:
> Astra 2A/2B/2D/Eurobird 1 (28.2E) 10714 H DVB-S QPSK 22000 5/6 ONID:0 TID:0
> AGC:0% SNR:0% 
>     Can't tune
> 
> Astra 2A/2B/2D/Eurobird 1 (28.2E) 10729 V DVB-S QPSK 22000 5/6 ONID:0 TID:0
> AGC:0% SNR:0% 
>     Can't tune
