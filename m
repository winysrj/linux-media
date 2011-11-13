Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42404 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1KMBxj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 20:53:39 -0500
Message-ID: <4EBF2320.2060408@iki.fi>
Date: Sun, 13 Nov 2011 03:53:36 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/7] af9015 dual tuner and othe fixes from my builds.
References: <4ebe9767.8366b40a.1a27.4371@mx.google.com> <4EBE9AA6.8090500@iki.fi> <4EBEA5F3.1050103@iki.fi>
In-Reply-To: <4EBEA5F3.1050103@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 06:59 PM, Antti Palosaari wrote:
> On 11/12/2011 06:11 PM, Antti Palosaari wrote:
> I looked those just through and I want more information about every
> patch. Mainly I want to know which resolves which problem. As far as I
> understand, there is two problems;
> 1. register access fails sometimes (as I suspect in case of access some
> registers when firmware is programming tuner or doing some other task
> and does not expect it is interrupted)
> 2. stream corruptions
>
> Is that possible you identify which changes fix 1 and what are for 2?

I fixed that I2C failing, simply blocking problematic demod callbacks 
that only other demod can access at once. Basically problem is that 
AF9015 FW don't like to get interrupted for I2C access in certain cases.
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9015

That was easy to guess after I2C mux approach didn't fixed errors 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg36709.html

If someone would like to see how that new mux can be used, take a look here:
http://www.otit.fi/~crope/v4l-dvb/af9015_i2c_mux.patch



I haven't looked stream corruptions and I will not even look, since 
those not happening much my hw. I think your fix is based the fact you 
forced PID-filter always on. Could you remove all the other changes you 
did and force it using dvb-usb orce_pid_filter_usage param to see if 
thats really the only only problem? And also testing using max packet 
sizes could be interesting to see.



I will now continue implement get_if() for AF9013 and tuners it uses.


regards
Antti

-- 
http://palosaari.fi/
