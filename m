Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54953 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbaLNIFM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:05:12 -0500
Message-ID: <548D44B5.5030706@iki.fi>
Date: Sun, 14 Dec 2014 10:05:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] rtl28xxu: swap frontend order for devices with slave
 demodulators
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-2-git-send-email-benjamin@southpole.se> <548BBA41.7000109@iki.fi> <548C1E53.10408@southpole.se> <548C4096.5030401@iki.fi> <548C8AEF.1090907@southpole.se>
In-Reply-To: <548C8AEF.1090907@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/13/2014 08:52 PM, Benjamin Larsson wrote:
> On 12/13/2014 02:35 PM, Antti Palosaari wrote:
>>
>>
>> Do you understand that code at all?
>
> No I can't really say I understand all the workings of the media api.
>
>>
>> Now it is:
>> FE0 == (fe->id == 0) == RTL2832
>> FE1 == (fe->id == 1) == MN88472
>>
>> you changed it to:
>> FE0 == (fe->id == 0) == MN88472
>> FE1 == (fe->id == 1) == RTL2832
>
> I thought the rtl2832u_frontend_attach() actually attached the devices.
> Then the id's would have followed the frontend.
>
>
>>
>> Then there is:
>>
>> /* bypass slave demod TS through master demod */
>> if (fe->id == 1 && onoff) {
>>     ret = rtl2832_enable_external_ts_if(adap->fe[1]);
>>     if (ret)
>>         goto err;
>> }
>>
>> After your change that code branch is taken when RTL2832 demod is
>> activated / used. Shouldn't TS bypass enabled just opposite, when
>> MN88472 is used....
>>
>>
>> Antti
>>
>
> This intent of the patch was for better backwards compatibility with old
> software. This isn't strictly needed so consider the patch dropped.

I just tested that patch, and it behaves just like I expected - does not 
work at all (because RTL2832 TS bypass will not be enabled anymore).

Here is log, first with your patch, then I fixed it a little as diff 
shows, and after that scan works. I wonder what kind of test you did for 
it - or do you have some other hacks committed...

[crope@localhost linux]$ dvbv5-scan ~/.tzap/mux-Oulu-t-t2 
--file-freqs-only -a 0 -f 0
Scanning frequency #1 634000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #2 714000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #3 738000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #4 498000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #5 602000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #6 570000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #7 177500000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #8 205500000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #9 219500000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
[crope@localhost linux]$ git diff
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c 
b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 61a4a86..6902801 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1372,7 +1372,7 @@ static int rtl2832u_frontend_ctrl(struct 
dvb_frontend *fe, int onoff)
                 goto err;

         /* bypass slave demod TS through master demod */
-       if (fe->id == 1 && onoff) {
+       if (fe->id == 0 && onoff) {
                 ret = rtl2832_enable_external_ts_if(adap->fe[1]);
                 if (ret)
                         goto err;
[crope@localhost linux]$ dvbv5-scan ~/.tzap/mux-Oulu-t-t2 
--file-freqs-only -a 0 -f 0
Scanning frequency #1 634000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the NIT table
Service Yle TV1, provider YLE: digital television
Service Yle TV2, provider YLE: digital television
Service Yle Fem, provider YLE: digital television
Service Yle Teema, provider YLE: digital television
Service AVA, provider MTV Oy: digital television
Service FOX, provider Fox International Channels Oy: digital television
Service Ohjelmistopäivitykset, provider Digita OY: data broadcast
Service Yle Puhe, provider YLE: digital radio
Service Yle Klassinen, provider YLE: digital radio
Service Yle Mondo, provider YLE: digital radio
Scanning frequency #2 714000000
Lock   (0x1f) Signal= 0.00%
Service 0700 11111 deitti, provider 0700 11111 deitti: digital television
Service MTV3, provider MTV Oy: digital television
Service Nelonen, provider Sanoma Television Oy: digital television
Service Sub, provider SubTV OY: digital television
Service Liv, provider Sanoma Television Oy: digital television
Service MTV MAX, provider MTV Oy: digital television
Service MTV Leffa, provider SubTV OY: digital television
Service MTV Juniori, provider SubTV OY: digital television
Service Ohjelmistopäivitykset, provider Digita Oy: data broadcast
Service Estradi, provider Digita Oy: digital television
Scanning frequency #3 738000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the NIT table
Service Nelonen Pro 2, provider Sanoma Television Oy: digital television
Service TV5, provider SBS Finland: digital television
Service Nelonen Pro 1, provider Sanoma Television Oy: digital television
Service Disney Channel, provider CANAL+: digital television
Service C More First, provider C More: digital television
Service C More Series, provider C More: digital television
Service MTV Sport 1, provider C More: digital television
Service Hero, provider Sanoma: digital television
Service Iskelmä/Harju&Pöntinen, provider SBS Finland Oy / 
Etelä-Pohjanmaan Viestintä Oy: digital television
Service DIGIVIIHDE.fi, provider Telefirst Oy: digital television
Scanning frequency #4 498000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #5 602000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the NIT table
Service Nelonen Prime, provider Sanoma Television Oy: digital television
Service Nelonen Nappula, provider Sanoma Television Oy: digital television
Service Nelonen Maailma, provider Sanoma Television Oy: digital television
Service Jim, provider Sanoma Television OY: digital television
Service Kutonen, provider SBS Finland: digital television
Service Discovery, provider Discovery Communications Europe: digital 
television
Service Eurosport, provider Eurosport SA: digital television
Service MTV, provider MTV Networks Europe: digital television
Service Nick Jr., provider Nickelodeon International Ltd.: digital 
television
Scanning frequency #6 570000000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #7 177500000
Lock   (0x1f) Signal= 0.00%
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #8 205500000
Lock   (0x1f) Signal= 0.00%
Service Viasat Hockey Finland, provider (null): reserved
Service Animal Planet, provider Telenor: reserved
Service Silver, provider Levira: reserved
Service Disney Junior, provider (null): reserved
Service Nelonen Pro 1 HD, provider (null): reserved
Service MTV Max HD, provider MTV OY: reserved
Service MTV Fakta, provider MTV OY: reserved
Service C More Hits, provider Telenor: reserved
Service C More First HD, provider Telenor: reserved
Service MTV Sport 2, provider MTV OY: reserved
Service Nelonen Pro 1 HD, provider (null): reserved
Service Viasat Xtra NHL 4, provider (null): reserved
Service Viasat Xtra NHL 5, provider (null): reserved
Service Disney XD, provider (null): reserved
Scanning frequency #9 219500000
Lock   (0x1f) Signal= 0.00%
Service Yle TV1 HD, provider Yle: reserved
Service Yle TV2 HD, provider Yle: reserved
Service Viasat Xtra NHL 1, provider (null): reserved
Service Viasat Xtra NHL 2, provider (null): reserved
Service Viasat Xtra NHL 3, provider (null): reserved
Service MTV3 HD, provider MTV OY: reserved
[crope@localhost linux]$



regards
Antti

-- 
http://palosaari.fi/
