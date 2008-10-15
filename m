Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1KqBxh-0003e1-Ni
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 21:23:14 +0200
Message-ID: <48F6431D.6070503@linuxtv.org>
Date: Wed, 15 Oct 2008 21:23:09 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Christophe Thommeret <hftom@free.fr>
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>	<48F42D5C.7090908@linuxtv.org>
	<48F4B366.7050508@linuxtv.org> <200810151844.36276.hftom@free.fr>
In-Reply-To: <200810151844.36276.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multi-frontend patch merge (TESTERS FEEDBACK) was:
 Re: [PATCH] S2API: add multifrontend
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

Christophe Thommeret wrote:
> I think that the actual way of populating multiple adpaters is to make these 
> devices working with current apps without any modifications.

For sure.

> On the other hand, since only dreambox drivers seem to use multiple frontends 
> on single adapter, maybe this actual (and bad, i agree) way should be kept 
> and multiple frontends on single adapter reserved for exclusive frontends  
> until the api provide such properties query, so applications can assume these 
> frontends to be exclusive.

Actually, the way it is implemented on the Dreambox is not that bad, because
there is at least one demux available for each frontend and you can choose
which frontend to connect to which demux(es), to use one demux for live tv,
and other ones for PIP or recording. But that doesn't really match PC
peripherials.

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
