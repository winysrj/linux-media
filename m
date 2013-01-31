Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36281 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab3AaOkG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 09:40:06 -0500
Message-ID: <510A821F.1060101@iki.fi>
Date: Thu, 31 Jan 2013 16:39:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Stilmant-Rovi <stilmant.michael.rovi@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: DVB_T2 Multistream support (PLP)
References: <CABXgeUHzMhk7rCtpoVuEz1zUYuGwUMEmxrFMKripnO8qvNX+Sg@mail.gmail.com>
In-Reply-To: <CABXgeUHzMhk7rCtpoVuEz1zUYuGwUMEmxrFMKripnO8qvNX+Sg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/31/2013 04:27 PM, Michael Stilmant-Rovi wrote:
> Hello,
>
> I would like to know the support status of Multiple PLPs in DVB-T2.
> Is someone know if tests were performed in a broadcast with an
> effective Multistream? (PLP Id: 0 and 1 for example)
>
> I'm out of range of such multiplex but I'm trying some tunes on London
> DVB-T2 (CrystalPalace tower)
> "unfortunately" that mux seems Single PLP and everything work well :-(
>    ( yes tune always succeed :-D )
>
> I'm using DVB API 5.6.
> If I tune with FE_SET_PROPERTY without or with DTV_DVBT2_PLP_ID set to
> 0, 1 or 15. the tune succeed.
>
> I'm not sure of the expected behavior, I was expecting if I tune with
> plp_id 1 that the tuner would fail somewhere finding that stream.
>
> So in short I don't understand what is the requirements to be able to
> use the DVB_T2 Multistream support proposed in APIs:
>   o I see that the DVB API 5.8(?) had some patch at that level and so
> it is maybe requested?
>   o How can I know if my driver support that feature on DVB API 5.6?
> (PCTV nanoStick T2 290e)?
>
> Thank you for all indications.
>
> -Michael

nanoStick T2 290e Linux driver does not support multiple PLPs. I did 
that driver and I has only Live signal with single TS. What I think 
Windows driver either supports that feature. It just tunes to first PLP 
regardless of whole property and that's it.

regards
Antti

-- 
http://palosaari.fi/
