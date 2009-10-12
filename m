Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd16712.kasserver.com ([85.13.137.159])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <vdr@helmutauer.de>) id 1MxRNR-0005rw-61
	for linux-dvb@linuxtv.org; Mon, 12 Oct 2009 22:20:17 +0200
Received: from [127.0.0.1] (p50817320.dip.t-dialin.net [80.129.115.32])
	by dd16712.kasserver.com (Postfix) with ESMTP id 0E032180CEA68
	for <linux-dvb@linuxtv.org>; Mon, 12 Oct 2009 22:20:18 +0200 (CEST)
Message-ID: <4AD38F87.6020306@helmutauer.de>
Date: Mon, 12 Oct 2009 22:20:23 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Status of v4l repositories / merging new one
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hello List

AFAIK there are different v4l repositories supporting differnet hardware, e.g v4l-dvb(missing
skystar HD), liplianin (missing knc1) etc.
To add another one, we have a repository supporting the pci-e dual dvb-s low pointer profile
mediapointer card :)
But for my distribution I'd like to have one repository, supporting all cards
Whats to do to get all these repositories merged ?
Are there any plans about doing that ?

-- 
Helmut Auer, helmut@helmutauer.de

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
