Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:57885 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195AbZJVTN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 15:13:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by bamako.nerim.net (Postfix) with ESMTP id 1859B39DE9C
	for <linux-media@vger.kernel.org>; Thu, 22 Oct 2009 21:13:29 +0200 (CEST)
Received: from bamako.nerim.net ([127.0.0.1])
	by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kBZKfgB8jQJx for <linux-media@vger.kernel.org>;
	Thu, 22 Oct 2009 21:13:28 +0200 (CEST)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by bamako.nerim.net (Postfix) with ESMTP id 22F8939DE9A
	for <linux-media@vger.kernel.org>; Thu, 22 Oct 2009 21:13:28 +0200 (CEST)
Date: Thu, 22 Oct 2009 21:13:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: Details about DVB frontend API
Message-ID: <20091022211330.6e84c6e7@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I am looking for details regarding the DVB frontend API. I've read
linux-dvb-api-1.0.0.pdf, it roughly explains what the FE_READ_BER,
FE_READ_SNR, FE_READ_SIGNAL_STRENGTH and FE_READ_UNCORRECTED_BLOCKS
commands return, however it does not give any information about how the
returned values should be interpreted (or, seen from the other end, how
the frontend kernel drivers should encode these values.) If there
documentation available that would explain this?

For example, the signal strength. All I know so far is that this is a
16-bit value. But then what? Do greater values represent stronger
signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
returned value meaningful even when FE_HAS_SIGNAL is 0? When
FE_HAS_LOCK is 0? Is the scale linear, or do some values have
well-defined meanings, or is it arbitrary and each driver can have its
own scale? What are the typical use cases by user-space application for
this value?

That's the kind of details I'd like to know, not only for the signal
strength, but also for the SNR, BER and UB. Without this information,
it seems a little difficult to have consistent frontend drivers.

Thanks,
-- 
Jean Delvare
