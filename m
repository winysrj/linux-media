Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47316 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab1KNQeR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 11:34:17 -0500
Message-ID: <4EC14306.7010408@iki.fi>
Date: Mon, 14 Nov 2011 18:34:14 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/7] af9015 dual tuner and othe fixes from my builds.
References: <4ebe9767.8366b40a.1a27.4371@mx.google.com> <4EBE9AA6.8090500@iki.fi> <4EBEA5F3.1050103@iki.fi> <4EBF2320.2060408@iki.fi>
In-Reply-To: <4EBF2320.2060408@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/13/2011 03:53 AM, Antti Palosaari wrote:
> On 11/12/2011 06:59 PM, Antti Palosaari wrote:
> I fixed that I2C failing, simply blocking problematic demod callbacks
> that only other demod can access at once. Basically problem is that
> AF9015 FW don't like to get interrupted for I2C access in certain cases.
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9015

> I haven't looked stream corruptions and I will not even look, since
> those not happening much my hw. I think your fix is based the fact you
> forced PID-filter always on. Could you remove all the other changes you
> did and force it using dvb-usb orce_pid_filter_usage param to see if
> thats really the only only problem? And also testing using max packet
> sizes could be interesting to see.

I think I have now found the problem. It seems happen when you watch FE0 
and then do some tuning using other FE1. If you just watch both FEs same 
time it works rather nicely. That's why I haven't seen that earlier. 
Very good way to corruptions is to stream FE0 and then start tuning in 
loop through some channels, especially there is channels having no 
signal at all.

I just tested you patch series and result was bad. A lot of corruptions. 
I was using dual device having MXL5007T tuner.

As I found out how to reproduce errors I did some small test and find 
out problem seem to be I2C traffic from 2nd tuner and demod. When you do 
some tuning for 2nd FE there is a lot I2C traffic all the time, which I 
think overloads AF9015 and couses stream corruption. Disabling all 
statistics and returning all the time HAS_LOCK for fe0 and NO LOCK for 
FE without any I2C traffic seems to help a lot.

So what's the source of problematic I2C traffic
1) demod status/statistic reading (that have been always optimized by 
limiting queries using jiffies)
2) set_frontend()
3) set_params()

I have MXL5007T and MXL5005S. If you look sniffs from windows those 
tuner drivers are optimized I2C traffic something like "one go". Linux 
drivers generate huge amount of register access because they don't 
support writing multiple regs as one go. This leads very bad performance 
as a I2C I/O combined to fact I2C-gate open/close is bit field - 
changing one bit takes 2 USB messages. So every single tuner register 
change generates 2xmsg for gate open, 1xmsg for tuner reg write, 2xmsg 
for gate close = 5 messages, where is 4 msg wasted for only I2C gate. 
After all, it may generate something ~10-50 times more I/O than Windows 
driver.

* I think it is maybe good idea to implement multireg access like 
Windows to these tuner drivers first.
* cache gate-control register value inside driver
* program only demod register needed. eg. BW is not changed no need to 
program those registers. same for IF frequency. see cxd2820r I did that
* reduce satistics polling. maybe start timer that polls statistics once 
per 2 sec or so and return those from cache


regards
Antti

-- 
http://palosaari.fi/
