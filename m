Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:57126 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab1DGUCG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Apr 2011 16:02:06 -0400
Message-ID: <4D9E1838.30503@iki.fi>
Date: Thu, 07 Apr 2011 23:02:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: CXD2820 & PCTV nanoStick T2 290e bringup
References: <1298836156.2362.7.camel@ares>
In-Reply-To: <1298836156.2362.7.camel@ares>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Steve at all,
Here it is, feel free to test:
http://git.linuxtv.org/anttip/media_tree.git?a=shortlog;h=refs/heads/pctv_290e

Now I *need* help for adding proper DVB-T2 support for the API. I added 
fe_delivery_system_t SYS_DVBT2, but there is no app knowing that yet. 
Since there is also module param to set DVB-T2 frequencies.
For example here is DVB-T2 transmission on channels 570 MHz and 586 MHz. 
You can just type:
echo 570,586 > /sys/module/cxd2820r/parameters/dvbt2_freq
as root, or load driver module following way:
modprobe cxd2820r dvbt2_freq=570,586
for the same.

Also em28xx driver MFE needs review and comments, since I am not sure 
about its correctness.

Antti


On 02/27/2011 09:49 PM, Steve Kerrison wrote:
> Hello everyone,
>
> I've done some work on bringup of this device in Linux, and now have a
> stub for the CXD2820 demod that includes the capability to pass I2C
> commands through to the tuner that sits behind it.
>
> The focus was on bringup, not compatibility with linux-media or Linus'
> coding guidelines, but hopefully it's not so horrendous that it makes
> you want to cry. This isn't a formal patch submission, but anyone with
> an interest is welcome to read more and grab the patch here:
> http://stevekerrison.com/290e/index.html#20110227 taking heed of the
> warnings and advice where necessary :)
>
> Only I2C passthrough is supported - none of the other demodulator or
> frontend functions work, and it doesn't detach properly.
>
> I'd like to know what the best approach would be for me to allow others
> to contribute to this if they so wish?
>
> Many thanks,


-- 
http://palosaari.fi/
