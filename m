Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33482 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbcCDI2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 03:28:49 -0500
Received: by mail-qg0-f44.google.com with SMTP id t4so38071923qge.0
        for <linux-media@vger.kernel.org>; Fri, 04 Mar 2016 00:28:48 -0800 (PST)
Received: from mail-qg0-f45.google.com (mail-qg0-f45.google.com. [209.85.192.45])
        by smtp.gmail.com with ESMTPSA id w70sm1169920qge.13.2016.03.04.00.28.47
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Mar 2016 00:28:47 -0800 (PST)
Received: by mail-qg0-f45.google.com with SMTP id y89so37919932qge.2
        for <linux-media@vger.kernel.org>; Fri, 04 Mar 2016 00:28:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457079352.2782.3.camel@xs4all.nl>
References: <1436697509.2446.14.camel@xs4all.nl>
	<1440352250.13381.3.camel@xs4all.nl>
	<55F332FE.7040201@mbox200.swipnet.se>
	<1442041326.2442.2.camel@xs4all.nl>
	<CAAZRmGxvrXjanCTcd0Ybk-qzHhqO5e6JhrpSWxNXSa+zzPsdUg@mail.gmail.com>
	<1454007436.13371.4.camel@xs4all.nl>
	<CAAZRmGwuinufZpCpTs8t+BRyTcfio-4z34PCKH7Ha3J+dxXNqw@mail.gmail.com>
	<56ADCBE4.6050609@mbox200.swipnet.se>
	<CAAZRmGy21S+qkrC9d0hz02J98woUc9p+LtnhK8Det=yWmb_myg@mail.gmail.com>
	<56C88CEB.3080907@mbox200.swipnet.se>
	<1455988859.21645.6.camel@xs4all.nl>
	<CAAZRmGwME6Mb+HAtd5nwPxc9RJi-XdTbS_Cfn1P1LOi0Y2UYZg@mail.gmail.com>
	<1457079352.2782.3.camel@xs4all.nl>
Date: Fri, 4 Mar 2016 10:28:46 +0200
Message-ID: <CAAZRmGzCY+foBG2rnDYj6fHewCpj3m-ucDF_5McaUpmuEDyCVQ@mail.gmail.com>
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
From: Olli Salonen <olli.salonen@iki.fi>
To: Jurgen Kramer <gtmkramer@xs4all.nl>
Cc: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jurgen,

Ah, that's interesting. My T980C (and based on printout from Torbjörn
his as well) have Si2168-A20 chips.

Some things I'd like to understand:
- is there a difference if the CI slot is populated or not?
- is there any difference between the different firmwares?
- does it work with the DVBSky provided driver?
- when you say it doesn't work, is the issue that the demodulator does
not lock on the DVB-T2 muxes?

Two different firmwares for A30 chip:
https://github.com/OpenELEC/dvb-firmware/blob/18b12de1f57b3c70a681983638989f94590b19f1/firmware/dvb-demod-si2168-a30-01.fw?raw=true
https://github.com/OpenELEC/dvb-firmware/raw/dc7cf270e328de144e75a30d970b6e147e8bcb6e/firmware/dvb-demod-si2168-a30-01.fw

I think the second one is newer, but don't have the means to verify right now...

Cheers,
-olli

On 4 March 2016 at 10:15, Jurgen Kramer <gtmkramer@xs4all.nl> wrote:
> Hi Olli,
>
> On Thu, 2016-03-03 at 13:02 +0200, Olli Salonen wrote:
>> Hi Jurgen, Torbjörn,
>>
>> I've noticed that there is currently a small confusion about the
>> firmware versions for the Si2168-A20 demodulator. This is used in the
>> older versions of DVBSky T680C (TechnoTrend CT2-4650 CI) and DVBSky
>> T980C (TechnoTrend CT2-4500 CI).
>>
>> The version 2.0.5 does not support PLP handling and seems to work
>> very
>> badly with the Linux driver - at least for me. Version 2.0.35 on the
>> other hand seems to find all DVB-T/T2 channels for me just fine with
>> both dvbv5-scan and w_scan (devices used for this test: TechnoTrend
>> CT2-4650 CI and TechnoTrend CT2-4500 CI new version).
>>
>> Versions used:
>> dvbv5-scan version 1.7.0
>> w_scan version 20150111 (compiled for DVB API 5.10)
>>
>> So if you are running these Si2168-A20 based devices, make sure
>> you've
>> got the firmware 2.0.35 that can be downloaded for example here:
>> http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-A20/32e06713
>> b33915f674bfb2c209beaea5/
>
> It seems my TC980Cs have Si2168-A30's on board
>
> [  118.526665] si2168 8-0064: found a 'Silicon Labs Si2168-A30'
> [  118.640642] si2168 8-0064: downloading firmware from file 'dvb-
> demod-si2168-a30-01.fw'
> [  121.762983] si2168 8-0064: firmware version: 3.0.16
>
> dvbv5_scan does not work me.
> sha1sum for this firmware is:
> 59a0b90703d65229fb2589b52834ca68d1e96ad9  dvb-demod-si2168-a30-01.fw
>
> Jurgen
>
