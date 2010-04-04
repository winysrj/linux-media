Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58416 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab0DDQgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Apr 2010 12:36:40 -0400
Received: by pwi5 with SMTP id 5so2446203pwi.19
        for <linux-media@vger.kernel.org>; Sun, 04 Apr 2010 09:36:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <815e21b51003050832j728a915byf7909badc85ddd16@mail.gmail.com>
References: <815e21b51003050832j728a915byf7909badc85ddd16@mail.gmail.com>
Date: Sun, 4 Apr 2010 18:36:39 +0200
Message-ID: <h2x815e21b51004040936m828634d0l2181c6377762a2c3@mail.gmail.com>
Subject: Re: DVB-S2 Multistream (?)
From: Matteo <marchimatteo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After Mediaset, another broadcaster in Italy uses DVB-S2 Multistream,
this time on Atlantic Bird 1 (12.5°W), frequency 12718H.

More info:
http://www.newtec.eu/uploads/media/NEWTEC_press_release_Multistream_Telecom-Italia-Media-Broadcasting_TIMB___2010-03-15_01.pdf

http://www.newtec.eu/fileadmin/mailings/Product_updates/Multistream/Newtec-Customer-Case_Multistream_TelecomItaliaMediaBroadcasting_2010-02-25.pdf

2010/3/5 Matteo <marchimatteo@gmail.com>:
> Hi,
>
> I have problems with some frequencies which I suppose are broadcasted
> in DVB-S2 Multistream,  I think it's the same topic already discussed
> a long time ago here:
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg26874.html
>
> Frequencies that use this feature on Hotbird (13°E) should be:
>
> 11334 MHz, pol H, SR 27500
> 11373 MHz, pol H, SR 27500
> 11432 MHz, pol V, SR 27500
>
> I can lock the frequencies, but the signal is really unstable, video
> full of errors, and everytime I do a scan I get the channel list from
> only one TS (apparently chosen randomly). Exact same problems on
> Windows.
>
> I use a TechnoTrend S2-1600, and I was wondering if there is any plan
> to eventually support this feature (if it's not an hardware
> limitation).
>
>
> Thanks
> Matteo
>
