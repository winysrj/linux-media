Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47003 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab1KXXLz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 18:11:55 -0500
Message-ID: <4ECECF37.2010202@iki.fi>
Date: Fri, 25 Nov 2011 01:11:51 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [GIT PULL FOR 3.2] misc small changes, mostly get/set IF related
References: <4EC016B9.1080306@iki.fi> <4EC01892.3090307@iki.fi> <4ECEA1E9.2000107@redhat.com>
In-Reply-To: <4ECEA1E9.2000107@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2011 09:58 PM, Mauro Carvalho Chehab wrote:
> Em 13-11-2011 17:20, Antti Palosaari escreveu:
>> Mauro,
>> and these too for 3.3. Sorry about mistakes.
>
> In fact, those 3 patches seemed to be good for 3.2:
>
> 576b849 [media] mxl5007t: fix reg read
> d7d89dc [media] tda18218: fix 6 MHz default IF frequency
> ff83bd8 [media] af9015: limit I2C access to keep FW happy
>
> So, I've backported d7d89dc to 3.2, and applied there. the others,
> I've added for 3.3.

You could put mxl5007t and tda18218. But as I changed tda18218 to 
support .get_if_frequency() just before that fix and it touches same 
code lines, it will not apply unless you do some hand editing or apply 
tda18218 get_if_frequency() patch too.

DO *NOT* push af9015 I2C patch to the 3.2. I see there could be 
potential problems if there is heavy demodulator I2C traffic since it 
forces to wait some I2C related tasks. I suspect that could lead bad 
situation when there is more traffic we can handle due to I2C access 
waiting coming from patch.

I have optimized af9013 I2C load, reduced it rather much switching 
multibyte I2C where possible and running statistic polls using timers in 
backround. Now it returns all statistics from cache and not make any 
statistics queries directly when userspace app is asking.

After my af9013 optimizations are ready those could be put to master, 
which will happen likely 3.3 schedule. It is absolutely too risky put 
that single patch to 3.2.


regards
Antti

-- 
http://palosaari.fi/
