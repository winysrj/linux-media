Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46347 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1LGNs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 08:48:58 -0500
Received: by iakc1 with SMTP id c1so961556iak.19
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2011 05:48:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111201131149.231660@gmx.net>
References: <20111201131149.231660@gmx.net>
Date: Wed, 7 Dec 2011 14:48:58 +0100
Message-ID: <CAL7owaDoJnQB1TunD4zt2QQznQ1OaVQbo-MHzzZ6nvmcJwHGTA@mail.gmail.com>
Subject: Re: DVB-T Muxes Germany / Berlin outdated, please update...
From: Christoph Pfister <christophpfister@gmail.com>
To: Barts Builder <pe-builder@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Your version of dvb-apps is older than three months (your output
doesn't contradict [1]), tuning parameters haven't changed since then.

Christoph

[1] http://linuxtv.org/hg/dvb-apps/rev/7c4cee8c5709


2011/12/1 Barts Builder <pe-builder@gmx.de>:
> Problem:
> The Muxes from 'Network by Location' of tvheadend are outdated for Germany / Berlin.
>
> tvheadend bugtracker answer:
> Please report outdated mux information the the linux-media mailing list. Tvheadend is taking the list from the dvb-apps initial tuning files as the basis for the list of dvb networks.
>
> Freqency:QAM:MHz:k-mode:MuxID
> 506000:16:8:8:773
> 522000:16:8:8:258
> 570000:16:8:8:514
> 618000:64:?:?:775
> 658000:16:8:8:769
> 706000:64:8:8:772
> 754000:16:8:8:774
>
> w_scan version 20101001 (compiled for DVB API 5.2) scan result 37 services (Ubuntu 11.04) Germany / Berlin
> -----------------------------------------------------------------------------------------
> Das Erste;ARD:522000:I999B8C23D0M16T8G8Y0:T:27500:1401:1402=deu,1403=mis:1404:0:14:8468:258:0
> rbb Berlin;ARD:522000:I999B8C23D0M16T8G8Y0:T:27500:1201:1202=ger:1204:0:12:8468:258:0
> rbb Brandenburg;ARD:522000:I999B8C23D0M16T8G8Y0:T:27500:1201:1202=ger:1504:0:11:8468:258:0
> Phoenix;ARD:522000:I999B8C23D0M16T8G8Y0:T:27500:1301:1302=ger:1304:0:13:8468:258:0
> EinsExtra;ARD:522000:I999B8C23D0M16T8G8Y0:T:27500:1501:1502=ger:1404:0:15:8468:258:0
> SAT.1;ProSiebenSat.1:658000:I999B8C23D0M16T8G8Y0:T:27500:385:386=deu:391:0:16408:8468:769:0
> ProSieben;ProSiebenSat.1:658000:I999B8C23D0M16T8G8Y0:T:27500:305:306=deu:311:0:16403:8468:769:0
> kabel eins;ProSiebenSat.1:658000:I999B8C23D0M16T8G8Y0:T:27500:161:162=deu:167:0:16394:8468:769:0
> N24;ProSiebenSat.1:658000:I999B8C23D0M16T8G8Y0:T:27500:225:226=deu:231:0:16398:8468:769:0
> WDR Köln;ARD:706000:I999B8C23D0M16T8G8Y0:T:27500:4193:4194=deu:4199:0:262:8468:772:0
> Südwest BW/RP;ARD:706000:I999B8C23D0M16T8G8Y0:T:27500:3601:3602=deu:3607:0:225:8468:772:0
> HSE24;MEDIA BROADCAST:706000:I999B8C23D0M16T8G8Y0:T:27500:49:50=deu:55:0:16387:8468:772:0
> TELE 5;MEDIA BROADCAST:706000:I999B8C23D0M16T8G8Y0:T:27500:465:466=deu:471:0:16413:8468:772:0
> Eurosport;Media Broadcast:754000:I999B8C23D0M16T8G8Y0:T:27500:577:578=ger:583:0:16420:8468:774:0
> TV.Berlin;Media Broadcast:754000:I999B8C23D0M16T8G8Y0:T:27500:3121:3122=ger:3127:0:16579:8468:774:0
> imusic TV;Media Broadcast:754000:I999B8C23D0M16T8G8Y0:T:27500:129:130=deu:0:0:16392:8468:774:0
> sixx;ProSiebenSat.1:754000:I999B8C23D0M16T8G8Y0:T:27500:273:274=deu:279:0:16401:8468:774:0
> Bayerisches FS;ARD:618000:I999B8C23D0M64T8G8Y0:T:27500:545:546=deu:551:0:34:8468:775:0
> n-tv;RTL World:618000:I999B8C23D0M64T8G8Y0:T:27500:257:258=ger:263:0:16400:8468:775:0
> QVC;MEDIA BROADCAST:618000:I999B8C23D0M64T8G8Y0:T:27500:321:322=ger:327:0:16404:8468:775:0
> Channel 21/Euronews;MEDIA BROADCAST:618000:I999B8C23D0M64T8G8Y0:T:27500:593:594=deu,595=eng,596=fra:599:0:16421:8468:775:0
> Bibel TV;MEDIA BROADCAST:618000:I999B8C23D0M64T8G8Y0:T:27500:673:674=ger:679:0:16426:8468:775:0
> DAS VIERTE;BetaDigital:618000:I999B8C23D0M64T8G8Y0:T:27500:737:738=deu:743:0:16430:8468:775:0
> sunshine live;BetaDigital:618000:I999B8C23D0M64T8G8Y0:T:27500:0:274=deu:0:0:24593:8468:775:0
> ERF Radio;BetaDigital:618000:I999B8C23D0M64T8G8Y0:T:27500:0:290=deu:0:0:24594:8468:775:0
> Radio Horeb;Eurociel:618000:I999B8C23D0M64T8G8Y0:T:27500:0:306=ger:0:0:24595:8468:775:0
> the wave - relaxing radio;MEDIA BROADCAST:618000:I999B8C23D0M64T8G8Y0:T:27500:0:610=DEU:0:0:24614:8468:775:0
> 104.6 RTL;MEDIA BROADCAST:618000:I999B8C23D0M64T8G8Y0:T:27500:0:2082=DEU:0:0:26498:8468:775:0
> Radio Paloma;MEDIA BROADCAST:618000:I999B8C23D0M64T8G8Y0:T:27500:0:2162=DEU:0:0:26503:8468:775:0
> Spreeradio;MEDIA BROADCAST:618000:I999B8C23D0M64T8G8Y0:T:27500:0:2210=DEU:0:0:26506:8468:775:0
> NDR FERNSEHEN;ARD:682000:I999B8C23D0M16T8G8Y0:T:27500:4881:4882=ger:4884:0:129:8468:257:0
> MDR Sachsen;ARD:682000:I999B8C23D0M16T8G8Y0:T:27500:4897:4898=ger:4900:0:97:8468:257:0
> arte;ARD:682000:I999B8C23D0M16T8G8Y0:T:27500:4913:4914=deu,4915=fra:4916:0:2:8468:257:0
> ZDF;ZDFmobil:570000:I999B8C23D0M16T8G4Y0:T:27500:545:546=deu,547=mis:551:0:514:8468:514:0
> 3sat;ZDFmobil:570000:I999B8C23D0M16T8G4Y0:T:27500:561:562=deu,563=mis:567:0:515:8468:514:0
> neo/KI.KA;ZDFmobil:570000:I999B8C23D0M16T8G4Y0:T:27500:593:594=deu:599:0:517:8468:514:0
> ZDFinfo;ZDFmobil:570000:I999B8C23D0M16T8G4Y0:T:27500:577:578=deu:551:0:516:8468:514:0
> --
> Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
> belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
> --
> Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
> belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
