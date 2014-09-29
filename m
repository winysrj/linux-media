Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47025 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbaI2OMz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 10:12:55 -0400
Message-ID: <542968E4.6020308@iki.fi>
Date: Mon, 29 Sep 2014 17:12:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bimow Chen <Bimow.Chen@ite.com.tw>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] af9033: fix signal strength value not correct issue
References: <1411980225.1747.10.camel@ite-desktop> <54294A66.30703@iki.fi>
In-Reply-To: <54294A66.30703@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 09/29/2014 03:02 PM, Antti Palosaari wrote:
> On 09/29/2014 11:43 AM, Bimow Chen wrote:
>> Register 0x800048 is not dB measure but relative scale. Fix it and
>> conform to NorDig specifications.
>
> eh, 0x800048 register returned strength normalized to 0-100 %. But that
> was earlier when older firmwares used. I have seen it does not return
> anything anymore, so I am very fine it is replaced with something
> meaningful.
>
> But the issues is that this patches changes current DVBv5 signal
> reporting from dBm to relative. I indeed implemented it is as a dBm and
> I checked it using modulator RF strength it really is dBm. Now you add
> some glue which converts dBm to relative value between 0-0xffff.
>
> I encourage you to use modulator yourself to generate signals. Then use
> dvbv5-zap to see values DVBv5 API reports.
>
> If you really want return 0-0xffff values, then do it for old DVBv3
> read_signal_strength(), but do not change new DVBv5 statistics to
> relative. dBm, as a clearly defined unit, is always preferred over
> relative. Relative was added to API for cases we cannot report well
> known units.
>
> Could you tell which is unit NorDig specification defines for signal
> strength?

According to latest NorDig specification, page 39
http://www.nordig.org/pdf/NorDig-Unified_ver_2.5.1.pdf
there is two kind of reports, basic and advanced. Normal report is (%) 
which suits well for relative scale.

The basic status check shall include:
* channel id, according to Annex B.2
* centre frequency
* Signal Strength Indicator, SSI (%), according to section 3.4.4.6
* Signal Quality Indicator, SQI (%), according to section 3.4.4.7


The terrestrial NorDig IRD should provide an advanced status check 
function (accessible through the Navigator) that presents the following 
information:
* channel id, according to Annex B.2
* centre frequency
* signal strength (dBm or dBμV)
* signal strength indicator, SSI (%), according to section 3.4.4.6
* signal quality indicator, SQI (%), according to section 3.4.4.7
* C/N (dB)
* BER before Reed Solomon decoding (DVB-T) or BCH decoding (DVB-T2)
* Uncorrected packets


regards
Antti
-- 
http://palosaari.fi/
