Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:34024 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab1E1NLf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 09:11:35 -0400
Message-ID: <4DE0F47E.1060509@iki.fi>
Date: Sat, 28 May 2011 16:11:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: linux-media@vger.kernel.org,
	Steve Kerrison <steve@stevekerrison.com>
Subject: Re: PCTV nanoStick T2 290e support - Thank you!
References: <1306445141.14462.0.camel@porites> <4DDEDB0E.30108@iki.fi> <201105281604.48018.remi@remlab.net>
In-Reply-To: <201105281604.48018.remi@remlab.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/28/2011 04:04 PM, Rémi Denis-Courmont wrote:
> By the way, what is the V4L2 device node supposed to be? I don't suppose the
> hardware supports analog nor hardware decoding!? Is it just a left over from
> the em28xx driver?

Yes. Totally useless for digital only em287x series, em288x is digital + 
analog.

Device hangs if not rmmod drivers before unplug and in my understanding 
there is some suspicion it is analog audio. Devin may know more.

regards,
Antti

-- 
http://palosaari.fi/
