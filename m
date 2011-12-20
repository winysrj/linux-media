Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36591 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab1LTPP1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 10:15:27 -0500
Message-ID: <4EF0A68C.4040201@iki.fi>
Date: Tue, 20 Dec 2011 17:15:24 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jesper Krogh <jesper@rapanden.dk>
CC: linux-media@vger.kernel.org
Subject: Re: Anysee E30 S2 plus
References: <CA+kQy-XAL4Kz2+Ft68V8QBqM7pETdJd-WhGmmUxETXJ02kKJEg@mail.gmail.com> <4EF04250.9020502@iki.fi> <CA+kQy-VxNT43b5rkBHPV_jyHisfiFXP_isNpGmf7vnGLsA3njw@mail.gmail.com>
In-Reply-To: <CA+kQy-VxNT43b5rkBHPV_jyHisfiFXP_isNpGmf7vnGLsA3njw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/20/2011 02:10 PM, Jesper Krogh wrote:
> Ok. I had my doubts on whether to include that or not - But here it is
>
> /Jesper
>
> [ 1056.137882] DVB: registering new adapter (Anysee DVB USB2.0)
> [ 1056.141938] anysee: firmware version:1.3 hardware id:11
> [ 1056.145212] Invalid probe, probably not a CX24116 device
> [ 1056.145231] anysee: Unsupported Anysee version. Please report the
> <linux-media@vger.kernel.org>.

Check your power supply is connected. It do same here without power 
supply since demod is powered using external power supply.

If not then it is most likely firmware issue. I have very old firmware, 
maybe one of the first devel versions.

regards
Antti


-- 
http://palosaari.fi/
