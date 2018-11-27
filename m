Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.eclipso.de ([217.69.254.104]:42753 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730417AbeK0VA5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:00:57 -0500
Received: from roadrunner.suse (p5B31873F.dip0.t-ipconnect.de [91.49.135.63])
        by mail.eclipso.de with ESMTPS id 6110413E
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 11:03:13 +0100 (CET)
From: stakanov <stakanov@eclipso.eu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sean Young <sean@mess.org>, Brad Love <brad@nextdimension.cc>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Date: Tue, 27 Nov 2018 11:02:57 +0100
Message-ID: <1673172.qrKGPYx0fj@roadrunner.suse>
In-Reply-To: <s5hsgzoynhe.wl-tiwai@suse.de>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de> <20181123152625.7992ceb4@coco.lan> <s5hsgzoynhe.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In data luned� 26 novembre 2018 14:31:09 CET, Takashi Iwai ha scritto:
> On Fri, 23 Nov 2018 18:26:25 +0100,
> 
> Mauro Carvalho Chehab wrote:
> > Takashi,
> > 
> > Could you please produce a Kernel for Stakanov to test
> > with the following patches:
> > 
> > https://patchwork.linuxtv.org/patch/53044/
> > https://patchwork.linuxtv.org/patch/53045/
> > https://patchwork.linuxtv.org/patch/53046/
> > https://patchwork.linuxtv.org/patch/53128/
> 
> Sorry for the late reaction.  Now it's queued to OBS
> home:tiwai:bsc1116374-2 repo.  It'll be ready in an hour or so.
> It's based on 4.20-rc4.
> 
> Stakanov, please give it a try later.
> 
> 
> thanks,
> 
> Takashi

O.K. this unbricks partially the card. Now hotbird does search and does sync 
on all channels. Quality is very good. Astra still does interrupt the search 
immediately and does not receive a thing. So it is a 50% brick still, but it 
is a huge progress compared to before. 
I paste the output of the directory below, unfortunately the opensuse paste 
does not work currently so I try here, sorry if this is long. 

Content of the directory 99-media.conf created following the indications 
(please bear in mind that I have also another card installed (Hauppauge 5525) 
although it was not branched to the sat cable and i did change the settings in 
Kaffeine to use only the technisat. But my understanding is limited if this 
may give "noise" in the output, so I thought to underline it, just FYI. 
Output:


[  390.306818] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1772288 | i=1/2
[  390.306824] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14178 | 
buf=0x37,0x62,0x84,0x08
[  390.410809] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1781568 | i=1/2
[  390.410815] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14253 | 
buf=0x37,0xad,0x84,0x08
[  390.514810] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1781568 | i=1/2
[  390.514816] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14253 | 
buf=0x37,0xad,0x84,0x08
[  390.618817] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1770432 | i=1/2
[  390.618823] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14163 | 
buf=0x37,0x53,0x84,0x08
[  390.722836] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1770432 | i=1/2
[  390.722842] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14163 | 
buf=0x37,0x53,0x84,0x08
[  390.826818] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1783424 | i=1/2
[  390.826824] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14267 | 
buf=0x37,0xbb,0x84,0x08
[  390.930825] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1783424 | i=1/2
[  390.930830] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14267 | 
buf=0x37,0xbb,0x84,0x08
[  391.034826] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1768576 | i=1/2
[  391.034829] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14149 | 
buf=0x37,0x45,0x84,0x08
[  391.138827] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1768576 | i=1/2
[  391.138833] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14149 | 
buf=0x37,0x45,0x84,0x08
[  391.242828] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1785280 | i=1/2
[  391.242834] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14282 | 
buf=0x37,0xca,0x84,0x08
[  391.346832] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1785280 | i=1/2
[  391.346838] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14282 | 
buf=0x37,0xca,0x84,0x08
[  391.450832] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1766720 | i=1/2
[  391.450837] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14134 | 
buf=0x37,0x36,0x84,0x08
[  391.554840] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1766720 | i=1/2
[  391.554845] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14134 | 
buf=0x37,0x36,0x84,0x08
[  391.658837] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1787136 | i=1/2
[  391.658843] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14297 | 
buf=0x37,0xd9,0x84,0x08
[  391.762773] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1787136 | i=1/2
[  391.762780] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14297 | 
buf=0x37,0xd9,0x84,0x08
[  391.822207] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  392.086602] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  392.086678] dmxdev: dvb_dvr_open: dvb_dvr_open
[  392.210170] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  392.210448] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  392.210471] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1776000 | i=1/2
[  392.210478] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14208 | 
buf=0x37,0x80,0x84,0x08
[  392.314841] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1776000 | i=1/2
[  392.314847] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14208 | 
buf=0x37,0x80,0x84,0x08
[  392.418847] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1777856 | i=1/2
[  392.418853] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14223 | 
buf=0x37,0x8f,0x84,0x08
[  392.522844] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1777856 | i=1/2
[  392.522850] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14223 | 
buf=0x37,0x8f,0x84,0x08
[  392.626845] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1774144 | i=1/2
[  392.626851] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14193 | 
buf=0x37,0x71,0x84,0x08
[  392.730863] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1774144 | i=1/2
[  392.730869] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14193 | 
buf=0x37,0x71,0x84,0x08
[  392.834869] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1779712 | i=1/2
[  392.834874] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14238 | 
buf=0x37,0x9e,0x84,0x08
[  392.938866] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1779712 | i=1/2
[  392.938872] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14238 | 
buf=0x37,0x9e,0x84,0x08
[  393.046899] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1772288 | i=1/2
[  393.046905] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14178 | 
buf=0x37,0x62,0x84,0x08
[  393.150874] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1772288 | i=1/2
[  393.150879] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14178 | 
buf=0x37,0x62,0x84,0x08
[  393.254844] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1781568 | i=1/2
[  393.254849] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14253 | 
buf=0x37,0xad,0x84,0x08
[  393.358875] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1781568 | i=1/2
[  393.358880] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14253 | 
buf=0x37,0xad,0x84,0x08
[  393.462881] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1770432 | i=1/2
[  393.462886] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14163 | 
buf=0x37,0x53,0x84,0x08
[  393.566878] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1770432 | i=1/2
[  393.566883] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14163 | 
buf=0x37,0x53,0x84,0x08
[  393.670873] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1783424 | i=1/2
[  393.670879] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14267 | 
buf=0x37,0xbb,0x84,0x08
[  393.774890] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1783424 | i=1/2
[  393.774896] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14267 | 
buf=0x37,0xbb,0x84,0x08
[  393.878834] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1768576 | i=1/2
[  393.878840] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14149 | 
buf=0x37,0x45,0x84,0x08
[  393.933297] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.006404] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  394.006485] dmxdev: dvb_dvr_open: dvb_dvr_open
[  394.130167] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  394.130407] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.130478] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1204000 | i=0/2
[  394.130485] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9632 | 
buf=0x25,0xa0,0x84,0x18
[  394.234885] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1204000 | i=0/2
[  394.234891] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9632 | 
buf=0x25,0xa0,0x84,0x18
[  394.239357] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.249516] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.259730] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.269945] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.280166] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.290407] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.300532] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.310616] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.320781] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.330946] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.341053] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.351274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.361473] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.371691] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.381864] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.392129] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.402376] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.412611] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.422710] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.432870] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.443096] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.453382] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.463543] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.473708] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.483880] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.494064] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.504225] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.514479] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.524638] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.534752] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.544904] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.555067] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.565243] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.575421] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.585589] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.595815] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.606038] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.616207] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.626325] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.636453] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.646622] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.656846] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.667069] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.677236] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.687457] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.697641] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.707862] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.718084] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.728306] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.738436] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.748540] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.758663] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.768882] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.779091] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.789307] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.799463] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.809568] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.819728] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.829936] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.840154] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.850386] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.860569] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.870668] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.880798] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.890894] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.901113] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.911391] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.921558] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.931779] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.941996] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.952266] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.962494] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.972665] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.982877] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  394.992997] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.003147] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.013240] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.023380] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.033509] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.043584] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.053674] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.063758] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.073841] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.083919] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.094003] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.104091] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.114244] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.124467] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.134591] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.144684] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.154789] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.164883] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.174965] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.185064] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.195166] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.205269] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.215369] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.225475] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.235690] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.245882] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.256062] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.266241] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.276449] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.286617] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.296839] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.306960] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.317062] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.327227] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.337390] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.347574] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.357699] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.367817] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.377936] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.388119] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.398300] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.408468] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.418635] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.428793] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.438982] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.449203] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.459367] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.469522] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.479692] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.489864] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.500134] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.510295] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.520518] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.530675] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.540886] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.551042] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.561263] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.571485] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.581653] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.591822] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.601979] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.612135] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.622352] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.632569] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.642679] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.652847] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.662962] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.673118] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.683276] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.693500] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.703668] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.713837] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.723994] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.734201] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.744370] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.754540] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.764632] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.774794] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.785062] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.795274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.805503] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.815720] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.825880] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.836150] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.846445] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.856567] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  395.866653] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  396.396478] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  402.838494] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  402.838584] dmxdev: dvb_dvr_open: dvb_dvr_open
[  402.966488] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  402.966732] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1837000 | i=1/2
[  402.966739] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14696 | 
buf=0x39,0x68,0x84,0x08
[  402.966901] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  403.075040] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1837000 | i=1/2
[  403.075047] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14696 | 
buf=0x39,0x68,0x84,0x08
[  403.179116] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1838868 | i=1/2
[  403.179122] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14711 | 
buf=0x39,0x77,0x84,0x08
[  403.283195] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1838868 | i=1/2
[  403.283201] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14711 | 
buf=0x39,0x77,0x84,0x08
[  403.387113] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1835132 | i=1/2
[  403.387119] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14681 | 
buf=0x39,0x59,0x84,0x08
[  403.491047] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1835132 | i=1/2
[  403.491053] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14681 | 
buf=0x39,0x59,0x84,0x08
[  403.595120] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1840736 | i=1/2
[  403.595126] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14726 | 
buf=0x39,0x86,0x84,0x08
[  403.699110] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1840736 | i=1/2
[  403.699116] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14726 | 
buf=0x39,0x86,0x84,0x08
[  403.803124] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1833264 | i=1/2
[  403.803130] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14666 | 
buf=0x39,0x4a,0x84,0x08
[  403.907123] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1833264 | i=1/2
[  403.907129] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14666 | 
buf=0x39,0x4a,0x84,0x08
[  404.011089] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1842604 | i=1/2
[  404.011095] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14741 | 
buf=0x39,0x95,0x84,0x08
[  404.029267] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  404.102993] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  404.103066] dmxdev: dvb_dvr_open: dvb_dvr_open
[  404.226483] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  404.226801] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1588000 | i=1/2
[  404.226808] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12704 | 
buf=0x31,0xa0,0x84,0x08
[  404.226916] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  404.331136] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1588000 | i=1/2
[  404.331142] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12704 | 
buf=0x31,0xa0,0x84,0x08
[  404.435125] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1589718 | i=1/2
[  404.435131] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12718 | 
buf=0x31,0xae,0x84,0x08
[  404.539137] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1589718 | i=1/2
[  404.539143] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12718 | 
buf=0x31,0xae,0x84,0x08
[  404.643165] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1586282 | i=1/2
[  404.643170] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12690 | 
buf=0x31,0x92,0x84,0x08
[  404.747151] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1586282 | i=1/2
[  404.747156] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12690 | 
buf=0x31,0x92,0x84,0x08
[  404.851275] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1591436 | i=1/2
[  404.851282] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12731 | 
buf=0x31,0xbb,0x84,0x08
[  404.955158] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1591436 | i=1/2
[  404.955164] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12731 | 
buf=0x31,0xbb,0x84,0x08
[  405.059152] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1584564 | i=1/2
[  405.059158] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12677 | 
buf=0x31,0x85,0x84,0x08
[  405.163158] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1584564 | i=1/2
[  405.163164] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12677 | 
buf=0x31,0x85,0x84,0x08
[  405.267160] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1593154 | i=1/2
[  405.267166] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12745 | 
buf=0x31,0xc9,0x84,0x08
[  405.371163] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1593154 | i=1/2
[  405.371169] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12745 | 
buf=0x31,0xc9,0x84,0x08
[  405.475149] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1582846 | i=1/2
[  405.475154] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12663 | 
buf=0x31,0x77,0x84,0x08
[  405.579099] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1582846 | i=1/2
[  405.579102] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12663 | 
buf=0x31,0x77,0x84,0x08
[  405.653362] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  405.726659] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  405.726734] dmxdev: dvb_dvr_open: dvb_dvr_open
[  405.850457] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  405.850703] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1122620 | i=0/2
[  405.850709] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8981 | 
buf=0x23,0x15,0x84,0x18
[  405.850861] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  405.955175] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1122620 | i=0/2
[  405.955181] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8981 | 
buf=0x23,0x15,0x84,0x18
[  406.059186] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1124338 | i=0/2
[  406.059191] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8995 | 
buf=0x23,0x23,0x84,0x18
[  406.163188] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1124338 | i=0/2
[  406.163194] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8995 | 
buf=0x23,0x23,0x84,0x18
[  406.267214] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1120902 | i=0/2
[  406.267220] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8967 | 
buf=0x23,0x07,0x84,0x18
[  406.371187] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1120902 | i=0/2
[  406.371193] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8967 | 
buf=0x23,0x07,0x84,0x18
[  406.475204] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1126056 | i=0/2
[  406.475210] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9008 | 
buf=0x23,0x30,0x84,0x18
[  406.579193] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1126056 | i=0/2
[  406.579199] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9008 | 
buf=0x23,0x30,0x84,0x18
[  406.683114] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1119184 | i=0/2
[  406.683118] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8953 | 
buf=0x22,0xf9,0x84,0x18
[  406.787207] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1119184 | i=0/2
[  406.787213] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8953 | 
buf=0x22,0xf9,0x84,0x18
[  406.891125] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1127774 | i=0/2
[  406.891130] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9022 | 
buf=0x23,0x3e,0x84,0x18
[  406.995139] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1127774 | i=0/2
[  406.995145] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9022 | 
buf=0x23,0x3e,0x84,0x18
[  407.103199] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1117466 | i=0/2
[  407.103206] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8940 | 
buf=0x22,0xec,0x84,0x18
[  407.207215] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1117466 | i=0/2
[  407.207222] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8940 | 
buf=0x22,0xec,0x84,0x18
[  407.311213] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1129492 | i=0/2
[  407.311219] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9036 | 
buf=0x23,0x4c,0x84,0x18
[  407.415214] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1129492 | i=0/2
[  407.415219] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9036 | 
buf=0x23,0x4c,0x84,0x18
[  407.519214] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1115748 | i=0/2
[  407.519220] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8926 | 
buf=0x22,0xde,0x84,0x18
[  407.623208] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1115748 | i=0/2
[  407.623214] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=8926 | 
buf=0x22,0xde,0x84,0x18
[  407.727172] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1131210 | i=0/2
[  407.727178] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9050 | 
buf=0x23,0x5a,0x84,0x18
[  407.831218] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1131210 | i=0/2
[  407.831221] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9050 | 
buf=0x23,0x5a,0x84,0x18
[  407.837287] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  407.910619] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  407.910708] dmxdev: dvb_dvr_open: dvb_dvr_open
[  408.034509] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  408.034767] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2054000 | i=1/2
[  408.034774] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16432 | 
buf=0x40,0x30,0x84,0x08
[  408.034987] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  408.139249] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2054000 | i=1/2
[  408.139255] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16432 | 
buf=0x40,0x30,0x84,0x08
[  408.243238] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2055718 | i=1/2
[  408.243244] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16446 | 
buf=0x40,0x3e,0x84,0x08
[  408.347223] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2055718 | i=1/2
[  408.347228] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16446 | 
buf=0x40,0x3e,0x84,0x08
[  408.451241] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2052282 | i=1/2
[  408.451247] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16418 | 
buf=0x40,0x22,0x84,0x08
[  408.555251] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2052282 | i=1/2
[  408.555257] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16418 | 
buf=0x40,0x22,0x84,0x08
[  408.659246] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2057436 | i=1/2
[  408.659252] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16459 | 
buf=0x40,0x4b,0x84,0x08
[  408.767200] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2057436 | i=1/2
[  408.767203] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16459 | 
buf=0x40,0x4b,0x84,0x08
[  408.871244] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2050564 | i=1/2
[  408.871250] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16405 | 
buf=0x40,0x15,0x84,0x08
[  408.975254] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2050564 | i=1/2
[  408.975259] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16405 | 
buf=0x40,0x15,0x84,0x08
[  409.079260] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2059154 | i=1/2
[  409.079266] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16473 | 
buf=0x40,0x59,0x84,0x08
[  409.183290] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2059154 | i=1/2
[  409.183296] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16473 | 
buf=0x40,0x59,0x84,0x08
[  409.287269] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2048846 | i=1/2
[  409.287275] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16391 | 
buf=0x40,0x07,0x84,0x08
[  409.391258] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2048846 | i=1/2
[  409.391264] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16391 | 
buf=0x40,0x07,0x84,0x08
[  409.495226] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2060872 | i=1/2
[  409.495232] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16487 | 
buf=0x40,0x67,0x84,0x08
[  409.599270] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2060872 | i=1/2
[  409.599276] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16487 | 
buf=0x40,0x67,0x84,0x08
[  409.707205] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2047128 | i=1/2
[  409.707211] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16377 | 
buf=0x3f,0xf9,0x84,0x08
[  409.811270] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2047128 | i=1/2
[  409.811275] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16377 | 
buf=0x3f,0xf9,0x84,0x08
[  409.915268] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2062590 | i=1/2
[  409.915274] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16501 | 
buf=0x40,0x75,0x84,0x08
[  410.019278] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2062590 | i=1/2
[  410.019284] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16501 | 
buf=0x40,0x75,0x84,0x08
[  410.123276] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2045410 | i=1/2
[  410.123282] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16363 | 
buf=0x3f,0xeb,0x84,0x08
[  410.227270] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2045410 | i=1/2
[  410.227276] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16363 | 
buf=0x3f,0xeb,0x84,0x08
[  410.331290] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2064308 | i=1/2
[  410.331296] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16514 | 
buf=0x40,0x82,0x84,0x08
[  410.435287] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2064308 | i=1/2
[  410.435293] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16514 | 
buf=0x40,0x82,0x84,0x08
[  410.539292] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2043692 | i=1/2
[  410.539298] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16350 | 
buf=0x3f,0xde,0x84,0x08
[  410.643297] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2043692 | i=1/2
[  410.643303] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16350 | 
buf=0x3f,0xde,0x84,0x08
[  410.747298] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2066026 | i=1/2
[  410.747304] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16528 | 
buf=0x40,0x90,0x84,0x08
[  410.851316] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2066026 | i=1/2
[  410.851322] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16528 | 
buf=0x40,0x90,0x84,0x08
[  410.955300] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2041974 | i=1/2
[  410.955306] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16336 | 
buf=0x3f,0xd0,0x84,0x08
[  411.059362] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2041974 | i=1/2
[  411.059369] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16336 | 
buf=0x3f,0xd0,0x84,0x08
[  411.163307] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2067744 | i=1/2
[  411.163314] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16542 | 
buf=0x40,0x9e,0x84,0x08
[  411.267303] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2067744 | i=1/2
[  411.267309] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16542 | 
buf=0x40,0x9e,0x84,0x08
[  411.371327] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2040256 | i=1/2
[  411.371333] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16322 | 
buf=0x3f,0xc2,0x84,0x08
[  411.475309] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2040256 | i=1/2
[  411.475315] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16322 | 
buf=0x3f,0xc2,0x84,0x08
[  411.683323] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2054000 | i=1/2
[  411.683326] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16432 | 
buf=0x40,0x30,0x84,0x08
[  412.803337] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2054000 | i=1/2
[  412.803344] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16432 | 
buf=0x40,0x30,0x84,0x08
[  413.923427] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=2055718 | i=1/2
[  413.923433] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=16446 | 
buf=0x40,0x3e,0x84,0x08
[  413.933292] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.006903] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  414.006979] dmxdev: dvb_dvr_open: dvb_dvr_open
[  414.134784] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  414.135025] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.135141] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1779000 | i=1/2
[  414.135148] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14232 | 
buf=0x37,0x98,0x84,0x08
[  414.180033] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.190194] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.200402] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.210556] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.220739] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.230982] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.241179] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.251329] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.261548] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.271727] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.281899] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.292067] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.302233] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.312404] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.322570] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.327465] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.337622] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.347749] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.357894] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.368046] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.378253] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.388364] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.398567] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.408776] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.418984] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.429074] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.439161] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.445419] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.455540] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.465705] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.475884] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.486058] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.496196] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.506373] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.516554] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.526721] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.536896] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.547011] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.547645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.557819] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.568000] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.578178] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.588360] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.598564] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.608665] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.618811] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.629013] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.639179] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.649328] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.659554] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.669668] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.679857] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.690079] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.700301] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.710472] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.720641] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.730881] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.741085] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.751267] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.759969] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.770125] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.780304] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.790482] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.800663] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.810868] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.821036] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.831140] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.841305] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.851496] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.861618] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.871808] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.882032] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.892248] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.902452] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.912652] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.922856] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.932968] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.943041] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.953176] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.954602] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.964774] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.974942] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.985187] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  414.995348] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.005499] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.015636] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.021418] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.031562] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.041713] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.051871] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.052795] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.062889] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.073108] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.083208] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.093356] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.103556] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.113718] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.123827] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.133931] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.139303] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.149452] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.159538] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.169684] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.179844] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.190004] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.200218] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.200294] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.210497] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.220714] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.230824] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.237753] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.247959] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.258131] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.268268] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.278419] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.288638] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.288762] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.298920] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.309065] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.319155] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.329361] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.339482] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.349694] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.359910] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.370126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.380298] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.390522] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.400741] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.402838] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.413023] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.414634] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.424790] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.434968] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.445135] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.455285] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.465465] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.465646] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.475795] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.485956] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.496128] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.503006] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.513157] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.523255] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.533424] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.543591] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.553762] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.563911] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.574130] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.584338] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.594543] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.604758] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.614980] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.625184] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.635286] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.645496] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.655717] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.665881] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.676085] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.686293] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.696502] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.706710] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.716864] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.727025] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.737177] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.747270] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.757421] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.766510] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.776678] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.786839] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.797071] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.807176] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.817376] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.827538] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.837716] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.847878] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.858049] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.868241] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.878426] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.884450] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.894608] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.904833] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.915009] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.925156] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.935302] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.945444] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.955659] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.965810] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.976014] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.986230] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  415.996405] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.006566] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.016730] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.026938] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.037143] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.047250] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.057414] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.067629] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.077791] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.079029] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.089181] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.099330] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.100755] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.111005] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.121256] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.131418] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.141694] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.151872] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.162049] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.172150] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.182310] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.192487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.202720] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.212898] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.223058] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.233277] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.243388] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.253534] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.263681] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.273840] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.284005] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.294168] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.304386] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.314804] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.324950] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.335097] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.345302] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.355477] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.365685] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.366048] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.376279] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.386449] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.396654] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.406854] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.417091] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.427186] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.437395] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.447557] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.457716] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.460480] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.470645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.472270] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.482454] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.492567] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.502765] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.512982] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.523076] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.533278] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.543384] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.553601] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.558877] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.569116] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.579273] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.580444] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.590666] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.600880] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.611041] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.621252] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.631406] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.641612] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.651818] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.662023] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.672232] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.674810] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.685025] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.695164] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.766976] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  416.767053] dmxdev: dvb_dvr_open: dvb_dvr_open
[  416.890808] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  416.891045] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.891110] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1204000 | i=0/2
[  416.891116] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9632 | 
buf=0x25,0xa0,0x84,0x18
[  416.924493] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.934710] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.944927] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.955087] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.965232] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.975382] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.985586] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  416.995875] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.006154] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.016381] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.026543] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.036757] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.046997] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.057143] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.067238] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.077457] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.087634] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.097862] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.108011] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.118186] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.128351] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.138529] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.148693] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.158871] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.169079] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.179256] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.189424] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.199654] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.209830] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.219991] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.230166] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.240344] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.250519] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.260684] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.270843] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.281007] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.291170] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.301319] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.311500] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.321673] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.331834] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.341994] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.352155] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.362330] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.372427] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.382598] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.392809] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.403060] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.413161] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.423258] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.433452] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.443613] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.453815] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.464032] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.474259] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.484475] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.494666] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.504883] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.515046] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.525252] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.535367] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.545505] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.555700] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.565903] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.576120] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.586336] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.596556] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.606667] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.616876] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.627063] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.637265] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.647427] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.657644] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.667859] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.677951] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.688140] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.698352] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.708456] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.718588] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.728678] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.738767] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.748904] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.759059] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.769214] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.779383] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.789588] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.799794] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.809999] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.820208] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.830417] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.840625] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.850831] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.860986] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.871139] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.881344] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.891508] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.901717] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.911922] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.922127] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.932337] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.942568] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.952777] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.962999] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.973218] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.983383] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  417.993573] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.003752] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.013921] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.024099] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.034270] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.044431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.054591] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.064759] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.074954] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.085106] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.095234] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.105467] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.115646] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.125824] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.135985] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.146163] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.156262] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.166437] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.176657] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.186874] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.196980] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.207179] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.217383] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.227588] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.237688] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.247883] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.258087] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.268306] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.278514] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.288722] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.298960] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.309050] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.319191] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.329394] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.339609] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.349770] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.359938] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.370106] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.380284] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.390463] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.400640] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.410818] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.421051] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.431220] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.441440] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.451655] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.461820] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.471979] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.482151] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.492325] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.502546] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.512755] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.522922] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.533105] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.543201] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.553405] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.563581] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.573746] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.583893] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.594110] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.604326] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.614534] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.624743] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.634907] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.644997] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.655084] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.665290] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.675526] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.685701] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.695916] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.706132] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.716296] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.726456] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.736615] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.746816] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.756980] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.767125] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.777230] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.787399] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.797545] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.807761] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.817967] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.828184] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.838400] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.848620] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.858788] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.868996] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.879161] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.889364] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.899536] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.909753] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.919970] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.930132] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.940297] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.950534] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.960753] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.970919] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.981163] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  418.991327] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.001423] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.011526] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.021632] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.031770] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.041980] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.052197] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.062414] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.072576] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.082791] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.092940] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.103048] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.113216] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.123342] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.133565] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.143770] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.153948] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.164167] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.174346] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.184524] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.194702] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.204917] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.215047] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.225212] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.235377] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.245597] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.255758] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.265910] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.276125] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.286287] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.296468] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.306648] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.317275] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.327456] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.337679] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.347894] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.358106] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.368236] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.378368] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.388605] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.398840] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.409011] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.419099] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.429303] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.439471] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.449705] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.459880] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.470107] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.480281] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.490426] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.500642] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.510873] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.521048] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.531227] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.541447] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.551664] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.561891] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.571994] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.582130] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.592285] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.602488] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.612591] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.622744] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.632843] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.643058] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.653238] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  419.663378] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  420.972366] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  420.982468] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  420.992610] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.002824] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.012976] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.023137] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.033348] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.043468] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.053632] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.063780] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.073947] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.084112] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.094283] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.104402] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.114580] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.124746] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.134913] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.145084] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.155182] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.165335] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.175443] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.185660] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.195876] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.206036] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.216145] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.226350] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.236550] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.246745] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.256964] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.267142] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.277367] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.287488] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.297663] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.307837] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.318052] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.328232] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.338455] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.348564] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.358713] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.368934] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.379146] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.389315] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.399480] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.409631] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.419792] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.430004] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.440209] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.450368] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.460531] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.470681] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.480835] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.490981] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.501147] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.511241] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.521447] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.531613] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.541826] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.551988] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.562121] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.572450] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.582547] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.592687] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.602888] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.613047] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.623193] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.633416] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.643564] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.653778] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.663936] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.674142] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.684306] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.694507] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.704671] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.714819] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.724978] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.735178] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.745330] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.755433] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.765537] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.775682] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.785855] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.796001] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.806111] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.816271] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.826431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.836594] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.846754] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.856917] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.867068] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.877213] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.887328] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.897544] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.907760] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.917975] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.928144] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.938359] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.948566] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.958821] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.969028] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.979177] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.989324] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  421.999469] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.009666] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.019877] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.030029] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.040190] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.050405] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.060556] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.070758] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.080988] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.091114] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.101268] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.111417] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.121619] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.131839] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.142058] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.152263] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.162472] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.172678] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.182882] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.193091] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.203237] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.213438] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.223546] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.233749] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.243965] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.254193] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.264411] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.274630] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.284850] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.294959] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.305163] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.315327] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.325533] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.335748] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.345965] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.356174] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.366381] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.376588] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.386739] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.396946] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.407164] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.417369] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.427524] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.437732] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.447937] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.458143] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.468352] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.478560] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.488770] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.498931] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.509140] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.519289] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.529510] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.539716] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.549863] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.560066] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.570274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.580487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.590693] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.600901] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.611126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.621222] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.631369] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.641577] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.651725] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.661886] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.672047] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.682259] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.692481] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.702688] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.712903] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.723133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.733290] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.743455] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.753674] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.763890] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.774102] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.784319] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.794535] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.804697] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.814912] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.825128] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.835230] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.845437] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.855597] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.865827] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.876042] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.886255] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.896421] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.906636] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.916855] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.927096] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.937299] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.947459] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.957674] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.967890] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.978013] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.988223] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  422.998505] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.008749] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.018914] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.029126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.039319] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.049538] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.059744] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.069912] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.080080] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.090251] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.100417] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.110581] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.120747] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.130916] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.141037] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.151154] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.161322] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.171475] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.181682] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.191849] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.202021] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.212188] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.222356] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.232523] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.242748] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.252871] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.263038] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.273275] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.283391] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.293544] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.303722] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.313908] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.324142] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.334323] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.344484] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.354703] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.364925] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.375133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.385339] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.395504] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.405710] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.415927] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.426164] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.436382] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.446613] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.456705] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.466913] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.477073] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.487200] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.497348] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.507511] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.517663] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.527892] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.538122] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.548337] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.558571] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.568735] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.578940] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.589058] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.599101] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.609292] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.619389] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.629522] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.639659] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.649756] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.659859] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.670015] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.680216] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.690432] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.700648] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.710869] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.721089] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.731202] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.741372] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.751524] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.761740] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.771955] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.782122] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.792325] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.802480] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.812684] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.822908] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.833134] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.843291] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.853506] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.863679] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.873909] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.884078] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.894179] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.904264] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.914456] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.924562] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.934711] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.944807] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.954976] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.965135] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.975284] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.985515] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  423.995688] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.005810] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.015901] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.026058] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.036271] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.046427] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.056576] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.066698] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.076848] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.086962] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.097073] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.107175] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.117319] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.127423] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.137582] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.147688] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.157798] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.167959] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.178137] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.188355] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.198564] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.208706] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.218803] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.228921] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.239094] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.249302] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.259516] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.269608] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.279706] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.289856] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.300057] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.310270] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.320418] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.330591] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.340775] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.350926] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.361145] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.371254] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.381403] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.391569] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.401725] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.411903] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.422081] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.432242] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.442365] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.452532] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.462700] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.472883] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.483060] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.493263] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.503368] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.513532] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.523710] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.533929] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.544134] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.554295] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.564518] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.574717] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.584892] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.595126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.605279] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.615418] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.625623] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.635827] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.645985] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.656131] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.666336] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.676552] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.686769] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.696865] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.707054] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.717302] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.727451] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.737552] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.747667] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.757830] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.768045] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.778261] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.788480] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.798695] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.808861] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.819024] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.829126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.839235] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.849390] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.859494] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.869696] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.879900] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.890096] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.900305] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.910509] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.920728] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.930944] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.941093] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.951236] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.961444] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.971536] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.981736] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  424.991908] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.002137] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.012294] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.022406] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.032553] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.042654] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.052872] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.063025] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.073230] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.083390] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.093605] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.103821] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.114034] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.124249] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.134462] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.144678] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.154868] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.164963] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.175128] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.185337] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.195487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.205637] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.215852] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.226010] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.236171] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.246331] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.256509] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.266687] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.276915] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.287160] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.297323] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.307484] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.317716] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.327830] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.338021] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.348237] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.358432] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.368647] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.378862] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.389081] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.399253] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.409473] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.419640] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.429846] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.440064] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.450267] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.460375] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.470579] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.480788] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.490954] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.501099] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.511251] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.521459] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.531645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.541793] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.552008] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.562183] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.572343] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.582574] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.592793] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.603024] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.613239] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.623399] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.633614] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.643830] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.654046] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.664262] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.674478] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.684693] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.694910] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.705126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.715257] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.725477] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.735650] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.745866] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.756082] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.766251] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.776445] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.786679] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.796797] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.806963] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.817114] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.827257] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.837443] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.847537] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  425.857628] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.075389] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  438.075499] dmxdev: dvb_dvr_open: dvb_dvr_open
[  438.199380] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  438.199626] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1549000 | i=1/2
[  438.199633] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=12392 | 
buf=0x30,0x68,0x84,0x08
[  438.200916] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.235434] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.245658] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.255822] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.266024] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.276221] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.286432] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.296607] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.306807] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.317025] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.327242] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.337462] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.347620] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.357825] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.368007] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.378171] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.388349] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.398528] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.408709] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.418874] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.429053] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.439231] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.449409] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.459590] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.469754] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.479901] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.490107] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.500315] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.510520] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.520726] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.530932] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.541138] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.551344] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.561549] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.571699] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.581903] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.592107] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.602313] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.612519] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.622721] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.632927] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.643133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.653339] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.663558] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.673764] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.683916] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.694120] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.704325] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.714535] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.724744] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.734900] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.745106] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.755314] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.765520] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.775670] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.785875] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.796025] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.806229] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.816435] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.826641] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.836847] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.847051] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.857220] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.867436] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.877672] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.887817] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.897963] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.908185] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.918401] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.928545] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.938757] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.948860] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.958958] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.969156] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.979359] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.989575] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  438.999737] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.009840] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.019944] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.030155] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.040360] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.050515] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.060665] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.070822] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.080988] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.091156] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.101304] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.111535] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.121682] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.131790] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.142006] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.152120] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.162339] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.172552] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.182727] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.192890] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.203065] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.213232] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.223407] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.233585] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.243689] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.253852] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.264018] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.335563] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  439.335640] dmxdev: dvb_dvr_open: dvb_dvr_open
[  439.459356] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  439.459609] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1204000 | i=0/2
[  439.459616] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9632 | 
buf=0x25,0xa0,0x84,0x18
[  439.459620] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.485720] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.495869] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.506022] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.516189] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.526356] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.536579] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.546746] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.556901] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.567160] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.577395] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.587575] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.597751] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.607849] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.618007] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.628173] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.638392] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.648543] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.658746] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.668914] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.679082] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.689200] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.699364] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.709571] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.719719] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.729823] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.739979] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.750133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.760282] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.770452] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.780601] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.790764] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.800931] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.811098] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.821286] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.831450] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.841573] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.851666] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.861819] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.871975] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.882128] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.892223] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.902371] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.912520] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.922622] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.932770] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.942891] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.953044] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.963213] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.973332] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.983518] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  439.993725] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.003825] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.013978] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.024152] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.034307] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.044459] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.054611] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.064760] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.074986] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.085190] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.095343] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.105430] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.115583] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.125789] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.135955] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.146161] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.156377] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.166607] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.176826] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.187058] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.197277] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.207524] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.217727] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.227890] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.238096] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.248312] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.258528] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.268745] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.278958] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.289174] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.299390] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.309609] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.319769] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.329991] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.340207] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.350423] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.360639] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.370852] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.381068] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.391298] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.401517] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.411677] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.421897] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.432057] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.442261] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.452466] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.462670] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.472875] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.483081] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.493250] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.503453] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.513663] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.523816] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.534021] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.544227] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.554436] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.564641] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.574847] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.585054] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.595259] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.605464] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.615642] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.625848] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.635998] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.646225] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.656432] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.666637] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.676846] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.687051] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.697210] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.707430] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.717514] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.727594] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.737794] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.747897] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.757995] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.768171] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.778353] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.788568] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.798747] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.808878] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.819060] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.829238] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.839453] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.849669] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.859774] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.869931] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.880096] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.890312] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.900474] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.910689] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.920905] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.931067] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.941283] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.951499] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.961681] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.971785] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.981938] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  440.992109] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.002313] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.012528] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.022690] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.032906] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.043129] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.053301] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.063547] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.073696] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.083871] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.094074] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.104236] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.114451] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.124667] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.134883] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.145049] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.155232] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.165410] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.175602] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.185807] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.195973] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.206179] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.216272] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.226429] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.236539] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.246743] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.256965] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.267118] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.277267] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.287469] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.297688] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.307857] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.318047] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.328210] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.338425] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.348557] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.358703] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.368927] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.379220] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.389404] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.399642] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.409856] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.420040] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.430264] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.440479] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.450640] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.460873] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.471104] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.481266] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.491496] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.501765] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.511869] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.522033] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.532220] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.542405] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.552572] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.562747] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.572904] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.583051] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.593227] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.603340] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.613502] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.623689] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.633883] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.644045] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.654206] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.664366] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.674595] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.684748] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.694976] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.705165] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.715403] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.725618] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.735745] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.745910] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.756039] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.766255] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.776415] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.786579] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.796881] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.807045] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.817264] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.827497] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.837649] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.847809] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.858011] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.868117] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.878274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.888423] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.898578] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.908744] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.918912] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.929087] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.939253] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.949461] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.959640] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.969789] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.979886] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  441.990035] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.000123] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.010271] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.020479] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.030688] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.040926] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.051101] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.061207] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.071349] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.081501] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.091685] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.101836] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.111990] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.122145] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.132303] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.142507] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.152712] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.162925] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.173104] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.183281] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.193552] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.203719] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.213935] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.224116] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.234345] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.244510] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.254740] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.264941] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.275223] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.285381] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.295605] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.305810] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.315961] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.326165] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.336379] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.346537] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.356704] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.366873] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.377077] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.387245] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.397398] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.407516] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.417724] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.427819] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.437985] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.448156] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.458310] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.468405] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.478570] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.488774] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.498922] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.509133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.519283] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.529387] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.539605] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.549772] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.559920] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.570074] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.580167] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.590249] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.600384] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.610605] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.620784] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.630958] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.641135] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.651267] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.661445] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.671550] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.681744] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.691928] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.702090] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.712305] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.722535] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.732713] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.742891] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.753073] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.763251] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.773428] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.783612] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.793791] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.803919] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.814094] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.824268] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.834464] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.844622] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.854778] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.864954] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.875132] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.885349] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.895597] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.905763] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.915866] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.926064] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.936225] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.946374] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.956541] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.966739] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.976949] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.987175] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  442.997285] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.007400] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.017544] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.027718] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.037943] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.048094] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.058243] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.068399] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.078608] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.088852] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.099063] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.109282] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.119442] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.129605] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.139764] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.149920] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.160033] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.170234] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.180395] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.190551] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.200711] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.210925] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.221037] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.231168] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.241325] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.251479] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.261697] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.271861] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.282025] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.292122] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.302285] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.312468] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.322697] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.332879] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.342984] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.353160] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.363333] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.373511] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.383678] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.393865] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.403970] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.414143] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.424322] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.434492] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.444668] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.454846] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.465026] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.475186] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.485367] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.495536] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.505687] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.515790] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.525951] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.536043] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.546271] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.556431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.566551] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.576717] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.586896] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.597063] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.607238] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.617411] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.627615] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.637780] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.647939] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.658169] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.668386] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.678614] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.688828] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.699060] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.709263] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.719490] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.729709] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.739869] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.750034] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.760249] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.770465] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.780695] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.790922] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.801137] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.811367] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.821585] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.831730] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.841893] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.852053] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.862274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.872489] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.882720] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.892878] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.903078] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.913299] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.923518] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.933734] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.943895] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.954071] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.964239] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.974444] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.984650] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  443.994871] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.005025] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.015244] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.025450] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.035682] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.045890] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.056039] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.066243] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.076396] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.086634] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.096803] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.106932] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.117045] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.127223] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.137404] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.147579] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.157719] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.167847] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.178012] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.188133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.198309] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.208473] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.218573] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.228734] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.238910] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.249092] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.259267] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.269445] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.279700] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.289853] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.300004] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.310220] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.320437] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.330610] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.340774] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.350978] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.361197] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.371417] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.381588] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.391688] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.401906] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.412072] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.422290] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.432492] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.442704] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.452809] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.462957] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.473158] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.483325] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.493425] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.503648] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.513797] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.523956] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.534166] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.544336] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.554564] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.564781] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.574997] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.585213] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.595428] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.605590] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.615752] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.625971] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.636148] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.646326] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.656539] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.666705] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.676865] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.687041] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.697245] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.707477] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.717683] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.727843] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.738047] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.748263] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.758481] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.768683] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.778842] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.789019] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.799249] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.809431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.819609] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.829809] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.839957] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.850125] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.860293] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.870500] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.880669] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.890838] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.901008] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.911229] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.921397] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.931564] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.941710] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.951820] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.961990] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.972161] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.982379] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  444.992478] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.002572] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.012658] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.022860] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.033071] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.043281] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.053492] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.063724] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.073928] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.084013] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.094235] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.104415] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.114630] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.124834] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.135051] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.145302] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.155421] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.165570] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.175781] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.186000] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.196100] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.206247] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.275624] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  445.275726] dmxdev: dvb_dvr_open: dvb_dvr_open
[  445.399493] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  445.399751] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1720000 | i=1/2
[  445.399760] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=13760 | 
buf=0x35,0xc0,0x84,0x08
[  445.400801] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.416955] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.427152] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.428767] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.438972] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.440645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.450821] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.452386] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.462546] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.472749] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.474011] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.484172] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.485805] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.495949] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.497698] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.507840] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.518060] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.519229] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.529389] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.531034] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.541248] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.542866] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.553022] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.554614] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.564767] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.574936] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.576207] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.586360] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.587986] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.598138] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.599781] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.609937] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.611710] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.621921] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.632089] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.633297] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.643504] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.645070] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.655280] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.656913] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.667137] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.668693] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.678851] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.689059] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.690261] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.700467] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.702057] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.712221] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.722429] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.725703] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.735856] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.746011] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.747274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.757430] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.767636] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.777879] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.788033] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.798241] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.808447] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.818656] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.828863] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.839068] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.849274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.849448] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.859689] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.869893] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.880048] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.890253] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.900458] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.910664] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.920869] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.931075] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.941280] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.951487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.951795] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.962006] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.972171] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.982387] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  445.992498] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.002641] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.012792] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.022959] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.033110] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.043259] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.044134] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.054340] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.064490] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.074658] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.084808] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.094978] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.105148] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.115371] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.125542] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.135714] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.145880] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.155974] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.156142] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.166289] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.176438] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.186605] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.196810] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.206978] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.217204] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.227368] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.237536] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.247718] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.257873] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.258482] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.268636] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.270269] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.280425] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.282068] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.292168] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.302316] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.303718] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.313875] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.315486] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.325645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.335791] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.337007] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.347211] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.348965] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.359118] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.369297] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.379474] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.389692] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.399853] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.410056] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.420226] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.430439] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.440655] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.450868] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.451086] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.461288] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.471504] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.476748] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.486984] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.497145] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.498320] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.508527] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.510116] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.520277] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.521915] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.532083] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.533707] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.543858] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.545506] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.555732] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.557302] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.567513] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.569148] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.579358] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.589564] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.590720] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.600927] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.602515] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.612722] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.614311] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.624532] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.626107] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.636266] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.637906] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.648057] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.658282] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.668498] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.678714] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.688930] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.699154] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.709335] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.719539] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.729747] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.739911] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.740033] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.750188] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.751884] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.762092] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.772273] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.782426] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.792576] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.802739] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.812907] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.823065] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.833229] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.843385] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.853547] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.854157] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.864322] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.874485] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.884645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.894803] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.904966] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.915129] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.925288] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.935447] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.945597] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.955760] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.956383] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.966550] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.976710] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.986869] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  446.997027] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.007192] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.017366] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.027480] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.037611] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.047763] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.057978] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.068127] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.078287] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.088500] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.098659] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.108817] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.118976] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.129135] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.139296] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.149457] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.159615] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.169822] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.179985] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.190145] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.200279] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.210537] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.220771] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.231047] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.241207] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.241358] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.251520] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.261743] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.331753] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  447.331830] dmxdev: dvb_dvr_open: dvb_dvr_open
[  447.455521] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  447.455786] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.455823] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1204000 | i=0/2
[  447.455830] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9632 | 
buf=0x25,0xa0,0x84,0x18
[  447.475408] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.485568] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.495748] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.505905] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.516054] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.526260] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.536476] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.546690] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.556856] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.567005] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.577213] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.587443] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.597577] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.607803] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.618000] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.628128] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.638306] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.648486] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.658663] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.668824] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.679006] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.689225] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.699413] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.709595] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.719839] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.730003] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.740132] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.750302] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.760466] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.770593] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.780776] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.790954] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.801133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.811314] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.821492] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.831621] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.841799] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.851913] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.862064] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.872188] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.882346] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.892516] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.902685] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.912852] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.923023] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.933190] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.943355] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.953525] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.963692] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.973815] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.983905] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  447.994073] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.004225] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.014324] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.024485] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.034660] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.044838] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.055013] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.065232] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.075414] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.085641] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.095727] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.105935] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.116040] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.126154] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.136278] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.146472] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.156666] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.166833] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.177014] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.187193] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.197371] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.207549] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.217767] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.227928] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.238019] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.248162] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.258349] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.268566] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.278772] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.288991] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.299210] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.309444] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.319674] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.329866] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.339974] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.350134] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.360271] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.370427] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.380588] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.390804] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.400965] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.411125] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.421236] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.431398] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.441562] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.451742] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.461892] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.472002] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.482159] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.492335] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.502502] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.512663] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.522842] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.533060] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.543174] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.553339] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.563502] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.573666] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.583880] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.594087] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.604256] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.614401] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.624575] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.634780] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.644946] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.655092] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.665252] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.675366] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.685586] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.695770] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.705871] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.716003] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.726207] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.736425] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.746659] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.756821] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.766995] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.777215] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.787393] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.797558] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.807756] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.817960] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.828120] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.838282] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.848497] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.858728] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.868944] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.879113] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.889328] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.899545] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.909765] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.919929] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.930139] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.940311] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.950526] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.960742] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.970951] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.981118] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  448.991265] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.001472] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.011630] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.021841] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.032002] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.042208] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.052431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.062645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.072851] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.083064] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.093230] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.103391] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.113553] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.123713] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.133899] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.144010] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.154176] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.164291] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.174456] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.184624] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.194793] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.204960] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.215182] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.225351] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.235518] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.245668] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.255834] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.265988] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.276081] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.286251] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.296401] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.306565] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.316729] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.326897] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.336982] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.347119] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.357326] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.367487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.377652] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.387824] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.398008] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.408167] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.418384] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.428600] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.438828] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.449044] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.459260] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.469476] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.479694] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.489914] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.500059] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.510274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.520492] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.530708] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.540921] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.551137] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.561354] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.571571] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.581787] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.591947] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.602167] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.612343] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.622533] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.632748] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.642962] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.653124] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.663272] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.673428] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.683645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.693858] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.704008] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.714153] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.724304] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.734509] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.744724] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.754941] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.765150] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.775371] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.785524] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.795766] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.805981] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.816144] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.826362] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.836593] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.846825] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.857059] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.867279] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.877448] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.887612] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.897830] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.907922] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.918086] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.928192] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.938421] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.948636] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.958842] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.968921] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.979114] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.989208] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  449.999352] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.009560] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.019795] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.030004] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.040158] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.050367] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.060520] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.070729] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.080945] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.091162] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.101365] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.111468] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.121670] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.131902] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.142106] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.152271] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.162488] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.172704] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.182887] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.193039] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.203217] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.213431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.223611] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.233771] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.243908] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.254056] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.264160] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.274324] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.284484] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.294695] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.304876] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.315054] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.325233] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.335408] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.345596] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.355726] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.365917] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.376025] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.386172] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.396288] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.406465] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.416644] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.426827] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.436995] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.447163] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.457342] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.467579] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.477784] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.487953] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.498176] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.508294] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.518515] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.528693] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.538881] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.549087] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.559267] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.569441] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.579592] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.589797] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.599957] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.610164] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.620334] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.630562] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.640740] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.650914] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.661150] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.671330] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.681512] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.691741] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.701945] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.712074] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.722296] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.732499] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.742678] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.752893] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.763120] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.773296] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.783478] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.793661] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.803911] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.814062] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.824176] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.834321] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.844487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.854655] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.864771] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.874993] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.885191] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.895357] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.905530] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.915762] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.925964] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.936144] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.946360] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.956539] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.966717] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.976846] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.987079] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  450.997251] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.007397] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.017534] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.027748] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.037939] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.048052] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.058258] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.068419] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.078642] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.088862] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.099029] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.109197] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.119364] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.129531] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.139700] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.149868] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.160013] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.170162] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.180256] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.190424] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.200575] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.210678] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.220820] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.231081] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.241250] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.251463] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.261683] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.271926] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.282132] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.292297] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.302513] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.312730] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.322945] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.333151] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.343382] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.353487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.363690] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.373910] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.384069] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.394289] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.404505] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.414739] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.424956] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.435186] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.445393] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.455556] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.465721] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.475939] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.486153] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.496299] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.506455] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.516671] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.526873] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.537029] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.547234] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.557392] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.567554] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.577714] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.587891] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.598096] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.608278] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.618479] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.628624] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.638845] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.648995] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.659162] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.669370] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.679538] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.689706] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.699899] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.710150] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.720305] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.730526] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.740732] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.750903] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.761054] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.771224] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.781327] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.791431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.801509] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.811715] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.821863] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.831970] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.842064] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.852189] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.862322] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.872466] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.882681] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.892853] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.902958] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.913122] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.923297] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.933476] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.943658] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.953782] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.963918] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.974085] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.984176] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  451.994345] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.004495] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.014629] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.024795] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.034967] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.045138] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.055305] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.065471] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.075642] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.085813] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.095982] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.106149] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.116246] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.126534] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.136643] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.146776] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.156941] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.167037] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.177133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.187327] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.197431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.207633] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.217837] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.227941] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.238090] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.248254] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.258406] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.268585] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.278749] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.288963] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.299175] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.309392] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.319579] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.329780] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.339972] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.350187] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.360294] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.370509] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.380723] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.390887] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.401047] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.411258] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.421473] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.431639] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.441838] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.451999] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.462090] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.472221] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.482370] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.492507] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.502732] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.512911] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.523085] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.533303] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.543483] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.553648] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.563809] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.574043] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.584148] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.594295] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.604455] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.614620] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.624784] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.634937] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.645098] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.655276] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.665437] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.675562] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.685722] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.695914] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.706063] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.716223] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.726436] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.736605] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.746827] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.756984] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.767202] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.777419] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.787645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.797861] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.808024] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.818235] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.828405] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.838623] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.848839] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.859052] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.869268] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.879487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.889654] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.899908] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.910110] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.920272] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.930428] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.940597] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.950775] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.960954] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.971127] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.981304] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  452.991465] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.001570] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.011683] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.021844] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.031985] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.042191] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.052365] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.062527] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.072645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.082854] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.093066] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.103228] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.113460] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.123691] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.133864] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.144030] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.154241] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.164391] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.174545] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.184715] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.194930] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.205093] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.215310] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.225526] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.235692] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.245910] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.256068] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.266268] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.276431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.286673] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.296888] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.307073] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.317249] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.327421] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.337630] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.347838] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.358065] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.368159] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.378361] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.388513] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.398719] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.408924] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.419019] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.429126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.439214] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.449348] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.459544] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.469782] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.479987] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.490133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.500228] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.510418] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.520637] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.530815] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.540969] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.551135] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.561303] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.571470] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.581635] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.591802] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.601969] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.612124] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.622349] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.632519] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.642684] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.652775] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.662925] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.673129] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.683301] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.693524] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.703633] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.713829] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.723967] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.734189] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.744285] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.754510] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.764716] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.774922] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.785147] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.795364] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.805473] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.815662] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.825809] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.835997] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.846201] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.856359] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.866509] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.876706] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.886857] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.897019] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.907235] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.917388] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.927604] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.937784] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.948004] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.958225] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.968377] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.978620] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.988766] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  453.998932] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.009075] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.019305] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.029472] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.039649] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.049809] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.060016] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.070183] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.080362] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.090582] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.100764] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.110932] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.121111] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.131329] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.141513] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.151696] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.161899] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.171995] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.182155] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.192259] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.202477] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.212640] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.222854] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.233058] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.243223] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.253386] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.263550] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.273769] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.283955] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.294107] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.304338] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.314502] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.324680] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.334780] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.344976] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.355138] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.365301] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.375469] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.385647] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.395816] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.405917] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.416005] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.426165] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.436327] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.446531] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.456650] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.466861] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.477028] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.487168] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.497413] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.507634] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.517841] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.528015] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.538223] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.548377] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.558542] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.568719] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.578898] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.589113] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.599288] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.609449] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.619629] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.629810] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.639973] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.650151] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.660265] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.670415] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.680592] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.690723] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.700901] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.711065] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.721174] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.731264] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.741472] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.751678] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.761876] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.772023] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.782187] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.792352] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.802559] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.812667] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.822861] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.833023] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.843240] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.853404] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.863642] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.873816] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.884004] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.894152] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.904298] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.914513] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.924623] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.934726] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.944877] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.955039] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.965263] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.975441] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.985610] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  454.995773] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.005987] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.016102] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.026302] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.036442] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.046656] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.056872] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.067089] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.077184] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.087333] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.097445] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.107667] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.117879] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.128042] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.138248] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.148419] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.158636] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.168797] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.179009] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.189286] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.199379] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.209521] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.219627] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.229731] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.239879] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.249968] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.260053] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.270185] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.280328] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.290536] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.300697] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.310913] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.321091] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.331271] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.341391] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.351610] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.361778] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.371952] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.382103] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.392196] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.402346] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.412462] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.422691] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.432858] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.443036] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.453241] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.463474] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.473653] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.483878] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.494146] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.504295] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.514409] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.524567] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.534820] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.544972] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.555178] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.565296] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.575478] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.585688] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.595839] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.605990] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.616085] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.626288] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.636592] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.646790] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.657010] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.667159] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.677512] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.687666] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.697816] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.708033] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.718135] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.728226] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.738378] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.748501] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.758715] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.768895] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.779070] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.789280] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.799462] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.809667] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.819847] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.830029] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.840149] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.850314] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.860420] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.870595] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.880756] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.890984] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.901079] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.911294] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.921512] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.931674] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.941889] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.952011] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.962217] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.972391] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.982605] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  455.992754] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.002955] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.013059] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.023258] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.033412] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.043573] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.053787] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.064028] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.074215] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.084367] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.094537] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.104722] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.114924] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.125103] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.135284] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.145467] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.155645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.165822] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.176075] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.186239] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.196395] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.206546] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.216761] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.226877] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.237035] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.247244] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.257451] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.267614] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.277829] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.288003] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.298154] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.308316] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.318411] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.328534] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.338637] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.348846] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.358997] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.369147] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.379308] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.389430] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.399588] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.409794] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.419958] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.430115] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.440262] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.450414] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.460515] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.470664] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.480872] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.491078] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.501234] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.511390] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.521559] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.531721] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.541867] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.552030] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.562188] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.572282] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.582438] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.592608] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.602778] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.612956] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.623131] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.633310] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.643428] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.653597] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.663772] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.673950] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.684054] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.694223] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.704344] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.714521] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.724683] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.734858] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.745018] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.755249] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.765432] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.775543] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.785715] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.795877] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.805970] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.816085] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.826204] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.836343] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.846495] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.856728] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.866919] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  456.935972] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  456.936050] dmxdev: dvb_dvr_open: dvb_dvr_open
[  457.059836] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  457.060140] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1837000 | i=1/2
[  457.060147] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14696 | 
buf=0x39,0x68,0x84,0x08
[  457.060508] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  457.164499] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1837000 | i=1/2
[  457.164505] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14696 | 
buf=0x39,0x68,0x84,0x08
[  457.268514] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1838868 | i=1/2
[  457.268520] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14711 | 
buf=0x39,0x77,0x84,0x08
[  457.372513] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1838868 | i=1/2
[  457.372519] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14711 | 
buf=0x39,0x77,0x84,0x08
[  457.476514] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1835132 | i=1/2
[  457.476520] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14681 | 
buf=0x39,0x59,0x84,0x08
[  457.580522] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1835132 | i=1/2
[  457.580528] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14681 | 
buf=0x39,0x59,0x84,0x08
[  457.684561] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1840736 | i=1/2
[  457.684566] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14726 | 
buf=0x39,0x86,0x84,0x08
[  457.788523] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1840736 | i=1/2
[  457.788529] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14726 | 
buf=0x39,0x86,0x84,0x08
[  457.892545] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1833264 | i=1/2
[  457.892551] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14666 | 
buf=0x39,0x4a,0x84,0x08
[  458.000488] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1833264 | i=1/2
[  458.000494] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14666 | 
buf=0x39,0x4a,0x84,0x08
[  458.104531] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1842604 | i=1/2
[  458.104537] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14741 | 
buf=0x39,0x95,0x84,0x08
[  458.208537] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1842604 | i=1/2
[  458.208543] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14741 | 
buf=0x39,0x95,0x84,0x08
[  458.312539] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1831396 | i=1/2
[  458.312544] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14651 | 
buf=0x39,0x3b,0x84,0x08
[  458.416541] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1831396 | i=1/2
[  458.416546] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14651 | 
buf=0x39,0x3b,0x84,0x08
[  458.520545] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1844472 | i=1/2
[  458.520550] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14756 | 
buf=0x39,0xa4,0x84,0x08
[  458.624547] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1844472 | i=1/2
[  458.624552] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14756 | 
buf=0x39,0xa4,0x84,0x08
[  458.728536] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1829528 | i=1/2
[  458.728542] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14636 | 
buf=0x39,0x2c,0x84,0x08
[  458.832552] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1829528 | i=1/2
[  458.832558] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14636 | 
buf=0x39,0x2c,0x84,0x08
[  458.936554] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1846340 | i=1/2
[  458.936559] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14771 | 
buf=0x39,0xb3,0x84,0x08
[  459.040552] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1846340 | i=1/2
[  459.040558] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14771 | 
buf=0x39,0xb3,0x84,0x08
[  459.144562] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1827660 | i=1/2
[  459.144567] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14621 | 
buf=0x39,0x1d,0x84,0x08
[  459.248562] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1827660 | i=1/2
[  459.248567] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14621 | 
buf=0x39,0x1d,0x84,0x08
[  459.352568] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1848208 | i=1/2
[  459.352573] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14786 | 
buf=0x39,0xc2,0x84,0x08
[  459.456567] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1848208 | i=1/2
[  459.456572] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14786 | 
buf=0x39,0xc2,0x84,0x08
[  459.560571] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1825792 | i=1/2
[  459.560577] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14606 | 
buf=0x39,0x0e,0x84,0x08
[  459.664577] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1825792 | i=1/2
[  459.664582] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14606 | 
buf=0x39,0x0e,0x84,0x08
[  459.768576] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1850076 | i=1/2
[  459.768581] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14801 | 
buf=0x39,0xd1,0x84,0x08
[  459.872577] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1850076 | i=1/2
[  459.872583] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14801 | 
buf=0x39,0xd1,0x84,0x08
[  459.976582] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1823924 | i=1/2
[  459.976587] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14591 | 
buf=0x38,0xff,0x84,0x08
[  460.080649] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1823924 | i=1/2
[  460.080655] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14591 | 
buf=0x38,0xff,0x84,0x08
[  460.184587] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1851944 | i=1/2
[  460.184592] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14816 | 
buf=0x39,0xe0,0x84,0x08
[  460.288588] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1851944 | i=1/2
[  460.288594] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14816 | 
buf=0x39,0xe0,0x84,0x08
[  460.392592] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1822056 | i=1/2
[  460.392598] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14576 | 
buf=0x38,0xf0,0x84,0x08
[  460.496598] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1822056 | i=1/2
[  460.496600] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14576 | 
buf=0x38,0xf0,0x84,0x08
[  460.708649] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1837000 | i=1/2
[  460.708656] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14696 | 
buf=0x39,0x68,0x84,0x08
[  461.205236] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.276130] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  461.276209] dmxdev: dvb_dvr_open: dvb_dvr_open
[  461.399896] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  461.400169] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.400199] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1788000 | i=1/2
[  461.400206] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14304 | 
buf=0x37,0xe0,0x84,0x08
[  461.504612] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1788000 | i=1/2
[  461.504618] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14304 | 
buf=0x37,0xe0,0x84,0x08
[  461.510369] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.520532] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.530720] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.540835] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.551060] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.561290] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.571489] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.581684] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.591928] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.602156] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.612332] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.622497] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.632743] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.642982] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.653157] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.663342] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.673489] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.683631] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.693824] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.704096] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.714314] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.724487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.734668] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.744896] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.755138] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.765259] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.775430] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.785555] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.795752] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.805943] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.816132] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.826354] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.836468] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.846581] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.856772] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.867067] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.877342] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.887565] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.897738] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.908164] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.918329] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.928457] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.938558] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.948717] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.958948] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.969122] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.979341] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.989565] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  461.999812] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  462.009986] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  462.020183] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  462.088041] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  462.088140] dmxdev: dvb_dvr_open: dvb_dvr_open
[  462.211924] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  462.212212] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  462.212224] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1815000 | i=1/2
[  462.212231] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14520 | 
buf=0x38,0xb8,0x84,0x08
[  462.316638] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1815000 | i=1/2
[  462.316644] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14520 | 
buf=0x38,0xb8,0x84,0x08
[  462.420649] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1816868 | i=1/2
[  462.420655] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14535 | 
buf=0x38,0xc7,0x84,0x08
[  462.470027] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  462.544143] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  462.544237] dmxdev: dvb_dvr_open: dvb_dvr_open
[  462.667931] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  462.668178] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1815000 | i=1/2
[  462.668185] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14520 | 
buf=0x38,0xb8,0x84,0x08
[  462.668328] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  462.772661] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1815000 | i=1/2
[  462.772668] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14520 | 
buf=0x38,0xb8,0x84,0x08
[  462.876662] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1816868 | i=1/2
[  462.876668] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14535 | 
buf=0x38,0xc7,0x84,0x08
[  462.980667] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1816868 | i=1/2
[  462.980673] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14535 | 
buf=0x38,0xc7,0x84,0x08
[  463.084678] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1813132 | i=1/2
[  463.084683] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14505 | 
buf=0x38,0xa9,0x84,0x08
[  463.188670] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1813132 | i=1/2
[  463.188676] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14505 | 
buf=0x38,0xa9,0x84,0x08
[  463.292668] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1818736 | i=1/2
[  463.292673] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14550 | 
buf=0x38,0xd6,0x84,0x08
[  463.396666] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1818736 | i=1/2
[  463.396669] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14550 | 
buf=0x38,0xd6,0x84,0x08
[  463.500615] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1811264 | i=1/2
[  463.500622] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14490 | 
buf=0x38,0x9a,0x84,0x08
[  463.604681] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1811264 | i=1/2
[  463.604687] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14490 | 
buf=0x38,0x9a,0x84,0x08
[  463.708684] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1820604 | i=1/2
[  463.708689] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14565 | 
buf=0x38,0xe5,0x84,0x08
[  463.812686] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1820604 | i=1/2
[  463.812692] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14565 | 
buf=0x38,0xe5,0x84,0x08
[  463.916691] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1809396 | i=1/2
[  463.916697] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14475 | 
buf=0x38,0x8b,0x84,0x08
[  464.020694] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1809396 | i=1/2
[  464.020700] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14475 | 
buf=0x38,0x8b,0x84,0x08
[  464.124701] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1822472 | i=1/2
[  464.124706] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14580 | 
buf=0x38,0xf4,0x84,0x08
[  464.228704] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1822472 | i=1/2
[  464.228709] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14580 | 
buf=0x38,0xf4,0x84,0x08
[  464.332725] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1807528 | i=1/2
[  464.332730] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14460 | 
buf=0x38,0x7c,0x84,0x08
[  464.436703] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1807528 | i=1/2
[  464.436708] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14460 | 
buf=0x38,0x7c,0x84,0x08
[  464.540706] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1824340 | i=1/2
[  464.540711] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14595 | 
buf=0x39,0x03,0x84,0x08
[  464.644712] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1824340 | i=1/2
[  464.644717] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14595 | 
buf=0x39,0x03,0x84,0x08
[  464.748712] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1805660 | i=1/2
[  464.748718] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14445 | 
buf=0x38,0x6d,0x84,0x08
[  464.852715] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1805660 | i=1/2
[  464.852721] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14445 | 
buf=0x38,0x6d,0x84,0x08
[  464.956719] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1826208 | i=1/2
[  464.956724] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14610 | 
buf=0x39,0x12,0x84,0x08
[  465.060750] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1826208 | i=1/2
[  465.060756] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14610 | 
buf=0x39,0x12,0x84,0x08
[  465.165641] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1803792 | i=1/2
[  465.165647] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14430 | 
buf=0x38,0x5e,0x84,0x08
[  465.268731] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1803792 | i=1/2
[  465.268737] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14430 | 
buf=0x38,0x5e,0x84,0x08
[  465.372725] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1828076 | i=1/2
[  465.372731] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14625 | 
buf=0x39,0x21,0x84,0x08
[  465.476732] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1828076 | i=1/2
[  465.476737] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14625 | 
buf=0x39,0x21,0x84,0x08
[  465.580732] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1801924 | i=1/2
[  465.580737] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14415 | 
buf=0x38,0x4f,0x84,0x08
[  465.684779] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1801924 | i=1/2
[  465.684786] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14415 | 
buf=0x38,0x4f,0x84,0x08
[  465.788756] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1829944 | i=1/2
[  465.788762] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14640 | 
buf=0x39,0x30,0x84,0x08
[  465.892737] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1829944 | i=1/2
[  465.892743] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14640 | 
buf=0x39,0x30,0x84,0x08
[  465.996683] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1800056 | i=1/2
[  465.996690] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14400 | 
buf=0x38,0x40,0x84,0x08
[  466.100793] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1800056 | i=1/2
[  466.100800] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14400 | 
buf=0x38,0x40,0x84,0x08
[  466.308753] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1815000 | i=1/2
[  466.308760] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14520 | 
buf=0x38,0xb8,0x84,0x08
[  467.428777] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1815000 | i=1/2
[  467.428839] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14520 | 
buf=0x38,0xb8,0x84,0x08
[  468.548849] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1816868 | i=1/2
[  468.548856] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14535 | 
buf=0x38,0xc7,0x84,0x08
[  469.668801] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1816868 | i=1/2
[  469.668808] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14535 | 
buf=0x38,0xc7,0x84,0x08
[  469.757288] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  469.828314] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  469.828392] dmxdev: dvb_dvr_open: dvb_dvr_open
[  469.952370] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  469.952586] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  469.952617] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1776000 | i=1/2
[  469.952623] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14208 | 
buf=0x37,0x80,0x84,0x08
[  470.056869] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1776000 | i=1/2
[  470.056876] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14208 | 
buf=0x37,0x80,0x84,0x08
[  470.160856] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1777856 | i=1/2
[  470.160862] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14223 | 
buf=0x37,0x8f,0x84,0x08
[  470.264864] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1777856 | i=1/2
[  470.264869] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14223 | 
buf=0x37,0x8f,0x84,0x08
[  470.368875] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1774144 | i=1/2
[  470.368881] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14193 | 
buf=0x37,0x71,0x84,0x08
[  470.472818] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1774144 | i=1/2
[  470.472824] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14193 | 
buf=0x37,0x71,0x84,0x08
[  470.576878] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1779712 | i=1/2
[  470.576884] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14238 | 
buf=0x37,0x9e,0x84,0x08
[  470.680885] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1779712 | i=1/2
[  470.680891] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14238 | 
buf=0x37,0x9e,0x84,0x08
[  470.784876] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1772288 | i=1/2
[  470.784881] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14178 | 
buf=0x37,0x62,0x84,0x08
[  470.888878] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1772288 | i=1/2
[  470.888884] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14178 | 
buf=0x37,0x62,0x84,0x08
[  470.992834] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1781568 | i=1/2
[  470.992841] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14253 | 
buf=0x37,0xad,0x84,0x08
[  471.096888] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1781568 | i=1/2
[  471.096895] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14253 | 
buf=0x37,0xad,0x84,0x08
[  471.200887] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1770432 | i=1/2
[  471.200893] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14163 | 
buf=0x37,0x53,0x84,0x08
[  471.304915] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1770432 | i=1/2
[  471.304921] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14163 | 
buf=0x37,0x53,0x84,0x08
[  471.408891] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1783424 | i=1/2
[  471.408897] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14267 | 
buf=0x37,0xbb,0x84,0x08
[  471.512900] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1783424 | i=1/2
[  471.512906] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14267 | 
buf=0x37,0xbb,0x84,0x08
[  471.616897] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1768576 | i=1/2
[  471.616903] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14149 | 
buf=0x37,0x45,0x84,0x08
[  471.720869] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1768576 | i=1/2
[  471.720875] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14149 | 
buf=0x37,0x45,0x84,0x08
[  471.824903] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1785280 | i=1/2
[  471.824908] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14282 | 
buf=0x37,0xca,0x84,0x08
[  471.928842] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1785280 | i=1/2
[  471.928848] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14282 | 
buf=0x37,0xca,0x84,0x08
[  472.032901] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1766720 | i=1/2
[  472.032907] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14134 | 
buf=0x37,0x36,0x84,0x08
[  472.136913] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1766720 | i=1/2
[  472.136919] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14134 | 
buf=0x37,0x36,0x84,0x08
[  472.240917] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1787136 | i=1/2
[  472.240923] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14297 | 
buf=0x37,0xd9,0x84,0x08
[  472.344904] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1787136 | i=1/2
[  472.344909] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14297 | 
buf=0x37,0xd9,0x84,0x08
[  472.448923] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1764864 | i=1/2
[  472.448929] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14119 | 
buf=0x37,0x27,0x84,0x08
[  472.552915] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1764864 | i=1/2
[  472.552918] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=14119 | 
buf=0x37,0x27,0x84,0x08
[  472.613346] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  472.684386] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  472.684464] dmxdev: dvb_dvr_open: dvb_dvr_open
[  472.812231] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
interval: tuner: 950000000...2150000000, frontend: 950000000...2150000000
[  472.812550] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1204000 | i=0/2
[  472.812556] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9632 | 
buf=0x25,0xa0,0x84,0x18
[  472.812711] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  472.916941] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: 
freq=1204000 | i=0/2
[  472.916947] dvb_pll: dvb_pll_configure: pll: Samsung TBMU24112: div=9632 | 
buf=0x25,0xa0,0x84,0x18
[  472.922732] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  472.932887] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  472.943118] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  472.953334] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  472.963502] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  472.973668] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  472.983872] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  472.994106] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.004225] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.014319] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.024520] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.034746] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.044919] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.055217] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.065448] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.075665] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.085834] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.096027] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.106253] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.116489] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.126705] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.136890] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.147505] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.157734] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.167959] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.178197] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.188377] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.198613] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.208728] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.218898] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.229125] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.239242] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.249366] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.259534] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.269761] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.279929] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.290099] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.300216] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.310338] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.320534] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.330692] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.340807] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.350964] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.361102] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.371235] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.381407] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.391574] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.401766] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.411951] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.422140] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.432449] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.442611] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.452785] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.462944] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.473135] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.483315] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.493534] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.503752] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.513877] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.524118] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.534254] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.544386] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.554518] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.564677] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.574867] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.585144] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.595329] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.605488] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.615820] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.625980] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.636087] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.646183] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.656324] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.666546] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.676713] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.686934] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.697147] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.707365] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.717578] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.727796] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.738013] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.748117] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.758287] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.768539] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.778711] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.788869] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.799100] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.809319] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.819508] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.829728] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.839901] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.850084] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.860323] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.870511] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.880623] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.890807] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.900958] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.911115] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.921329] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.931516] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.941689] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.951865] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.962101] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.972283] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.982416] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  473.992598] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.002795] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.012923] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.023099] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.033287] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.043482] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.053659] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.063824] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.074000] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.084136] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.094300] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.104488] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.114750] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.124965] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.135236] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.145460] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.155652] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.165871] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.176107] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.186278] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.196459] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.206620] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.216725] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.226941] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.237097] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.247333] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.257606] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.267830] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.277992] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.288210] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.298431] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.308596] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.318871] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.329032] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.339303] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.349522] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.359703] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.369931] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.380174] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.390396] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.400616] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.410900] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.421062] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.431248] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.441414] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.451582] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.461758] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.471987] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.482220] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.492402] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.502540] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.512645] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.522872] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.533041] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.543202] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.553441] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.563628] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.573736] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.583964] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.594182] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.604349] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.614522] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.624690] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.634908] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.645133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.655299] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.665525] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.675771] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.685961] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.696206] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.706426] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.716587] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.726818] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.736991] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.747163] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.757379] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.767549] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.777720] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.787885] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.798125] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.808405] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.818666] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.828830] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.839104] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.849278] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.859402] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.869569] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.879850] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.890073] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.900200] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.910432] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.920653] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.930912] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.941187] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.951357] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.961574] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.971742] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.982016] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  474.992288] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.002407] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.012465] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.022583] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.032731] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.042903] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.053088] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.063278] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.073555] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.083732] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.093912] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.104098] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.114281] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.124522] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.134690] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.144855] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.155068] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.165240] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.175463] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.185689] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.195905] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.206134] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.216310] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.226537] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.236654] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.246817] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.256921] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.267134] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.277306] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.287474] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.297652] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.307880] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.318055] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.328243] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.338471] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.348611] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.358837] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.369005] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.379185] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.389416] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.399646] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.409841] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.420072] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.430181] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.440411] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.450713] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.460925] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.471093] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.481315] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.491493] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.501770] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.511999] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.522274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.532558] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.542831] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.553067] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.563238] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.573407] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.583677] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.593911] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.604200] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.614362] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.624591] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.634859] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.645131] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.655370] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.665552] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.675780] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.686010] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.696322] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.706491] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.716650] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.726809] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.736923] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.747092] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.757317] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.767460] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.777648] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.787827] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.798101] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.808445] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.818697] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.828858] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.838976] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.849137] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.859296] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.869470] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.879702] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.889918] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.900144] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.910374] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.920603] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.930786] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.940944] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.951116] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.961328] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.971567] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.981820] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  475.991984] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.002201] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.012372] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.022598] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.032776] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.042946] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.053217] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.063399] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.073509] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.083673] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.093853] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.104031] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.114308] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.124556] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.134829] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.145048] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.155290] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.165460] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.175673] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.185919] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.196101] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.206286] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.216539] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.226757] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.236885] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.247175] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.257448] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.267665] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.277889] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.288126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.298415] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.308642] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.318873] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.328999] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.339224] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.349404] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.359584] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.369800] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.379966] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.390140] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.400419] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.410537] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.420698] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.430855] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.441031] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.451244] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.461425] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.471597] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.481826] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.491997] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.502213] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.512445] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.522656] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.532832] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.543047] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.553275] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.563450] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.573575] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.583774] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.594005] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.604184] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.614413] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.624611] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.634763] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.644929] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.655145] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.665362] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.675519] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.685741] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.695909] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.706194] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.716357] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.726584] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.736758] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.746881] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.756996] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.767177] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.777347] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.787520] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.797698] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.807917] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.818140] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.828375] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.838648] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.848757] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.858943] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.869159] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.879392] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.889668] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.899840] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.910013] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.920306] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.930472] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.940649] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.950873] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.961030] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.971243] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.981468] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  476.991647] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.001751] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.011858] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.022002] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.032179] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.042356] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.052541] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.062699] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.072869] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.082980] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.093151] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.103323] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.113540] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.123707] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.133875] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.144146] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.154416] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.164642] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.174864] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.185022] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.195290] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.205559] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.215776] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.226066] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.236193] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.246351] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.256539] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.266751] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.276937] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.287156] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.297331] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.307559] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.317788] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.328028] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.338257] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.348475] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.358667] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.368772] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.378937] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.389116] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.399286] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.409406] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.419616] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.429778] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.439933] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.450154] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.460402] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.470627] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.480731] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.490890] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.501141] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.511357] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.521522] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.531753] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.541980] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.552222] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.562446] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.572590] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.582801] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.592974] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.603133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.613329] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.623552] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.633765] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.644005] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.654235] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.664432] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.674650] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.684805] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.695003] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.705184] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.715411] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.725637] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.735857] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.746084] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.756201] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.766414] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.776647] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.786829] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.796989] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.807163] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.817390] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.827558] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.837838] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.848055] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.858287] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.868466] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.878573] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.888733] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.898903] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.909067] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.919178] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.929340] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.939460] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.949592] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.959719] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.969944] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.980125] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  477.990289] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.000462] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.010574] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.020693] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.030844] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.040972] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.051126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.061352] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.071536] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.081648] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.091798] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.102022] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.112244] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.122411] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.132569] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.142731] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.152901] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.163145] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.173369] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.183599] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.193781] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.203951] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.214127] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.224402] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.234685] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.244903] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.255119] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.265352] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.275643] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.285920] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.296178] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.306411] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.316608] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.326771] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.336946] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.347105] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.357270] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.367482] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.377707] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.387875] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.398045] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.408272] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.418552] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.428719] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.438925] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.449037] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.459249] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.469424] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.479617] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.489906] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.500121] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.510285] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.520516] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.530720] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.540875] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.550999] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.561144] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.571323] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.581542] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.591723] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.601888] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.612073] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.622193] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.632363] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.642536] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.652634] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.662806] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.672976] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.683216] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.693451] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.703567] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.713726] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.723937] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.734108] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.744293] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.754518] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.764794] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.775004] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.785175] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.795494] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.805706] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.815934] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.826164] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.836382] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.846604] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.856761] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.866971] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.877091] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.887574] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.897761] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.907934] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.918120] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.928332] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.938526] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.948698] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.958904] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.969017] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.979171] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.989393] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  478.999563] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.009684] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.019843] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.030009] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.040289] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.050461] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.060642] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.070810] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.080914] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.091072] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.101238] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.111471] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.121585] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.131742] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.141970] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.152138] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.162318] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.172427] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.182566] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.192733] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.202900] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.213085] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.223318] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.233533] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.243708] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.253887] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.264057] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.274217] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.284436] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.294653] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.304806] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.315015] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.325239] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.335459] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.345689] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.355899] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.366136] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.376376] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.386608] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.396780] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.406989] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.417170] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.427408] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.437635] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.447755] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.457932] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.468156] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.478380] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.488624] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.498831] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.508995] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.519224] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.529380] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.539591] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.549761] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.559884] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.570052] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.580227] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.590388] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.600640] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.610854] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.621013] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.631225] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.641491] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.651714] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.661952] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.672122] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.682394] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.692600] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.702814] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.712990] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.723232] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.733404] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.743608] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.753766] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.763982] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.774095] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.784218] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.794440] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.804630] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.814889] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.825068] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.835233] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.845676] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.855902] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.866129] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.876359] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.886603] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.896876] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.907099] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.917273] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.927487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.937652] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.947863] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.958118] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.968344] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.978518] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.988654] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  479.998814] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.008984] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.019208] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.029377] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.039595] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.049765] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.060039] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.070274] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.080486] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.090661] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.100821] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.111038] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.121267] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.131493] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.141669] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.151839] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.162026] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.172209] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.182423] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.192671] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.202838] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.213001] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.223213] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.233440] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.243657] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.253887] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.264072] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.274232] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.284375] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.294553] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.304739] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.314920] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.325022] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.335235] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.345461] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.355682] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.365810] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.376000] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.386213] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.396440] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.406715] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.416886] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.427116] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.437273] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.447491] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.457712] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.467824] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.478033] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.488248] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.498435] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.508682] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.518909] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.529023] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.539185] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.549443] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.559711] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.569936] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.580178] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.590347] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.600560] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.610759] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.620983] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.631254] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.641474] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.651702] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.661980] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.672252] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.682457] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.692639] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.702861] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.713031] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.723198] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.733365] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.743533] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.753757] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.763927] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.774085] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.784309] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.794487] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.804636] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.814851] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.825022] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.835276] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.845439] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.855568] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.865748] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.875964] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.886077] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.896313] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.906473] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.916703] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.926863] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.937033] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.947247] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.957470] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.967634] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.977850] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.988148] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  480.998374] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.008476] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.018596] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.028705] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.038817] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.048973] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.059148] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.069258] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.079415] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.089583] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.099810] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.109985] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.120206] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.130374] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.140550] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.150720] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.160875] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.171105] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.181294] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.191454] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.201619] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.211832] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.222013] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.232195] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.242370] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.252475] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.262595] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.272782] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.282944] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.293055] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.303260] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.313420] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.323529] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.333744] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.343900] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.354172] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.364349] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.374519] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.384766] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.394981] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.405097] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.415318] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.425514] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.435681] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.445857] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.456083] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.466312] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.476542] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.486719] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.496895] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.507198] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.517426] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.527665] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.537835] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.547930] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.558140] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.568314] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.578476] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.588651] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.598761] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.608932] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.619144] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.629364] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.639577] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.649712] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.659815] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.669979] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.680095] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.690292] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.700544] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.710669] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.720815] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.731034] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.741205] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.751432] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.761610] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.771728] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.781967] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.792191] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.802398] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.812513] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.822710] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.832856] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.843028] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.853121] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.863317] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.873459] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.883548] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.893694] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.903907] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.914060] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.924215] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.934424] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.944576] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.954722] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.964817] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.975018] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.985252] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  481.995406] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.005524] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.015631] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.025722] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.035794] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.045871] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.055950] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.066065] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.076198] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.086306] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.096433] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.106802] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.116935] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.127056] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.137174] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.147311] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.157462] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.167667] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.177830] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.188036] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.198184] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.208437] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.218572] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.228646] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.238757] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.248959] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.259163] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.269275] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.279387] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.289484] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.299978] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.310080] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.320214] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.330328] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.340437] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.350547] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.360662] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.370769] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.380902] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.391020] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.401134] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.411239] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.421385] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.431547] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.441650] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.451801] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.461976] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.472079] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.482185] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.492341] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.502488] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.512745] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.522922] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.533067] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.543271] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.553417] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.563507] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.573656] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.583811] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.594014] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.604268] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.614486] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.624637] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.634849] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.644994] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.655195] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.665397] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.675542] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.685639] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.695738] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.705901] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.716062] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.726212] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.736358] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.746463] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.756565] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.766664] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.776733] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.786885] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.796984] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.807145] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.817296] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.827410] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.837556] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.847701] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.857903] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.868126] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.878217] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.888312] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.898403] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.908563] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.918778] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.928927] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.939133] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.949276] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.959450] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.969709] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.979912] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  482.990118] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.000393] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.010600] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.020685] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.030875] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.041021] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.051167] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.061313] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.071480] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.081589] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  483.091784] dmxdev: dvb_dvr_poll: dvb_dvr_poll
[  649.009548] cx23885 0000:03:00.0: invalid short VPD tag 01 at offset 1
[  649.011439] r8169 0000:06:00.0: invalid short VPD tag 00 at offset 1
[  718.470462] fuse init (API version 7.28)





_________________________________________________________________
________________________________________________________
Ihre E-Mail-Postf�cher sicher & zentral an einem Ort. Jetzt wechseln und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
