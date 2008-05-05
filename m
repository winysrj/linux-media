Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1JsyoJ-0004XP-CG
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 13:24:51 +0200
Received: from localhost (localhost [127.0.0.1])
	by ns218.ovh.net (Postfix) with ESMTP id 6F36C82E4
	for <linux-dvb@linuxtv.org>; Mon,  5 May 2008 13:24:13 +0200 (CEST)
Received: from ns218.ovh.net ([127.0.0.1])
	by localhost (ns218.ovh.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TAyCya6LW+pT for <linux-dvb@linuxtv.org>;
	Mon,  5 May 2008 13:24:13 +0200 (CEST)
Received: from [192.168.1.50] (droid.chaosmedia.org [82.225.228.49])
	by ns218.ovh.net (Postfix) with ESMTP id 3AC557D8F
	for <linux-dvb@linuxtv.org>; Mon,  5 May 2008 13:24:13 +0200 (CEST)
Message-ID: <481EEE5C.1050009@chaosmedia.org>
Date: Mon, 05 May 2008 13:24:12 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <481EBD4D.1070905@chaosmedia.org>
	<E1Jsvjz-000OP1-00.goga777-bk-ru@f190.mail.ru>
In-Reply-To: <E1Jsvjz-000OP1-00.goga777-bk-ru@f190.mail.ru>
Subject: Re: [linux-dvb] libdvbapi multiproto patch ?
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



Igor wrote:
>
> you can see the new multiproto API in http://jusst.de/hg/multiproto/file/b5a34b6a209d/linux/include/linux/dvb/frontend.h
> You can compare it (diff) with existing frontend.h from dvb-v4l
>   
humm yeah but it seems that multiproto frontend.h just takes the whole 
regular frontend, for backward compatibility i guess, and puts its own 
declarations for the same values and its new ones at the bottom.

Not sure i need to go over it though if i can hide function calls from 
the libdvbapi using macros as it was done in other examples.

i'll probably need to update the api with missing dvb-s2 declarations, 
as the api's supposed to act as a layer between the driver and the 
application, and then update the api to access them or do it in the 
application, i don't really know..

Marc



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
