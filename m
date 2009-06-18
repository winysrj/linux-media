Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.179])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stecksoft@gmail.com>) id 1MHGKP-0008RR-UG
	for linux-dvb@linuxtv.org; Thu, 18 Jun 2009 14:02:51 +0200
Received: by wa-out-1112.google.com with SMTP id m28so205972wag.1
	for <linux-dvb@linuxtv.org>; Thu, 18 Jun 2009 05:02:44 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Jun 2009 22:02:44 +1000
Message-ID: <35d822270906180502m33cf5ebbt342193539061f8ca@mail.gmail.com>
From: "Paul A. Steckler" <stecksoft@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] No scan results with Kaiser Baas and Kaffeine
Reply-To: linux-media@vger.kernel.org, steck@stecksoft.com
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

I have a Kaiser Baas DVB-T device, which uses the DIB0700 firmware.
I scan see via dmesg that the firmware loads successfully.

Using Kaffeine (or w_scan or mplayer or MeTV), I get no scan results.
Those programs all recognize that I have the DVB-T device installed.

Using Windows, I can see about 20 digital channels.

Is there some other module that needs to be installed?  Anything else
that might be going wrong?

-- Paul
-- 
Paul Steckler
steck@stecksoft.com

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
