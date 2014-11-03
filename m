Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56026 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaKCNjx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 08:39:53 -0500
Message-ID: <545785A5.9000804@iki.fi>
Date: Mon, 03 Nov 2014 15:39:49 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>
CC: linux-media@vger.kernel.org, nibble.max@gmail.com
Subject: Re: [PATCH 2/4] dvbsky: added debug logging
References: <1413108191-32510-1-git-send-email-olli.salonen@iki.fi>	<1413108191-32510-2-git-send-email-olli.salonen@iki.fi> <20141103110445.318b50c4@recife.lan>
In-Reply-To: <20141103110445.318b50c4@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/03/2014 03:04 PM, Mauro Carvalho Chehab wrote:
> Em Sun, 12 Oct 2014 13:03:09 +0300
> Olli Salonen <olli.salonen@iki.fi> escreveu:
>
>> Added debug logging using dev_dgb.


>> @@ -396,6 +415,8 @@ static void dvbsky_exit(struct dvb_usb_device *d)
>>   	struct dvbsky_state *state = d_to_priv(d);
>>   	struct i2c_client *client;
>>
>> +	dev_dbg(&d->udev->dev, "\n");
>> +
>
> No need to add new debug macros that only prints the called functions,
> as you could get it too with Kernel tracing.

ftrace [1] is a bit heavy tool for module debugs like that. There is 
many different debugs for different use cases. When you add debugs to 
module those are usually used just to see how your module works and 
functions are called. Same is for V4L core debugs too; enable those and 
you will get tons of unneeded/useless information which makes totally 
hard to develop driver in question. When you add debugs to driver 
module, those are generally useful for cases where you want develop that 
certain driver module and not see zillion lines of unrelated debug data.

Also, I think that kind of debug log will not generate any binary code 
when debug options are not enabled by Kconfig, so it is not even reason 
for optimization.

[1] https://www.kernel.org/doc/Documentation/trace/ftrace.txt

regards
Antti

-- 
http://palosaari.fi/
