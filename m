Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:47886 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab2EIKed (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 May 2012 06:34:33 -0400
Received: from [192.168.0.104] (unknown [82.225.141.62])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 035779400F4
	for <linux-media@vger.kernel.org>; Wed,  9 May 2012 12:34:24 +0200 (CEST)
Message-ID: <4FAA482F.9030907@yahoo.fr>
Date: Wed, 09 May 2012 12:34:23 +0200
From: chrbruno <chrbruno@yahoo.fr>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: em28xx : can work on ARM beagleboard ?
References: <4FA96365.3090705@yahoo.fr> <4FA964E8.8080209@iki.fi> <CAGoCfiy4qkVQwy+zPH+r8jMxMX7heJk6BLPnOMJxF73FnBms+A@mail.gmail.com> <4FA96B9E.3080600@iki.fi>
In-Reply-To: <4FA96B9E.3080600@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I confirm it works fine on an x86 arch
i will have a look to the HCL to find a compatible usb video capture stick !

Thanks for your answers

Chris



Le 08/05/2012 20:53, Antti Palosaari a écrit :
> On 08.05.2012 21:47, Devin Heitmueller wrote:
>> On Tue, May 8, 2012 at 2:24 PM, Antti Palosaari<crope@iki.fi>  wrote:
>>> It should work as I know one person ran PCTV NanoStick T2 290e using
>>> Pandaboard which is rather similar ARM hw.
>>> http://www.youtube.com/watch?v=Wuwyuw0y1Fo
>>
>> I ran into a couple of issues related to em28xx analog on ARM.
>> Haven't had a chance to submit patches yet.  To answer the question
>> though:  yes, analog support for the em28xx is known to be broken on
>> ARM right now.
>
> Aah, OK. I missed that was analog capture device. Devin surely knows 
> what he speaks.
>
> regards
> Antti

