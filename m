Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49135 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab2EHSxV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 May 2012 14:53:21 -0400
Message-ID: <4FA96B9E.3080600@iki.fi>
Date: Tue, 08 May 2012 21:53:18 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: CB <chrbruno@yahoo.fr>, linux-media <linux-media@vger.kernel.org>
Subject: Re: em28xx : can work on ARM beagleboard ?
References: <4FA96365.3090705@yahoo.fr> <4FA964E8.8080209@iki.fi> <CAGoCfiy4qkVQwy+zPH+r8jMxMX7heJk6BLPnOMJxF73FnBms+A@mail.gmail.com>
In-Reply-To: <CAGoCfiy4qkVQwy+zPH+r8jMxMX7heJk6BLPnOMJxF73FnBms+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08.05.2012 21:47, Devin Heitmueller wrote:
> On Tue, May 8, 2012 at 2:24 PM, Antti Palosaari<crope@iki.fi>  wrote:
>> It should work as I know one person ran PCTV NanoStick T2 290e using
>> Pandaboard which is rather similar ARM hw.
>> http://www.youtube.com/watch?v=Wuwyuw0y1Fo
>
> I ran into a couple of issues related to em28xx analog on ARM.
> Haven't had a chance to submit patches yet.  To answer the question
> though:  yes, analog support for the em28xx is known to be broken on
> ARM right now.

Aah, OK. I missed that was analog capture device. Devin surely knows 
what he speaks.

regards
Antti
-- 
http://palosaari.fi/
