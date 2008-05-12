Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JvYiO-00044h-BP
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 16:09:23 +0200
Date: Mon, 12 May 2008 16:08:35 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Rogan Dawes <lists@dawes.za.net>
In-Reply-To: <48284D8B.4050909@dawes.za.net>
Message-ID: <Pine.LNX.4.64.0805121604170.11078@pub3.ifh.de>
References: <48281E7A.8010006@dawes.za.net>
	<Pine.LNX.4.64.0805121254410.11078@pub3.ifh.de>
	<48282843.6010906@dawes.za.net>
	<Pine.LNX.4.64.0805121418530.11078@pub3.ifh.de>
	<48283D17.3060303@dawes.za.net> <48284D8B.4050909@dawes.za.net>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T South Africa
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

Hi again,
On Mon, 12 May 2008, Rogan Dawes wrote:
> I guess this is related to a weak/corrupted signal, although the ber showing 
> up while running tzap seemed reasonable:

A reasonable BER is 0 and (if the demod-driver is supporting) UNC should 
be 0 as well.

BER is the bit-error-rate, not the bitrate.

> I guess I'll need to get a better DVB antenna.

Try to open the window or to put the antenna outside, rotate the antenna, 
check the cables and connector, while having femon running and check which 
position is the best.

Sometimes it helps,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
