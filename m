Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <y28xml@gmx.net>) id 1KALG2-0003gh-Fp
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 10:49:11 +0200
Message-ID: <485E11E4.1090400@gmx.net>
Date: Sun, 22 Jun 2008 10:48:36 +0200
From: =?ISO-8859-15?Q?Yves_G=F6lz?= <y28xml@gmx.net>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] CAM of Mantis 2033 still not working
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

Hi,

I had same problem with kernel 2.6.24-19 on mythbuntu 8.04.
So I tried the trick and removed the CAM, and the patch 0b04be0c088a 
from Mantis works. But I have still the problem when the CAM is insert.


Regards
Yves

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
