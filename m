Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1JsvXt-0006CS-Ho
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 09:55:38 +0200
Received: from localhost (localhost [127.0.0.1])
	by ns218.ovh.net (Postfix) with ESMTP id 181AD82E8
	for <linux-dvb@linuxtv.org>; Mon,  5 May 2008 09:54:54 +0200 (CEST)
Received: from ns218.ovh.net ([127.0.0.1])
	by localhost (ns218.ovh.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K-A9KrFsVmKc for <linux-dvb@linuxtv.org>;
	Mon,  5 May 2008 09:54:53 +0200 (CEST)
Received: from [192.168.1.50] (droid.chaosmedia.org [82.225.228.49])
	by ns218.ovh.net (Postfix) with ESMTP id C35D382E4
	for <linux-dvb@linuxtv.org>; Mon,  5 May 2008 09:54:53 +0200 (CEST)
Message-ID: <481EBD4D.1070905@chaosmedia.org>
Date: Mon, 05 May 2008 09:54:53 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] libdvbapi multiproto patch ?
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

Hi,

i'm going to try to bring multiproto support to kaffeine for i'd really 
like to use my technotrend s2-3200 (dvb-s2) with it.

As far as i can tell kaffeine uses libdvbapi which is part of linuxtv 
dvb-apps repo.

So i'd like to know if there's already been any patch made to bring 
multiproto to libdvbapi ?

I don't know much about multiproto or v4l-dvb api, or dvb rfc, but i'll 
probably focus on both the wiki info  
http://www.linuxtv.org/wiki/index.php/Multiproto and a good app example 
using macros referenced also in the wiki which is getstream 
http://silicon-verl.de/home/flo/projects/streaming/

any comments, further docs, references or examples, are welcome.

thx

Marc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
