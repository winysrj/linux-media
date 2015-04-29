Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33684 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbbD2XhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:37:20 -0400
Received: by pacwv17 with SMTP id wv17so41731666pac.0
        for <linux-media@vger.kernel.org>; Wed, 29 Apr 2015 16:37:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD4j4=BjObj2Q24Zd-kNC1gtXGGa6sVZ9GYs0O64jXhRrhFY6Q@mail.gmail.com>
References: <CAD4j4=BjObj2Q24Zd-kNC1gtXGGa6sVZ9GYs0O64jXhRrhFY6Q@mail.gmail.com>
Date: Thu, 30 Apr 2015 01:37:20 +0200
Message-ID: <CAD4j4=CjH5wUkA=EmgWK+PXTxPxj=bmL6kkgdmszY3coD0-5pQ@mail.gmail.com>
Subject: Re: DVB-T scan tables for es-Vitoria-Gasteiz, es-All and
 channels.conf for Vitoria-Gasteiz
From: =?UTF-8?Q?David_Santamar=C3=ADa_Rogado?= <howl.nsp@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The channels file has get into the mail body.

[La 1]
    SERVICE_ID = 560
...
...
...
    TRANSMISSION_MODE = 8K
    HIERARCHY = NONE
    DELIVERY_SYSTEM = DVBT

[Radio Vitoria]
    SERVICE_ID = 1264
    AUDIO_PID = 7004
    FREQUENCY = 770000000
    MODULATION = QAM/64
    BANDWIDTH_HZ = 8000000
    INVERSION = AUTO
    CODE_RATE_HP = 2/3
    CODE_RATE_LP = 1/2
    GUARD_INTERVAL = 1/4
    TRANSMISSION_MODE = 8K
    HIERARCHY = NONE
    DELIVERY_SYSTEM = DVBT

2015-04-30 1:34 GMT+02:00 David Santamaría Rogado <howl.nsp@gmail.com>:
> Attached the following files:
>
> es-All DVB-T scan table contains all the frequencies used in Spain for
> DVB-T, perhaps it could server as All for every Europe country if
> someone adds also the DVB-T2 configuration inside this one as I think
> the spectrum for digital television in all Europe in now the same.
> Spain only have DVB-T nowadays.
>
> es-Vitoria-Gasteiz DVB-T scan table is the third update of my scan
> file (I didn't submit the second version) with the updated
> reorganization to leave room for the LTE spectrum and containing some
> annotations explaining that there are some autonomical channels from
> es-Burgos and also some illegal emissions tarot, contact and similar
> scam channels.
>
> dvb_channel.conf is the channels-conf dvb-t for Vitoria-Gasteiz in
> DVBv5 format, in git I see all files in DVBv3 format, if it's needed I
> could convert it to the old one.
