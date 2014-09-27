Return-path: <linux-media-owner@vger.kernel.org>
Received: from dougal.woof94.com ([125.63.57.136]:55095 "EHLO
	dougal.woof94.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaI0DdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 23:33:11 -0400
In-Reply-To: <54261AA6.10800@iki.fi>
References: <542406DE.10403@cloud.net.au> <5424627F.9010306@iki.fi> <54261797.7080509@cloud.net.au> <54261AA6.10800@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: problem with second tuner on Leadtek DTV dongle dual
From: Hamish Moffatt <hamish@cloud.net.au>
Date: Sat, 27 Sep 2014 13:32:54 +1000
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Message-ID: <b2c9454a-c6ba-4851-b940-b0ca34f714e5@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 27 September 2014 12:02:14 PM AEST, Antti Palosaari <crope@iki.fi> wrote:
>On 09/27/2014 04:49 AM, Hamish Moffatt wrote:
>> On 26/09/14 04:44, Antti Palosaari wrote:
>>> Moikka
>>> Performance issues are fixed recently (at least I hope so), but it
>>> will took some time in order to get fixes in stable. Unfortunately I
>>> don't have any IT9135 BX (ver 2 chip) dual device to test like
>yours...
>>>
>>> Could you install that kernel tree:
>>> http://git.linuxtv.org/cgit.cgi/media_tree.git/log/?h=devel-3.17-rc6
>>> and firmwares from there:
>>> http://palosaari.fi/linux/v4l-dvb/firmware/IT9135/ITE_3.25.0.0/
>>>
>>
>> OK I have
>> http://git.linuxtv.org/cgit.cgi/media_tree.git/log/?h=devel-3.17-rc6
>> running now (reporting itself as 3.17-rc5), with the 3.40.1.0
>firmware
>> from your site.
>>
>> Both tuners work for all stations, except that the first tuning
>attempt
>> on each tuner simply doesn't lock. Doesn't seem to matter what I tune
>to.
>
>:/ Sounds like a something is not initialized in a correct order. I 
>suspect it is it913x tuner driver. But without a hardware, I cannot do 
>much for it. So let it be.
>
>Good to hear that it works that better, even first tune will fail. It
>is 
>though annoying as you will need to close app and then try again. I 
>suspect it needs "power on - sleep - power on" in order to init all 
>properly.
>

Well it's easy enough to work around by running dvbtune or tzap with a timeout on boot or when the device is inserted. I've had tuners with such quirks before.

Still, 3.16.3 with the 3.39 firmware didn't show this. 3.16.3 with the 3.40 firmware was quite unpredictable though.

These dongles are pretty cheap here. Do you have DVB-T to test with?

Thanks
Hamish

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
