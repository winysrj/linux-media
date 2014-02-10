Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59347 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbaBJK1K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:27:10 -0500
Message-ID: <52F8A97B.9080401@iki.fi>
Date: Mon, 10 Feb 2014 12:27:07 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: gennarone@gmail.com, Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 00/86] SDR tree
References: <1391935771-18670-1-git-send-email-crope@iki.fi> <52F89F2E.3040902@xs4all.nl> <52F8A4A2.9080106@gmail.com>
In-Reply-To: <52F8A4A2.9080106@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.02.2014 12:06, Gianluca Gennari wrote:
> Hi Hans,
>
>> First of all, would this work for a rtl2838 as well or is this really 2832u
>> specific? I've got a 2838...  If it is 2832u specific, then do you know which
>> product has it? It would be useful for me to have a usb stick with which I can
>> test SDR.
>
> regarding this question, 2838 is just another USB Id for rtl2832u
> devices based on reference design. I have one with rtl2832u + e4000
> tuner, so probably your stick is fine for SDR.
>
> Realtek makes several different demodulators with similar codenames:
> - 2830/2832 DVB-T
> - 2836 DTMB
> - 2840 DVB-C
>
> see here for more info:
> http://www.realtek.com.tw/products/productsView.aspx?Langid=1&PNid=7&PFid=22&Level=3&Conn=2

Yeah, demod chips are just like that. Then these are integrated like that:
RT2831U = USB-interface + RTL2830 DVB-T demod
RT2832U = USB-interface + RTL2832 DVB-T demod
RT2832P = USB-interface + RTL2832 DVB-T demod + TS interface

USB-interface used is pretty same for all these, thus it is split to own 
driver named dvb_usb_rtl28xxu.

SDR functionality is property of RTL2832 demodulator, but I decided to 
split it to own driver too.

Currently that SDR driver has support for devices having following RF 
tuners: e4000, r820t, fc0012 and fc0013. So if Hans has a device having 
some of those tuners, it should work.

regards
Antti

-- 
http://palosaari.fi/
