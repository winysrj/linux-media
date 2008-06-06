Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.movial.fi ([62.236.91.34])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dennis.noordsij@movial.fi>) id 1K4dQH-0004le-Fe
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 17:00:10 +0200
Message-ID: <484950D4.7050600@movial.fi>
Date: Fri, 06 Jun 2008 16:59:32 +0200
From: Dennis Noordsij <dennis.noordsij@movial.fi>
MIME-Version: 1.0
To: Nicolas Christener <lists@0x17.ch>
References: <1212736555.4264.12.camel@oipunk.loozer.local>	
	<4849016A.8050607@movial.fi>
	<1212763110.14191.12.camel@oipunk.loozer.local>
In-Reply-To: <1212763110.14191.12.camel@oipunk.loozer.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy Piranha
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


> thank you very much four your explanation. This is what I get:

> Unfortunately I do not get a device within /dev
> Am I doing something wrong? Or is there just something missing in my
> installation?

Ah, yes. Sorry forgot to mention one part. As you can tell from the log,
the default mode is DVB-H.

use:    modprobe sms1xxx default_mode=0

or change the default_mode variable in the file smscoreapi.c and rebuild
the driver.

Dennis




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
