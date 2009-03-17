Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36205 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZCQNmC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 09:42:02 -0400
Message-ID: <49BFA8A6.6010909@iki.fi>
Date: Tue, 17 Mar 2009 15:41:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: pureherz@gmail.com
CC: linux-media@vger.kernel.org,
	Tanguy PRUVOT <tanguy.pruvot@gmail.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] EC168 and MT2060
References: <1237129041.7993.38.camel@0ri0n> <49BD3B31.8030308@iki.fi>	 <1237146464.7993.94.camel@0ri0n> <49BD5D0E.3090304@iki.fi>	 <1237208613.8685.13.camel@0ri0n>	 <fe7b409d0903160826m23961c90i147661d0fa083c8e@mail.gmail.com>	 <49BE7031.50005@iki.fi> <1237249937.19477.8.camel@0ri0n>
In-Reply-To: <1237249937.19477.8.camel@0ri0n>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

t.Hgch wrote:
> Hi,
> 
> I found that my card isn't locking on certain frequencies,Could it be a
> problem of signal strength? In widows it gets all channels though.

Your signal strength is not enough. I think Linux mxl5005s tuner driver 
does not have as good performance as Windows. You can try to change some 
tuner parameters (in ec168.c file) to see if you will found some more 
sensitivity.

> Here is the log:
> [41630.737986] c0 03 00 00 01 ff 01 00 <<< 02 
> [41630.750251] c0 03 00 00 01 ff 01 00 <<< 13 
> [41630.802108] c0 03 00 00 01 ff 01 00 <<< 34 
> [41630.833250] c0 03 00 00 01 ff 01 00 <<< 35

I think this register contains demodulator lock bits. When it is 0cf6 
demod is fully locked. No lock here...

> I also get this from time to time but don't how to reproduce exactly:
> 
> [33044.376068] ec168_rw_udev: usb_control_msg failed :-110

I should add one ms sleep to avoid this.

regards
Antti
-- 
http://palosaari.fi/
