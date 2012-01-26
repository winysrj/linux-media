Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50125 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab2AZXMd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 18:12:33 -0500
Message-ID: <4F21DDDF.60804@iki.fi>
Date: Fri, 27 Jan 2012 01:12:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jesper Krogh <jesper@rapanden.dk>
CC: linux-media@vger.kernel.org
Subject: Re: Anysee E30 S2 plus
References: <CA+kQy-XAL4Kz2+Ft68V8QBqM7pETdJd-WhGmmUxETXJ02kKJEg@mail.gmail.com> <4EF04250.9020502@iki.fi> <CA+kQy-VxNT43b5rkBHPV_jyHisfiFXP_isNpGmf7vnGLsA3njw@mail.gmail.com> <4EF0A68C.4040201@iki.fi>
In-Reply-To: <4EF0A68C.4040201@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/20/2011 05:15 PM, Antti Palosaari wrote:
> On 12/20/2011 02:10 PM, Jesper Krogh wrote:
>> Ok. I had my doubts on whether to include that or not - But here it is
>>
>> /Jesper
>>
>> [ 1056.137882] DVB: registering new adapter (Anysee DVB USB2.0)
>> [ 1056.141938] anysee: firmware version:1.3 hardware id:11
>> [ 1056.145212] Invalid probe, probably not a CX24116 device
>> [ 1056.145231] anysee: Unsupported Anysee version. Please report the
>> <linux-media@vger.kernel.org>.
>
> Check your power supply is connected. It do same here without power
> supply since demod is powered using external power supply.
>
> If not then it is most likely firmware issue. I have very old firmware,
> maybe one of the first devel versions.

I got today similar bug report and after debugging we found there is 
different hardware. Whole NIM, that is box containing demodulator and 
tuner, is different. Instead of old CX24116 there is same NIM than can 
be found from the E7 serie DVB-S2 receiver.

So I have to get this new revision of that device in order to add 
support for it... Sorry :/


regards
Antti
-- 
http://palosaari.fi/
