Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56908 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab3LSQu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 11:50:58 -0500
Message-ID: <52B323F0.2050701@iki.fi>
Date: Thu, 19 Dec 2013 18:50:56 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v3 6/7] rtl2832_sdr: convert to SDR API
References: <1387231688-8647-1-git-send-email-crope@iki.fi> <1387231688-8647-7-git-send-email-crope@iki.fi> <52B2BA92.8080706@xs4all.nl>
In-Reply-To: <52B2BA92.8080706@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans!

On 19.12.2013 11:21, Hans Verkuil wrote:
> On 12/16/2013 11:08 PM, Antti Palosaari wrote:
>> It was abusing video device API. Use SDR API instead.
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 291 ++++++++++++++++++-----
>>   1 file changed, 227 insertions(+), 64 deletions(-)
>>
>
> A question: does this driver only do SDR, or does it also
> do 'regular' video and/or radio?
>
> If it does, then how does it switch from one tuner mode to another?
>
> E.g. from ANALOG_TV to RADIO to SDR?
>
> During the Barcelona summit in 2012 we discussed this. See the last two
> slides of my presentation:
>
> http://linuxtv.org/downloads/presentations/media_ws_2012_EU/ambiguities2.odp
>
> Basically this proposal was accepted provided that the code to handle tuner
> ownership should be shared between DVB and V4L2.
>
> I made an initial attempt for this here:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/tuner
>
> I never had the time to continue with it, but it might be useful for rtl2832.

Yes, that driver sits on both DVB and V4L2 API. It is USB DVB-T stick, 
which could be abused as a SDR.

There is following software blocks:
1) dvb_usb + dvb_usb_rtl28xxu modules to provide USB interface
2) rtl2832 module to provide DVB-T demodulator (implements DVB frontend, 
which logical entity representing DVB hardware)
3) various silicon RF tuners, eg. e4000, r820t, fc0013... These tuners 
are provided via DVB API, frontend tuners.
4) rtl2832_sdr module, which is attached to DVB frontend using "sec". 
Term sec stays satellite equipment controller (provides typically LNB 
voltage)

It should be also noted that DVB-T demodulator and SDR functionality is 
provided "physically" by same RTL2832 demod - whilst I decided to split 
those own drivers. And make situation looks even more complex, I can say 
RTL2832 demod is integrated physically to same silicon than USB-bridge 
(but logically those seems to be totally different chip sill).

Hope those explanations could give some light what kind of connections 
and blocks there is involved.

So indeed there is that same hybrid tuner problem to resolve. And not 
only that hybrid problem, but you will need to expose much more 
properties from RF tuner than DVB API or V4L2 API tuner model does 
currently. I haven't looked situation more carefully yet, but one thing 
that must be done at the very first is to add some lock to prevent only 
DVB or V4L2 API could access the hardware at time.

regards
Antti

-- 
http://palosaari.fi/
