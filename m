Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay2.mail.uk.clara.net ([80.168.70.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon.farnsworth@onelan.co.uk>) id 1K679z-0001xr-Nl
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 18:57:32 +0200
Message-ID: <484EB26A.20207@onelan.co.uk>
Date: Tue, 10 Jun 2008 17:57:14 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
MIME-Version: 1.0
To: Simon Kilvington <s.kilvington@eris.qinetiq.com>
References: <48480A2D.9010507@eris.qinetiq.com> <48480C33.3060705@onelan.co.uk>
	<484EA718.20807@eris.qinetiq.com>
In-Reply-To: <484EA718.20807@eris.qinetiq.com>
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

Simon Covington wrote:
> the reason I wanted to know was because when I did a scan with mythtv I
> had to give it each frequency by hand, then it only managed to find the
> channel numbers for the channels on one mux - though this may be because
> the nit on my transmitter seems to be split into two bits - one nit has
> the info for 5 muxs, the other nit has the info for the other mux
> 
The NIT is normally transmitted as two separate tables - one covers just 
the mux you are tuned to, while the other NIT covers all muxes in the 
network, apart from the one you're tuned to.
-- 
Simon Farnsworth


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
