Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57362 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaETPK4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 11:10:56 -0400
Message-ID: <537B7073.6010003@iki.fi>
Date: Tue, 20 May 2014 18:10:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: kbuild@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [linuxtv-samsung:for-v3.16 45/81] drivers/media/dvb-frontends/si2168.c:47
 si2168_cmd_execute() warn: add some parenthesis here?
References: <20140505190256.GP4963@mwanda> <5367FA1E.9030800@iki.fi> <20140520120141.GE17724@mwanda>
In-Reply-To: <20140520120141.GE17724@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2014 03:01 PM, Dan Carpenter wrote:
> On Mon, May 05, 2014 at 11:52:46PM +0300, Antti Palosaari wrote:
>>> 845f3505 Antti Palosaari 2014-04-10  46
>>> 845f3505 Antti Palosaari 2014-04-10 @47  		if (!(cmd->args[0] >> 7) & 0x01) {
>>>
>>> This should be:						if (!((md->args[0] >> 7) & 0x01)) {
>>> Otherwise it is a precedence error where it does the negate before the
>>> bitwise AND.
>>
>> That was already on my TODO list as daily media build test sparse
>> warned it already http://hverkuil.home.xs4all.nl/logs/Monday.log
>>
>> I am waiting for media/master kernel upgrades from 3.15-rc1 as that
>> kernel will hang whole machine when em28xx driver used (em28xx
>> driver is USB bridge for those si2168 and si2157).
>>
>
> Wait, what?  This is a one liner.  I haven't understood the connection
> with 3.15-rc1?

Current media master, which contains that brand new si2168 driver, is 
3.15-rc1. That device is implemented as a)
em28xx driver - USB interface + remote controller
si2168 driver - DVB-T/T2/C digital TV demodulator
si2157 driver - RF tuner

For some reason em28xx freezes whole machine when that 3.15-rc1 kernel 
is used. It is not only that device, but all the other em28xx devices 
too what I have.

Even it is simple one liner, I tend to test all my patches before pull 
requesting to media master tree. Sure, I can do it using linus latest 
tree and then rebase to media master & pull request, but it is all extra 
work.

regards
Antti

-- 
http://palosaari.fi/
