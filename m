Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:54856 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3BPH5o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 02:57:44 -0500
Received: by mail-vb0-f48.google.com with SMTP id fc21so2573590vbb.7
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 23:57:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABXgeUHzMhk7rCtpoVuEz1zUYuGwUMEmxrFMKripnO8qvNX+Sg@mail.gmail.com>
References: <CABXgeUHzMhk7rCtpoVuEz1zUYuGwUMEmxrFMKripnO8qvNX+Sg@mail.gmail.com>
Date: Sat, 16 Feb 2013 13:27:43 +0530
Message-ID: <CAHFNz9L-TM-+unnGWR5ak8x1WsVrNcL1J6aKLmBpfRtGYxe1bg@mail.gmail.com>
Subject: Re: DVB_T2 Multistream support (PLP)
From: Manu Abraham <abraham.manu@gmail.com>
To: Michael Stilmant-Rovi <stilmant.michael.rovi@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 31, 2013 at 7:57 PM, Michael Stilmant-Rovi
<stilmant.michael.rovi@gmail.com> wrote:
> Hello,
>
> I would like to know the support status of Multiple PLPs in DVB-T2.
> Is someone know if tests were performed in a broadcast with an
> effective Multistream? (PLP Id: 0 and 1 for example)
>
> I'm out of range of such multiplex but I'm trying some tunes on London
> DVB-T2 (CrystalPalace tower)
> "unfortunately" that mux seems Single PLP and everything work well :-(
>   ( yes tune always succeed :-D )
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
>  o I see that the DVB API 5.8(?) had some patch at that level and so
> it is maybe requested?
>  o How can I know if my driver support that feature on DVB API 5.6?
> (PCTV nanoStick T2 290e)?
>
> Thank you for all indications.


At least, according to Sony: the CXD2820 chipset maker (hardware) doesn't
support multiple PLP's.


Regards,
Manu
