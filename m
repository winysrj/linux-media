Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <scha0273@planet.nl>) id 1JQpHy-0006ly-0O
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 20:35:02 +0100
Message-ID: <47B88C46.8020106@planet.nl>
Date: Sun, 17 Feb 2008 20:34:30 +0100
From: henk schaap <haschaap@planet.nl>
MIME-Version: 1.0
CC: linux-dvb@linuxtv.org
References: <47B6A9DB.501@planet.nl>
	<E1JQJvK-000BwB-00.goga777-bk-ru@f128.mail.ru>
In-Reply-To: <E1JQJvK-000BwB-00.goga777-bk-ru@f128.mail.ru>
Subject: Re: [linux-dvb] multiproto and tt3200: don't get a lock
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

Igor,

Thank you for pointing me in the good direction. I checked the szap.c 
from Manu again and noticed that I had to change the declarations of the 
include files frontend.h and lnb.h (I copied them from the 
multiproto-tree to the same directory as szap.c). It seems to be that 
_#include <frontend.h>_ has a different meaning than _#include 
"frontend.h"_ (I am not familiair with C).

This means for szap.c:
#include "frontend.h"
#include "version.h"
#include "lnb.h"
And for lnb.c:
#include "lnb.h"

This is it. After compiling szap works good and I get a lock for any 
channel!

Thanks!

Henk


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
