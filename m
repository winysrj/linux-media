Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout1.informatik.tu-muenchen.de ([131.159.0.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <acher@acher.org>) id 1KmBxr-0002wn-Ue
	for linux-dvb@linuxtv.org; Sat, 04 Oct 2008 20:34:52 +0200
Received: from braindead1.acher.org (unknown [77.20.156.68])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in.tum.de (Postfix) with ESMTP id 5F0067C96
	for <linux-dvb@linuxtv.org>; Sat,  4 Oct 2008 20:34:48 +0200 (CEST)
Date: Sat, 4 Oct 2008 20:34:43 +0200
From: Georg Acher <acher@in.tum.de>
To: linux-dvb@linuxtv.org
Message-ID: <20081004183442.GM28168@braindead1.acher>
References: <20081004204740.571e84d9@bk.ru>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081004204740.571e84d9@bk.ru>
Subject: Re: [linux-dvb] cx24116 & BER for dvb-s2
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

On Sat, Oct 04, 2008 at 08:47:40PM +0400, Goga777 wrote:
> 	Hi
> 
> my old questions :)
> 
> Is it possible to implement the BER's support in cx24116 for dvb-s2 ?

The data sheet only mentions the registers c6-c9 for that purpose
"Reed-Solomon or BCH Corrected Bit Error Count (NBC, DVB-S, or DTV Legacy)".
There is a possibility to increase the integration window, but the contents
are still mostly 0 in S2-modes, even when UNC is !=0. Unfortunately, the
data sheet and the sample code also are not very clear or consistent at
dealing with the BER counter...

-- 
         Georg Acher, acher@in.tum.de         
         http://www.lrr.in.tum.de/~acher
         "Oh no, not again !" The bowl of petunias          

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
