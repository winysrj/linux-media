Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f25.mail.ru ([194.67.57.151])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KXq3Q-0002hB-Aw
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 06:21:16 +0200
From: Goga777 <goga777@bk.ru>
To: ajurik@quick.cz
Mime-Version: 1.0
Date: Tue, 26 Aug 2008 08:20:42 +0400
In-Reply-To: <200808252156.52323.ajurik@quick.cz>
References: <200808252156.52323.ajurik@quick.cz>
Message-Id: <E1KXq2s-0007z3-00.goga777-bk-ru@f25.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?SFZSIDQwMDAgcmVjb21uZWRlZCBkcml2ZXIgYW5k?=
	=?koi8-r?b?IGZpcm13YXJlIGZvciBWRFIgMS43LjA=?=
Reply-To: Goga777 <goga777@bk.ru>
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

Hi


> I could confirm that this new version of drivers is running better (I have the 
> same problem as Marek and I use his hint with patched multiproto_plus drivers 

sorry, which hint do you mean ?

> to make HV-4000 under linux running) but not for all channels. 

it's strange - I have only repo from Igor without any patches and everything works well


>I couldn't get 
> lock for some dvb-s2 channels (ANIXE HD, Premiere HD) which is with patched 
> multiproto_plus possible without problem. 

I can see these channels without any problem on my vdr 170

sorry, do you use patched multiproto_plus or native repo from Igor ?

>Also switching seems to be sometimes 
> slower.
> 
> I've tested it with kernel 2.6.25-2 and with fw for cs24116 version 1.20.79.0 
> and version 1.23.86.1.

I have kernel 2.6.22, cx24116 FW version 1.23.86.1, the letaest repo from Igor, vdr 170
 
> Many thanks to Goga and Igor for their work.

many thanks to Igor :)

Goga



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
