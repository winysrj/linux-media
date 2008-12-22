Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <udo_richter@gmx.de>) id 1LEnjN-00082n-5a
	for linux-dvb@linuxtv.org; Mon, 22 Dec 2008 17:34:10 +0100
Message-ID: <494FC15C.6020400@gmx.de>
Date: Mon, 22 Dec 2008 17:33:32 +0100
From: Udo Richter <udo_richter@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
	<492DC5F5.3060501@gmx.de>
In-Reply-To: <492DC5F5.3060501@gmx.de>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

On 26.11.2008 22:56, Udo Richter wrote:
> What does a DVB app need to know? A DVB app probably just needs to know
> "What devices are capable of tuning to channel XYZ?". The API could
> answer this the same way as it would tune to channel XYZ, just without
> actually doing it. Try-before-you-buy.

After some insights to S2API interface, this looks even better to me:

properties.num = 1;
properties.props[0].cmd = DTV_DELIVERY_SYSTEM;
properties.props[0].u.data = SYS_DVBS2;
if (ioctl(d, FE_CAP_SET_PROPERTY, &properties) >= 0) {
     // has S2 capability
}

A generic frontend test function that delivers the necessary S2 
capability information, and many other capabilities too. And there are a 
lot more delivery systems that seem to be hard to detect, so a query 
function 'can do SYS_XXXX' seems necessary anyway.


Cheers,

Udo

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
