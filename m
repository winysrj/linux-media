Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rouge.crans.org ([138.231.136.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <braice@braice.net>) id 1KUlyT-000215-HF
	for linux-dvb@linuxtv.org; Sun, 17 Aug 2008 19:23:30 +0200
Received: from localhost (localhost.crans.org [127.0.0.1])
	by rouge.crans.org (Postfix) with ESMTP id E9BE4807D
	for <linux-dvb@linuxtv.org>; Sun, 17 Aug 2008 19:23:25 +0200 (CEST)
Received: from rouge.crans.org ([10.231.136.3])
	by localhost (rouge.crans.org [10.231.136.3]) (amavisd-new, port 10024)
	with LMTP id sbNNi1QngiGb for <linux-dvb@linuxtv.org>;
	Sun, 17 Aug 2008 19:23:25 +0200 (CEST)
Received: from [192.168.1.123] (166.196.206-77.rev.gaoland.net
	[77.206.196.166])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rouge.crans.org (Postfix) with ESMTP id 368548074
	for <linux-dvb@linuxtv.org>; Sun, 17 Aug 2008 19:23:24 +0200 (CEST)
Message-ID: <48A85E8A.2090708@braice.net>
Date: Sun, 17 Aug 2008 19:23:22 +0200
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Mumudvb 1.5.0 is out
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

Hello

Mumudvb is a program that can redistribute streams from DVB on a network
using multicasting. It is able to multicast a whole DVB transponder by
assigning each channel to a different multicast IP.

The 1.5.0 gives two new important features :

 * Support for scrambled channels via a CAM
 * Support for autoconfiguration : mumudvb is now able to parse the ts
stream to find information about the channels and stream them.

Download :
You can download mumudvb 1.5.0 at :
http://gitweb.braice.net/gitweb?p=mumudvb.git;a=snapshot;h=1.5.0

Or using mumudvb web site : http://mumudvb.braice.net/


Testers are needed and every remarks are welcome.


-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
