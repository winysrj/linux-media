Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64395 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaKXRUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 12:20:04 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so9572098wib.3
        for <linux-media@vger.kernel.org>; Mon, 24 Nov 2014 09:20:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547334F8.8050403@iki.fi>
References: <1416812256-27894-1-git-send-email-olli.salonen@iki.fi>
	<1416812256-27894-4-git-send-email-olli.salonen@iki.fi>
	<547334F8.8050403@iki.fi>
Date: Mon, 24 Nov 2014 19:18:59 +0200
Message-ID: <CAAZRmGxwjNeqKEBWwbLC8EigUvr=UGNAwZkOmkqvRu7_ZQwCug@mail.gmail.com>
Subject: Re: [PATCH 4/4] si2157: Add support for Si2148-A20
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	crazyCat <crazycat69@narod.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moro Antti,

Allright, possibly there won't be new firmware for the previous
generation 2148/2158 anyway, who knows. Thanks for the reviews!

Cheers,
-olli

On 24 November 2014 at 15:39, Antti Palosaari <crope@iki.fi> wrote:
> Moikka!
> I decided apply old crazyCat version, even I originally asked that firmware
> change! If I ever will ran problem with Si2148 / Si2158 firmware difference,
> I know who to blame ;p
>
> That patch could be dropped.
> PULL request already sent.
>
> regards
> Antti
>
> On 11/24/2014 08:57 AM, Olli Salonen wrote:
>>
>> The Silicon Labs Si2148 tuner works as the Si2158, but does not contain
>> analog tuner. A firmware is required for the tuner. Currently the Si2158-A20
>> firmware will work for Si2148-A20 as well, but as there are no guarantees
>> that that will be the case in future, a unique file name is used for the
>> firmware.
>>
>> The datasheet is available on manufacturer's website:
>> http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2148-short.pdf
>>
>> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
>
>
> --
> http://palosaari.fi/
