Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1019.yellis.net ([213.246.41.159] helo=vds19s01.yellis.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1JzYrR-0005TE-F8
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 17:07:17 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds19s01.yellis.net (Postfix) with ESMTP id 8FF2A2FA896
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 17:07:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 7A8DF130022E
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 17:07:08 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7jLaAICrbQPA for <linux-dvb@linuxtv.org>;
	Fri, 23 May 2008 17:07:05 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id F0EE1130013B
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 17:07:04 +0200 (CEST)
Message-ID: <4836DD93.50805@anevia.com>
Date: Fri, 23 May 2008 17:06:59 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [HVR1300] issue with VLC
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

I post again cause I did not get any reply at my late mail : anybody 
encountering picture / sound issues with VLC after some time running 
(let's say half an hour) reading the MPEG PS output ?
I tried many different v4l-dvb tarballs, including latest repository, 
but I could not make it work more that 30 minutes (or 20, it depends).
Stopping VLC and restarting it "solves" this issue but I'm looking for 
someone who could confirm this behaviour, and then maybe fix this.
My VLC works fine , btw , with other MPEG PS or TS live streaming.

Cheers.
-- 
CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
