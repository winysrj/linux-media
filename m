Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vds2011.yellis.net ([79.170.233.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1KgLwu-0000Xz-Vq
	for linux-dvb@linuxtv.org; Thu, 18 Sep 2008 18:01:46 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds2011.yellis.net (Postfix) with ESMTP id E776B2FA893
	for <linux-dvb@linuxtv.org>; Thu, 18 Sep 2008 18:01:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 81ACB1300199
	for <linux-dvb@linuxtv.org>; Thu, 18 Sep 2008 18:01:40 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UVqMHVBvoweQ for <linux-dvb@linuxtv.org>;
	Thu, 18 Sep 2008 18:01:32 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id 91B36130010F
	for <linux-dvb@linuxtv.org>; Thu, 18 Sep 2008 18:01:32 +0200 (CEST)
Message-ID: <48D27B52.2010704@anevia.com>
Date: Thu, 18 Sep 2008 18:01:22 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: [linux-dvb] hvr 1300 radio
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

Dear all,

has anyone got analog FM radio working with an Hauppauge HVR 1300 ?
If yes please tell me how ! I got only noise from /dev/dsp* ... :(
This is an issue I've had for some time now ...
I tried option radio=63 on cx88xx module but it did not change anything 
(except writing cx88[0]: TV tuner type 63, Radio tuner type 63 in dmesg 
instead of radio tuner type -1 ...)

Is radio support just not implemented ?


-- 
CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
