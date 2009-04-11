Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.viadmin.org ([195.145.128.101])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henrik-dvb@prak.org>) id 1LslX5-0006NK-Oq
	for linux-dvb@linuxtv.org; Sun, 12 Apr 2009 00:18:40 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by www.viadmin.org (Postfix) with ESMTP id C6B9113415
	for <linux-dvb@linuxtv.org>; Sun, 12 Apr 2009 00:18:05 +0200 (CEST)
Received: from www.viadmin.org ([127.0.0.1])
	by localhost (www.viadmin.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WX+FWvobzdyD for <linux-dvb@linuxtv.org>;
	Sun, 12 Apr 2009 00:17:41 +0200 (CEST)
Date: Sun, 12 Apr 2009 00:17:40 +0200
From: "H. Langos" <henrik-dvb@prak.org>
To: linux-dvb@linuxtv.org
Message-ID: <20090411221740.GB12581@www.viadmin.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] DVB-T USB dib0700 device recomendations?
Reply-To: linux-media@vger.kernel.org
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

I've been trying to minimize energy consumption and noise on my vdr system.
One of the most important factors apart from a hardware pid filter seems to
be the usb buffer size. I've collected some data about that on my wiki user 
page: http://www.linuxtv.org/wiki/index.php/User:Hlangos

Greping through the sources I've seen that the dib0700 driver uses a HUGE
usb buffer of 39480 bytes. This looks very promising. But before running 
out in the street and buying the first dib0700 device I'd like to know if 
there are any devices that are 

- especially good (sensitive reception, fast switch time, sensible tuner 
  data (usable for comparing different antennas) and so on)

or 

- especially bad (invers of the above plus hardware bugs, annoyances and so
  on..)

any feedback is appreciated. 

cheers
-henrik

PS: A "full" remote (not one of those pesky credit card sized things that get 
eaten by the hoover) would be a plus. 


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
