Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay3.mail.uk.clara.net ([80.168.70.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon.farnsworth@onelan.co.uk>) id 1K4HnQ-0005TF-JI
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 17:54:41 +0200
Message-ID: <48480C33.3060705@onelan.co.uk>
Date: Thu, 05 Jun 2008 16:54:27 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
MIME-Version: 1.0
To: Simon Kilvington <s.kilvington@eris.qinetiq.com>
References: <48480A2D.9010507@eris.qinetiq.com>
In-Reply-To: <48480A2D.9010507@eris.qinetiq.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] UK FreeView logical channel numbers
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

Simon Kilvington wrote:
> Hi,
> 
> 	does anyone know where the logical channel numbers are
> transmitted in FreeView? - ie BBC1 is 1, BBC News is 80, etc - I've been
> looking at the PAT and PMTs with dvbsnoop but can't see anything
> obvious.
> 

It's in the NIT, using a private descriptor - scan from dvb-apps 
(http://linuxtv.org/hg/dvb-apps/file/9311c900f746/util/scan/scan.c) 
knows about them, and they're fully specced in the DTG 'D-Book' (see 
http://dtg.org.uk/publications/books.html).
-- 
HTH,

Simon Farnsworth


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
