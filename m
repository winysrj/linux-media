Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1Jepgd-00050j-JD
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 11:50:24 +0100
Received: from PCTL ([194.250.18.140]) (authenticated)
	by smtp01.msg.oleane.net (MTA) with ESMTP id m2RAo9HU003812
	for <linux-dvb@linuxtv.org>; Thu, 27 Mar 2008 11:50:10 +0100
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Thu, 27 Mar 2008 11:49:53 +0100
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAASuTAGpqJw0asMd7tD3VNFwEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Subject: [linux-dvb] Interpretation of FE_READ_BER
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

What is the interpretation of the value returned by ioctl FE_READ_BER?

Normally, a bit-error-rate is something like 10^-6 (typically not an
integer value).

There is no clue in the Linux DVB API doc. Google reports similar
questions but none with an answer. I have just seen one note suggesting
it could be a multiple of 10^-9. Looks good to me but since there is
no good definition of this parameter in the docs, I wonder if drivers
implement them in a consistent way.

With my Nova-T 500 (Fedora 8, kernel 2.6.24.3-12, recent v4l hg tree),
the reception is quite fine, FE_READ_SIGNAL_STRENGTH returns 40000 (60%),
but FE_READ_BER always returns 0. Does this mean "not even the slightest
error" (to good to be true), "not supported" (should return errno ENOSYS),
"driver bug"?

-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
