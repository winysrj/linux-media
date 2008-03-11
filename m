Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from difo.com ([217.147.177.146] helo=thin.difo.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ivor@ivor.org>) id 1JZ2KF-0008Ka-Sr
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 12:07:20 +0100
Received: from myth.ivor.org (difo.gotadsl.co.uk [213.208.101.41])
	by thin.difo.com (8.13.8/8.13.6) with ESMTP id m2BB78B5001516
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 11:07:08 GMT
Date: Tue, 11 Mar 2008 11:07:07 +0000
From: ivor@ivor.org
To: linux-dvb@linuxtv.org
Message-ID: <20080311110707.GA15085@mythbackend.home.ivor.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Nova-T 500 issues - losing one tuner
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

Not sure if this helps or adds that much to the discussion... (I think this was concluded before)
But I finally switched back to kernel 2.6.22.19 on March 5th (with current v4l-dvb code) and haven't had any problems with the Nova-t 500 since. Running mythtv with EIT scanning enabled.

Looking in the kernel log I see a single mt2060 read failed message on March 6th and 9th and a single mt2060 write failed on March 8th. These events didn't cause any problems or cause the tuner or mythtv to fail though.
 
Ivor.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
