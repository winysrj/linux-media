Return-path: <mchehab@gaivota>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lionteeth@cogweb.net>) id 1PJiEg-0002kH-Ss
	for linux-dvb@linuxtv.org; Sat, 20 Nov 2010 08:51:51 +0100
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1PJiEg-0007Qw-AM; Sat, 20 Nov 2010 08:51:50 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id oAK7pmnQ018662
	for <linux-dvb@linuxtv.org>; Fri, 19 Nov 2010 23:51:48 -0800
Received: from smtp1.sscnet.ucla.edu ([127.0.0.1])
	by localhost (smtp1.sscnet.ucla.edu [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ddRCGyPHZV0r for <linux-dvb@linuxtv.org>;
	Fri, 19 Nov 2010 23:51:38 -0800 (PST)
Received: from smtp5.sscnet.ucla.edu (smtp5.sscnet.ucla.edu [128.97.229.235])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id oAK7pYmo018650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Fri, 19 Nov 2010 23:51:34 -0800
Received: from weber.sscnet.ucla.edu (weber.sscnet.ucla.edu [128.97.42.3])
	by smtp5.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id oAK7pP69013093
	for <linux-dvb@linuxtv.org>; Fri, 19 Nov 2010 23:51:25 -0800
Received: from [128.97.244.133] (vpn-8061f485.host.ucla.edu [128.97.244.133])
	by weber.sscnet.ucla.edu (8.14.2/8.14.2) with ESMTP id oAK7pJmi005930
	for <linux-dvb@linuxtv.org>; Fri, 19 Nov 2010 23:51:19 -0800 (PST)
Message-ID: <4CE77DF3.8090604@cogweb.net>
Date: Fri, 19 Nov 2010 23:51:15 -0800
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dvbstream fails to tune QAM-256
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <linux-dvb@linuxtv.org>


I'm using Debian's dvbstream 0.6+cvs20090621-1 to capture video and 
closed captioning to file.

If I tune with azap, dvbstream works fine, but I can't get it to tune on 
its own.

In the Debian source code, I activated DVB_ATSC by adding -DDVB_ATSC to 
CFLAGS in the Makefile.

dvbstream -f 645000000 -qam 256 -v 49 a 52 -o > test.ts

gives me the error "Unknown FE type".

Suggestions? Is this a problem with an API that has changed since 
dvbstream's last release?

Cheers,
Dave


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
