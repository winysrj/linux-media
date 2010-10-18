Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:44945 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932993Ab0JRTrI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 15:47:08 -0400
Received: from [192.168.0.1] (unknown [82.254.165.3])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 7F2DED481C4
	for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 21:46:31 +0200 (CEST)
Message-ID: <4CBCA407.9080101@free.fr>
Date: Mon, 18 Oct 2010 21:46:15 +0200
From: =?ISO-8859-1?Q?Herv=E9_Cauwelier?= <herve.cauwelier@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: support for AF9035 (not tuner)
References: <4CBBFCBA.2010707@free.fr> <20101018185729.GA8210@minime.bse>
In-Reply-To: <20101018185729.GA8210@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/18/10 20:57, Daniel Glöckner wrote:
> On Mon, Oct 18, 2010 at 09:52:26AM +0200, Hervé Cauwelier wrote:
>> I got a USB video grabber, which is a dumb analog video converter.
>>
>> Installing it under Windows with the given drivers reveals it as
>> "AF9035 Analog Capture Filter", when capturing from VLC for example.
>
> There is no open source driver making use of the I2S and ITU656
> interfaces of this chip. Both Antti's and Afatech/ITE's driver only
> do DVB-T.
>
> There must be one more chip in that grabber doing the actual
> analog->digital conversion. Do you know which one?
> Or can you provide a link to the Windows driver?
>
>    Daniel

I've uploaded the compressed installer at http://dl.free.fr/p2BTq9BNi
It's 1.6 MB.

Or maybe you just needed some INF or CAT file installed on my computer?

Hervé
