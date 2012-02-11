Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58100 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab2BKPdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Feb 2012 10:33:08 -0500
Message-ID: <4F368A31.7010607@iki.fi>
Date: Sat, 11 Feb 2012 17:33:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alistair Buxton <a.j.buxton@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
Subject: Re: SDR FM demodulation
References: <4F33DFB8.4080702@iki.fi> <CAO-Op+Fn0AxiqD4367O7H7AziR4g2vnFCMtsVcu1iRvf6P5iYw@mail.gmail.com> <4F36632A.3010700@iki.fi> <20120211151548.GA23806@minime.bse>
In-Reply-To: <20120211151548.GA23806@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.02.2012 17:15, Daniel Glöckner wrote:
> All in all, I don't think there can be one API that fits all devices
> without limiting their functionality. Maybe a UVC or LabVIEW like interface
> with blocks for tuners, ADCs, decimators, DMA sinks, etc. is suitable,
> but then applications will end up being tailored to a small number
> of topologies or require manual configuration. For most people the
> only use would probably be to listen to FM radio.

For me I would like to see that more interesting SDR than FM radio :)
I should look how famous USRP/USRP2 are connected to the GNU Radio and 
maybe try similar approach. I think it is userspace interface but it 
fits fine. It is always possible load device us normal Kernel driven 
DVB-T and if user like to use it as SDR then user should blacklist just 
kernel driver.

I opened my device and there is Elonics E4000 [1] silicon tuner. That 
tuner seems to be a little crazy beast! Supports frequencies from 64 to 
1678 MHz and very many modulations. So for my eyes it is almost idea 
cheap SDR. No idea what is supported max bw ADC can sample...

DVB-T (174-240MHz, 470-854MHz)
ISDB-T (470-862MHz)
DVB-H (470-854MHz, 1672-1678MHz)
CMMB (470-862MHz)
D-TMB (470-862MHz)
T-DMB (174-240MHz, 1452-1492MHz)
DAB (174-240MHz, 1452-1492MHz)
MediaFLO (470-862, 1452-1492MHz)
GPS L1 band (1575MHz)
FM radio (64-108MHz)


[1] http://www.elonics.com/product.do?id=1


regards
Antti
-- 
http://palosaari.fi/
