Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JcVTL-0002c8-CD
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 01:51:04 +0100
Message-ID: <47E30629.7060706@gmail.com>
Date: Fri, 21 Mar 2008 04:49:45 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Gasiu <gasiu@konto.pl>
References: <mailman.385.1205960936.830.linux-dvb@linuxtv.org>
	<47E2FAEE.0@konto.pl>
In-Reply-To: <47E2FAEE.0@konto.pl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compiling patched szap and mythtv - problems
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

Gasiu wrote:
>  >Hi everybody!
>  >
>  >I want to run my SkystarHD with multiproto (on 64bit Ubuntu), and I try
>  >to compile patched szap and MythTV.
> 
>  >I have problems with this - I have updated headers from multiproto tree
>  >(I just copy .../multiproto-b5a34b6a209d/linux/include/ to
>  >/usr/include/) and I have error:
> 
>  > >cc -c szap.c
>  >szap.c: In function ?zap_to?:
>  >szap.c:368: error: ?struct dvbfe_info? has no member named ?delivery?
>  >szap.c:372: error: ?struct dvbfe_info? has no member named ?delivery?
>  >szap.c:376: error: ?struct dvbfe_info? has no member named ?delivery?
>  >szap.c:401: error: ?struct dvbfe_info? has no member named ?delivery?
>  >szap.c:412: error: ?struct dvbfe_info? has no member named ?delivery?
> 
>  >how can i fix it? (I think, that I need some *.h file - but what file?
>  >where find it?
> 
> "Make" works with multiproto-ecb96c96a69e...
> 

Pull dvb-apps the patched szap exists in dvb-apps dvb-apps/test/szap2

You need to updates the headers too.. the cleaned headers can be found
in dvb-apps/include/*

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
