Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vds2011.yellis.net ([79.170.233.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1KdijT-0002yR-AC
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 11:45:00 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds2011.yellis.net (Postfix) with ESMTP id 4CC9D2FA87B
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 11:44:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 2269F1300178
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 11:44:54 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5C1y3SX-mL9P for <linux-dvb@linuxtv.org>;
	Thu, 11 Sep 2008 11:44:48 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id 5427B130016C
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 11:44:48 +0200 (CEST)
Message-ID: <48C8E890.1030704@anevia.com>
Date: Thu, 11 Sep 2008 11:44:48 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: [linux-dvb] tarball retrieval
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

dear all
I tried this :
http://linuxtv.org/hg/v4l-dvb/archive/db80ce914b61.tar.bz2

to retrieve a certain revision that I'd like to try  but I got a 
"CompressionError" message, problem in python scrypt sthing ...

btw the tar.gz version is working

I'm trying to understand why I could tune my hvr 1300 with an old 
snapshot of summer 2007 and why I can't with recent v4l-dvb snapshots 
... (i.e now I got analog noise, as if the tuner wasn't tuned, but I 
don't change anything to my code, I only use a different v4l-dvb 
snapshot ... I'll let you know)
-- 
CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
