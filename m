Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1Kxn2T-0001gb-4P
	for linux-dvb@linuxtv.org; Wed, 05 Nov 2008 19:23:34 +0100
From: Darron Broad <darron@kewl.org>
To: Steve Thro <stevthro@hotmail.fr>
In-reply-to: <BLU126-W211E02BF45832661F2020BAF1F0@phx.gbl> 
References: <BLU126-W211E02BF45832661F2020BAF1F0@phx.gbl>
Date: Wed, 05 Nov 2008 18:23:29 +0000
Message-ID: <14964.1225909409@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] no lock on 3/4 with cx24116
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <BLU126-W211E02BF45832661F2020BAF1F0@phx.gbl>, Steve Thro wrote:
>
>Hi,

LO

>I'am using a TBS 8920 on 2.6.27.2 kernel with s2-liplianin-8c4f85bfc115 dvb=
> drivers.
>
>I could not lock any dvb-s2 channel  with FEC 3/4 on Astra 28.2E.
>
>I have an TT 3200 which lock fine on 3/4 using the same dvb driver.
>
>What information could I provide you to debug?

I don't know what a s2-liplianin-8c4f85bfc115 driver is but
if you apply this patch:
http://hg.kewl.org/v4l-dvb/raw-rev/8d6d8974b33d

then it may solve your problem?

bye

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
