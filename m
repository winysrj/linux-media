Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51315 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab1HNXgt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 19:36:49 -0400
Message-ID: <4E485C0C.8040600@iki.fi>
Date: Mon, 15 Aug 2011 02:36:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV 290e - assorted problems
References: <1313364050.41593.YahooMailClassic@web121710.mail.ne1.yahoo.com>
In-Reply-To: <1313364050.41593.YahooMailClassic@web121710.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2011 02:20 AM, Chris Rankin wrote:
> I've been experimenting with my new PCTV 290e DVB-T2 device this weekend, and have a couple of observations. For example, the device sometimes has trouble initialising itself:

> INFO: task khubd:1100 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> khubd           D 0000000000000000     0  1100      2 0x00000000
>  ffff8801a694e930 0000000000000046 ffff8801a691ffd8 ffffffff8162b020
>  0000000000010280 ffff8801a691ffd8 0000000000004000 0000000000010280
>  ffff8801a691ffd8 ffff8801a694e930 0000000000010280 ffff8801a691e000
> Call Trace:
>  [<ffffffff8128580e>] ? apic_timer_interrupt+0xe/0x20
>  [<ffffffff8113ffff>] ? memscan+0x3/0x18
>  [<ffffffff8128354e>] ? __mutex_lock_slowpath+0x15c/0x295
>  [<ffffffff81283690>] ? mutex_lock+0x9/0x18
>  [<ffffffffa06af671>] ? dvb_init+0x99/0xcc8 [em28xx_dvb]
>  [<ffffffffa067d459>] ? em28xx_init_extension+0x35/0x53 [em28xx]
>  [<ffffffffa067b938>] ? em28xx_usb_probe+0x827/0x8df [em28xx]

I think it crashes before it even goes to PCTV 290e specific part. I
suspect it is bug somewhere in em28xx driver. I am not much familiar
with em28xx driver. Does someone else see where it crashes?

> Tuning the adapter into the HD MUX is also proving to be more difficult that I anticipated. Successful attempts are so rare that I am now forced to assume that I was merely lucky.
> 
> The following parameters *should* be enough, but clearly aren't in practice:
> 
> T 554000000 8MHz 2/3 AUTO QAM256 AUTO AUTO AUTO

That is DVB-T2 since QAM256 I suspect. Actually everything else but
frequency and bandwidth are needed, all others are detected automatically.
T 554000000 8MHz + auto auto auto etc.
is enough.

I have 570 MHz DVB-T2 live here working fine. It is only 2 UHF channels
(16MHz) more. Have you tried it on Windows?

regards
Antti
-- 
http://palosaari.fi/
