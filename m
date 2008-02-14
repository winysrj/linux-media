Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@kaiser-linux.li>) id 1JPkq9-0001a6-1r
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 21:37:53 +0100
Received: from localhost (localhost.lie-comtel.li [127.0.0.1])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id 62B4C9FEC15
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 21:37:52 +0100 (GMT-1)
Received: from [192.168.0.15] (80-72-49-55.cmts.powersurf.li [80.72.49.55])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id 477C69FEC11
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 21:37:52 +0100 (GMT-1)
Message-ID: <47B4A69F.9020009@kaiser-linux.li>
Date: Thu, 14 Feb 2008 21:37:51 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: _LinuxTV-DVB - Mailinglist <linux-dvb@linuxtv.org>
Subject: [linux-dvb] [OT] request_firmware()
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello

I know this is the wrong list to ask, but you use this function (see subject) 
and I think somebody can answer my question.

Why does request_firmware need a device as parameter?
int request_firmware(const struct firmware **fw, const char *name,
		     struct device *device);

I thought request_firmware just loads the firmware in the struct firmware?

Thanks,

Thomas


-- 
http://www.kaiser-linux.li

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
