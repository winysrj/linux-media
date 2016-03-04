Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:39181 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbcCDIPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 03:15:55 -0500
Message-ID: <1457079352.2782.3.camel@xs4all.nl>
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Olli Salonen <olli.salonen@iki.fi>,
	Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Fri, 04 Mar 2016 09:15:52 +0100
In-Reply-To: <CAAZRmGwME6Mb+HAtd5nwPxc9RJi-XdTbS_Cfn1P1LOi0Y2UYZg@mail.gmail.com>
References: <1436697509.2446.14.camel@xs4all.nl>
	 <1440352250.13381.3.camel@xs4all.nl> <55F332FE.7040201@mbox200.swipnet.se>
	 <1442041326.2442.2.camel@xs4all.nl>
	 <CAAZRmGxvrXjanCTcd0Ybk-qzHhqO5e6JhrpSWxNXSa+zzPsdUg@mail.gmail.com>
	 <1454007436.13371.4.camel@xs4all.nl>
	 <CAAZRmGwuinufZpCpTs8t+BRyTcfio-4z34PCKH7Ha3J+dxXNqw@mail.gmail.com>
	 <56ADCBE4.6050609@mbox200.swipnet.se>
	 <CAAZRmGy21S+qkrC9d0hz02J98woUc9p+LtnhK8Det=yWmb_myg@mail.gmail.com>
	 <56C88CEB.3080907@mbox200.swipnet.se> <1455988859.21645.6.camel@xs4all.nl>
	 <CAAZRmGwME6Mb+HAtd5nwPxc9RJi-XdTbS_Cfn1P1LOi0Y2UYZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,

On Thu, 2016-03-03 at 13:02 +0200, Olli Salonen wrote:
> Hi Jurgen, Torbjörn,
> 
> I've noticed that there is currently a small confusion about the
> firmware versions for the Si2168-A20 demodulator. This is used in the
> older versions of DVBSky T680C (TechnoTrend CT2-4650 CI) and DVBSky
> T980C (TechnoTrend CT2-4500 CI).
> 
> The version 2.0.5 does not support PLP handling and seems to work
> very
> badly with the Linux driver - at least for me. Version 2.0.35 on the
> other hand seems to find all DVB-T/T2 channels for me just fine with
> both dvbv5-scan and w_scan (devices used for this test: TechnoTrend
> CT2-4650 CI and TechnoTrend CT2-4500 CI new version).
> 
> Versions used:
> dvbv5-scan version 1.7.0
> w_scan version 20150111 (compiled for DVB API 5.10)
> 
> So if you are running these Si2168-A20 based devices, make sure
> you've
> got the firmware 2.0.35 that can be downloaded for example here:
> http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-A20/32e06713
> b33915f674bfb2c209beaea5/

It seems my TC980Cs have Si2168-A30's on board

[  118.526665] si2168 8-0064: found a 'Silicon Labs Si2168-A30'
[  118.640642] si2168 8-0064: downloading firmware from file 'dvb-
demod-si2168-a30-01.fw'
[  121.762983] si2168 8-0064: firmware version: 3.0.16

dvbv5_scan does not work me.
sha1sum for this firmware is:
59a0b90703d65229fb2589b52834ca68d1e96ad9  dvb-demod-si2168-a30-01.fw

Jurgen

