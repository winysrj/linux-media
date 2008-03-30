Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anssi.hannula@gmail.com>) id 1Jg6wh-0007ca-Bj
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 01:28:18 +0200
Message-ID: <47F021EB.6010104@gmail.com>
Date: Mon, 31 Mar 2008 02:27:39 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
MIME-Version: 1.0
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAASuTAGpqJw0asMd7tD3VNFwEAAAAA@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAASuTAGpqJw0asMd7tD3VNFwEAAAAA@tv-numeric.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Interpretation of FE_READ_BER
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

Thierry Lelegard wrote:
> Hi,

Hi! I'm not an expert in this matter, but it seems no one else is replying.

> What is the interpretation of the value returned by ioctl FE_READ_BER?

AFAIK the exact meaning of all the values is driver/device-specific.

> Normally, a bit-error-rate is something like 10^-6 (typically not an
> integer value).
> 
> There is no clue in the Linux DVB API doc. Google reports similar
> questions but none with an answer. I have just seen one note suggesting
> it could be a multiple of 10^-9. Looks good to me but since there is
> no good definition of this parameter in the docs, I wonder if drivers
> implement them in a consistent way.

I don't think so.

> With my Nova-T 500 (Fedora 8, kernel 2.6.24.3-12, recent v4l hg tree),
> the reception is quite fine, FE_READ_SIGNAL_STRENGTH returns 40000 (60%),
> but FE_READ_BER always returns 0. Does this mean "not even the slightest
> error" (to good to be true), "not supported" (should return errno ENOSYS),
> "driver bug"?

0 can very well mean there is no errors, it is not that uncommon (I've
seen it with my devices in good conditions).

-- 
Anssi Hannula

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
