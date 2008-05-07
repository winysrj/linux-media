Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1Jthrc-0007gc-7N
	for linux-dvb@linuxtv.org; Wed, 07 May 2008 13:31:35 +0200
Received: from localhost (localhost [127.0.0.1])
	by ns218.ovh.net (Postfix) with ESMTP id 93BA982B3
	for <linux-dvb@linuxtv.org>; Wed,  7 May 2008 13:00:24 +0200 (CEST)
Received: from ns218.ovh.net ([127.0.0.1])
	by localhost (ns218.ovh.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QPc9E1OcNugr for <linux-dvb@linuxtv.org>;
	Wed,  7 May 2008 13:00:24 +0200 (CEST)
Received: from [192.168.1.50] (droid.chaosmedia.org [82.225.228.49])
	by ns218.ovh.net (Postfix) with ESMTP id 5D69C7E74
	for <linux-dvb@linuxtv.org>; Wed,  7 May 2008 13:00:24 +0200 (CEST)
Message-ID: <48218BC7.2060606@chaosmedia.org>
Date: Wed, 07 May 2008 13:00:23 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] multiproto dev question
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

hi,

doing a multiproto kaffeine patch, i'd like to know if there a way to 
match the regular api's dvb_frontend_info.caps (frontend features info) ?

For example in kaffeine code we check for FE_CAN_INVERSION_AUTO and then 
decide if we can set INVERSION_AUTO or not.

In all multiproto codes i've seen so far inversion is always set to 
DVBFE_INVERSION_AUTO skipping any frontend features check..

Is it common use to always set those values to AUTO (same thing with 
FEC) considering nowdays hadware ? or is it something missing in 
multiproto that we should keep aside for the moment ?

any comment's welcome,

Marc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
