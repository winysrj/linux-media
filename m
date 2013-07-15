Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54137 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418Ab3GOXaR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 19:30:17 -0400
Message-ID: <51E485DE.2000309@iki.fi>
Date: Tue, 16 Jul 2013 02:29:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Austin Spreadbury <austinspreadbury@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Problems tuning 704J dual DVB-T tuner
References: <CABF_skgNf7mPNGYZnvR0SuxyifdXmWtX2sjR2H0OjXKdO-4oRA@mail.gmail.com> <CABF_skikbVQuwtZODpvb+E2EvzXutLos5sU0sDXaUQtdFVg2Pg@mail.gmail.com>
In-Reply-To: <CABF_skikbVQuwtZODpvb+E2EvzXutLos5sU0sDXaUQtdFVg2Pg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Austin

It is not very recent driver, instead one of the oldest I have written. 
I rewrote af9013 demod maybe 2 years back in order to minimize I/O.

Have you disabled EIT scanning?

AF9015 dual device, especially the one with mxl5005s like that, is quite 
easy to get in state it loses ability to gain lock. Just start making 
repeatedly tuning attempts using both tuners and it will stop gaining 
lock after a while. MythTV does it all the time when there is EIT 
scanning activated.

The root of cause is likely AF9015 firmware. There is still few things 
which could be done to improve situation:
1) Serialize all the I/O traffic as much as possible
2) Optimize mxl5005s to generate less traffic. Current mxl5005s Linux 
driver writes all registers one by one for each tuning. I don't remember 
counts anymore, but it makes af9013 I/O optimization I did quite 
useless... Look the Windows sniffs, it is only about 10% of I/0
3) Add some logic to AF9015 I2C adapter to block excessive I/O from "bad 
behaving" app. Lets say measure I2C I/O during one minute and if it 
exceeds some threshold start returning error code to app.
4) Hack & fix the firmware. That is surely the best alternative, but it 
is also the most hardest as disassembling and understanding firmware is 
not very easy task.

X) I am not going to fix any of those. Just use only first tuner.

regards
Antti



On 07/10/2013 12:23 AM, Austin Spreadbury wrote:
> Dear List,
>
> I wonder if anyone can help me.
>
> I have a problem with the AzureWave 704J dual tuner that has developed
> recently.  I am using it with Mythbuntu 12.04.1 LTS, at the latest
> patch level, but it is persistently failing to record.  It can be made
> to work for a single recording, or maybe two, by running the DVB scan
> tool on both
> adapters corresponding to the tuner - the first scan on adapter 0
> fails, subsequent ones on 0 and 1 succeed.
>
> "uname -a" on my system produces this:  Linux mythmk2 3.2.0-43-generic
> #68-Ubuntu SMP Wed May 15 03:33:33 UTC 2013 x86_64 x86_64 x86_64
> GNU/Linux
>
> It's not mythtv that has the problem - zap fails too, the first time,
> but subsequently succeeds.  The attached files show debug logs from
> the af9015 driver
> - 1.txt is a failed zap to a channel on adapter 0
> - 2.txt is a successful zap on adapter 1
> - 3.txt is a successful zap on adapter 0.
> They were done in that order.
>
> Any ideas?
>
> Thanks,
> Austin.
>


-- 
http://palosaari.fi/
