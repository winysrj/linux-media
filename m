Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:30274 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZAIS5D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jan 2009 13:57:03 -0500
Message-ID: <496795F5.6080309@iki.fi>
Date: Fri, 09 Jan 2009 20:22:45 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: Roberto Ragusa <mail@robertoragusa.it>, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] MC44S803 frontend (it works)
References: <200901091615.21641.lacsilva@gmail.com>	<4967783B.2060007@robertoragusa.it> <49678BD3.7070105@scram.de>
In-Reply-To: <49678BD3.7070105@scram.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jochen Friedrich wrote:
> Hi Roberto,
> 
>>> Thank you all for this good work. Any ideas as to when will these files hit 
>>> the mercurial repos at linuxtv.org?
>> That is not under my control.
>> I hope someone will route this driver into official trees.
> 
> As the tuner driver currently is only used with AF9015 frontends, I hope Antti will pick this one up.
> I can resubmit with a Signed-off-by if required.

Could you explain for changes af9015_i2c_xfer() done? Is it for case I2C 
READ coming from MC44S803 but tuner does not implement read at all? Is 
it really needed?

Maybe I can move MC44S803 and needed AF9015 changes to my devel tree at 
linuxtv.org... But that does not change problem that tuner is not still 
in v4l-dvb-master nor coming for Kernel before Manu will pull it.

>> I can also add that additional tests on VHF frequencies
>> have been successful too.
> 
> Cool.
> 
> Thanks,
> Jochen

regards
Antti
-- 
http://palosaari.fi/
