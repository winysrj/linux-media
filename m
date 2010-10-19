Return-path: <mchehab@pedra>
Received: from smtp1-g21.free.fr ([212.27.42.1]:39511 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933583Ab0JSHND (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 03:13:03 -0400
Received: from [192.168.0.1] (unknown [83.159.42.244])
	by smtp1-g21.free.fr (Postfix) with ESMTP id DDA3E94001B
	for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 09:12:55 +0200 (CEST)
Message-ID: <4CBD450E.1070907@free.fr>
Date: Tue, 19 Oct 2010 09:13:18 +0200
From: =?ISO-8859-1?Q?Herv=E9_Cauwelier?= <herve.cauwelier@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: support for AF9035 (not tuner)
References: <4CBBFCBA.2010707@free.fr> <20101018185729.GA8210@minime.bse> <4CBCA407.9080101@free.fr> <20101018203932.GB8210@minime.bse>
In-Reply-To: <20101018203932.GB8210@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/18/10 22:39, Daniel Glöckner wrote:
> On Mon, Oct 18, 2010 at 09:46:15PM +0200, Hervé Cauwelier wrote:
>> I've uploaded the compressed installer at http://dl.free.fr/p2BTq9BNi
>
> The driver mentiones two video decoders:
> - TI TVP5150
> - Trident AVF4900B/AVF4910B
>
> If it is the first one, sniffed USB traffic might be enough to write a
> driver as there already is one for the decoder.
>
> The latter one is undocumented. Two months ago I was told by Trident
> that the device is not supported as it has been phased out from
> production.
>
>    Daniel

I managed to open it properly. I see two chips: the AF9035B and the 
other one is labelled "AVF 4910BA1".

So is it dead? I couldn't find any datasheet, even to sell. I could only 
find a commercial 2-page PDF presentation. I doubt you can grab any 
technical information from it.

Do I continue searching for a datasheet?

Hervé
