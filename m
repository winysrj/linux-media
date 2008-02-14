Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mx1.ukfsn.org ([77.75.108.10] helo=mail.ukfsn.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mail@thedesignshop.biz>) id 1JPb3q-0007ga-Qm
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 11:11:22 +0100
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id 61129DEF30
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 10:12:10 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new,
	port 10024) with ESMTP id WRkx+u3K0LE8 for <linux-dvb@linuxtv.org>;
	Thu, 14 Feb 2008 10:06:54 +0000 (GMT)
Received: from [10.0.1.2] (unknown [87.127.119.158])
	by mail.ukfsn.org (Postfix) with ESMTP id 2EBCBDED7C
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 10:12:04 +0000 (GMT)
Mime-Version: 1.0 (Apple Message framework v753)
Message-Id: <456F8CC7-BB99-4833-B540-8D1396C0E8C3@thedesignshop.biz>
To: linux-dvb@linuxtv.org
From: General <mail@thedesignshop.biz>
Date: Thu, 14 Feb 2008 10:11:13 +0000
Subject: [linux-dvb] Nova-T-500 disconnect issues
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

Hi. I have been following the discussion regarding the mt2060 I2C  
read / write failed errors. I am running Ubuntu and get the same  
behaviour since I upgraded to the latest kernel (2.6.24.1) to resolve  
some wireless driver issues I was having. When I was running the  
standard Ubuntu kernel (2.6.22-14-generic) I never had the disconnect  
issues in 3 or 4 months of 24/7 usage. This was using the latest v4l- 
dvb sources as per the wiki.

Perhaps this would suggest that the error is not with the dib0700  
driver but elsewhere?

So my dilemma is do I have a constant wireless connection but a dvb  
driver that drops out or a constant dvb driver with a wireless  
connection that drops out?!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
