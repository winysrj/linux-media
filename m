Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33327 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaLFS3g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 13:29:36 -0500
Message-ID: <54834B0D.6070502@iki.fi>
Date: Sat, 06 Dec 2014 20:29:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jurgen Kramer <gtmkramer@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: DVBSky T980C: Si2168 fw load failed
References: <2eea6b3b11e395b7fb238f350a804dc9.squirrel@webmail.xs4all.nl>
In-Reply-To: <2eea6b3b11e395b7fb238f350a804dc9.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2014 06:48 PM, Jurgen Kramer wrote:
> On my new DVBSky T980C the tuner firmware failes to load:
> [   51.326525] si2168 2-0064: found a 'Silicon Labs Si2168' in cold state
> [   51.356233] si2168 2-0064: downloading firmware from file
> 'dvb-demod-si2168-a30-01.fw'
> [   51.408166] si2168 2-0064: firmware download failed=-110
> [   51.415457] si2157 4-0060: found a 'Silicon Labs Si2146/2147/2148/2157/2158'
> in cold state
> [   51.521714] si2157 4-0060: downloading firmware from file
> 'dvb-tuner-si2158-a20-01.fw'
> [   52.330605] si2168 2-0064: found a 'Silicon Labs Si2168' in cold state
> [   52.330784] si2168 2-0064: downloading firmware from file
> 'dvb-demod-si2168-a30-01.fw'
> [   52.382145] si2168 2-0064: firmware download failed=-110
>
> 110 seems to mean connection timeout. Any pointers how to debug this further?
>
> This is with the latest media_build from linuxtv.org on 3.17.4.

Looks like si2168 firmware failed to download, but si2157 succeeded. 
Could you add some more time for driver timeout? Current timeout is 
selected by trial and error, lets say it takes always max 43ms for my 
device I coded it 50ms.


drivers/media/dvb-frontends/si2168.c
/* wait cmd execution terminate */
#define TIMEOUT 50

change it to
#define TIMEOUT 500

Also, if it does not work, could you enable debugs to see what happens?
rmmod si2168
modprobe si2168
echo -n 'module si2168 =pft' > /sys/kernel/debug/dynamic_debug/control

regards
Antti

-- 
http://palosaari.fi/
