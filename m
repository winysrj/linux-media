Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55059 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbaBGXRH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 18:17:07 -0500
Message-ID: <52F56971.8060104@iki.fi>
Date: Sat, 08 Feb 2014 01:17:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: kapetr@mizera.cz, linux-media@vger.kernel.org
Subject: Re: video from USB DVB-T get  damaged after some time
References: <52F50E0B.1060507@mizera.cz>
In-Reply-To: <52F50E0B.1060507@mizera.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka

On 07.02.2014 18:47, kapetr@mizera.cz wrote:
> Hello,
>
> I have this:
> http://linuxtv.org/wiki/index.php/ITE_IT9135
>
> with dvb-usb-it9135-02.fw (chip version 2) on U12.04 64b with compiled
> newest drivers from:
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers.
>
>
>
> The problem is - after some time I receive a program (e.g. in Kaffeine,
> me-tv, vlc, ...) the program get more and more damaged and finely get
> lost at all.
>
> I happens quicker (+- after 10-20 minutes) on channels with lower
> signal. On stronger signals it happens after +- 30-100 minutes.
>
> The USB stick stays cool.
>
> I can switch to another frequency and back and it works again OK - for
> only the "same" while.
>
> Could that problem be in (or solvable by) FW/drivers or is it
> !absolutely certain! "only" HW problem ?
>
> In attachment is output from tzap - you can see the time point where the
> video TS gets damaged.
>
> Any suggestion ?
>
>
> Thanks  --kapetr
>

Could you test AF9035 driver? It support also IT9135 (difference between 
AF9035 is integrated RF tuner, AF9035 is older and needs external tuner 
whilst IT9135 contains tuner in same chip).

Here is example patch how to add USB ID to af9035 driver:
https://patchwork.linuxtv.org/patch/21611/

regards
Antti

-- 
http://palosaari.fi/
