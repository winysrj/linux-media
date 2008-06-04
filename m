Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K3tVI-0001Tz-0i
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 15:58:16 +0200
Message-ID: <48469F71.1070904@iki.fi>
Date: Wed, 04 Jun 2008 16:58:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Sigmund Augdal <sigmund@snap.tv>
References: <1212585271.32385.41.camel@pascal>
In-Reply-To: <1212585271.32385.41.camel@pascal>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

Sigmund Augdal wrote:
> The following experimental patch adds support for the technotrend budget
> C-1501 dvb-c card. The parameters used to configure the tda10023 demod
> chip are largely determined experimentally, but works quite for me in my
> initial tests.

You finally found correct values :) I see that it uses same clock 
settings than Anysee. Also deltaf could be correct because I remember 
from my tests that it cannot set wrong otherwise it will not work at 
all. How did you find defltaf?

Your patch has at least coding style issues, please run make checkpatch 
fix errors and resend patch.

regards
Antti

> 
> Signed-Off-By: Sigmund Augdal <sigmund@snap.tv>
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
