Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:45574 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282Ab0ARUFc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 15:05:32 -0500
Message-ID: <4B54BEF9.6060501@arcor.de>
Date: Mon, 18 Jan 2010 21:05:13 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
References: <4B547EBF.6080105@arcor.de> <829197381001180743k789f336er2bb368f4c689a41@mail.gmail.com>
In-Reply-To: <829197381001180743k789f336er2bb368f4c689a41@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.01.2010 16:43, schrieb Devin Heitmueller:
> On Mon, Jan 18, 2010 at 10:31 AM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
>   
>> I have a question. How are loaded the base firmware into xc3028, in
>> once or in a split ? It's importent for TM6010, the USB-Analyzer said
>> that it load it in once and then send a quitting reqeuest.
>>     
> In most drivers, the xc3028 firmware gets broken down and sent in 64
> byte chunks.  The size of the chunks is controlled by the "max_len"
> field in the xc2028_ctrl structure.
>
> Devin
>
>   
Hi Darvin,

I see. I have set for test "max_len" to 3500 . So can send after main
firmware wrote (3411 byte) a quitting request send (base firmware is
9144 byte). Is it true that the tuner output frequency and the
demodulator input frequency equal is?

Thanks

Stefan Ringel

-- 
Stefan Ringel <stefan.ringel@arcor.de>

