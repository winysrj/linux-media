Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44861 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbbFHI7c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 04:59:32 -0400
Message-ID: <55755971.3050002@iki.fi>
Date: Mon, 08 Jun 2015 11:59:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Doug Lung <dlung0@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Obtain Si2157 and LGDT3306A signal stats from HVR955Q?
References: <CAAT-iuuO1L=ft+Mw27T156JfY1j+-Xdr42TVSxjdGNA9yowYZA@mail.gmail.com>
In-Reply-To: <CAAT-iuuO1L=ft+Mw27T156JfY1j+-Xdr42TVSxjdGNA9yowYZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 06/08/2015 01:21 AM, Doug Lung wrote:
> Hello! this is my first post here, although I've benefited from all
> the work of the contributors over the year. Thanks!
>
> I'm looking for help getting similar signal statistics from the new
> Hauppauge HVR955Q (Si2157, LGDT3306A, CX23102) USB ATSC tuner that I'm
> now getting from the Hauppauge Aero-M (MxL111SF, LGDT3305).  I'm
> currently using DVBv3 API in my programs but am open to switching to
> the DVBv5 API if necessary.
>
> I applied Antti Palosaari's "si2157: implement signal strength stats"
> patch to the media_build and dvb-fe-tool with dvbv5-zap now returns
> relatively accurate RSSI data in dBm from the HVR955Q but no SNR or
> packet error data. dvb-fe-tool provides a full set of data
> (unformatted) from the Aero-M but only Lock and RSSI (formatted in
> dBm) from the HVR955Q.
>
> The SNR and packet error data is available from the HVR955Q in raw
> form in DVBv3 applications like femon. The Si2157 RSSI in dBm is not.
> The DVBv3 apps show the "signal quality" based on SNR margin above
> threshold from the LGDT3306A.
>
> Any suggestions on modifying the HVR955Q driver to provide RSSI
> (unformatted is okay) from the Si2157 with the DVBv3 API? That's
> preferred since it will work with my existing Aero-M signal testing
> programs.
>
> Alternatively, is there a way to obtain full DVBv5 API compliant
> signal quality data (RSSI, SNR, uncorrected packets) from the
> HVR955Q's LGDT3306A so I can modify my programs to use the linuxdvb.py
> API v5.1 bindings?

Looking the LGDT3306A code reveals it already calculates SNR as dB, so 
returning it via DVBv5 is easy.

BER and UCB are returned as a raw error values from registers. You could 
return those also as a error values by counter type easily (numerator of 
fraction). But getting some useful values you will need also total 
number of packets too (denominator) (error fraction = error count / 
total count). Total count is not mandatory, but very recommend, you have 
to find it some how, calculate from stream parameters for example.


regards
Antti

-- 
http://palosaari.fi/
