Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1JTZAJ-0002eM-BY
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 09:58:27 +0100
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Mon, 25 Feb 2008 09:58:08 +0100
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAnIT3wzzVLUSYmPE4pB04JwEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <47C1EEFB.7020600@googlemail.com>
Cc: 'Andrea' <mariofutire@googlemail.com>
Subject: [linux-dvb] RE :  Length of /dev/dvb/adapter0/dvr0's buffer.
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

> I'm trying to read from /dev/dvb/adapter0/dvr0.
> The problem is that the process reading sometimes is not fast enough and after a while I get errno 
> 75 when I try to read from it.
>
> On average the speed is ok, so it should work.
> There must be a buffer behind dvr0 that goes in error onece it is full.
>
> 1) how can I make it bigger?
> 2) how can I check how full it is?

You can set the *demux* buffer size, upstream from dvr, using ioctl DMX_SET_BUFFER_SIZE.
The default value is 8 kB. Using 1 MB, I can do full TS capture without any loss. 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
