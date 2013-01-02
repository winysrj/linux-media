Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44756 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab3ABBFZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 20:05:25 -0500
Message-ID: <50E387B0.6090904@iki.fi>
Date: Wed, 02 Jan 2013 03:04:48 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: get_dvb_firmware fails for a lot of firmwares
References: <CAFBinCA-gYcokd1jWheKhgJopD1-=+oO8_5CMrz_NqmfP+nvPg@mail.gmail.com>
In-Reply-To: <CAFBinCA-gYcokd1jWheKhgJopD1-=+oO8_5CMrz_NqmfP+nvPg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/01/2013 05:28 PM, Martin Blumenstingl wrote:
> Hi,
>
> while testing the firmware download for the drxk_terratec_htc_stick I
> found that many other firmware downloads are broken.
> Here is a list of failing downloads:
>
> cx231xx: Hash of extracted file does not match!
> drxk_hauppauge_hvr930c: Hash of extracted file does not match!
> sp8870: File does not exist anymore (returns HTML error page)
> http://www.softwarepatch.pl/9999ccd06a4813cb827dbb0005071c71/tt_Premium_217g.zip
> ngene: HTTP 404 http://www.digitaldevices.de/download/ngene_15.fw
> nxt2002: HTTP 404
> http://www.bbti.us/download/windows/Technisat_DVB-PC_4_4_COMPACT.zip
> nxt2004: HTTP 404
> http://www.avermedia-usa.com/support/Drivers/AVerTVHD_MCE_A180_Drv_v1.2.2.16.zip
> opera1: reports "Ran out of data"
> lme2510_lg: file LMEBDA_DVBS.sys is not being downloaded
> lme2510c_s7395: file US2A0D.sys is not being downloaded
> lme2510c_s7395_old: file LMEBDA_DVBS7395C.sys is not being downloaded
> tda10045: HTTP 404 http://www.technotrend.de/new/217g/tt_budget_217g.zip
> tda10046: server refuses connection (temporary error?)
> http://technotrend.com.ua/download/software/219/TT_PCI_2.19h_28_11_2006.zip
> tda10046lifeview: domain name does not resolve
> http://www.lifeview.hk/dbimages/document/7%5Cdrv_2.11.02.zip
> vp7041: connection reset (temporary error?)
> http://www.twinhan.com/files/driver/USB-Ter/2.422.zip
>
> Just in case the formatting is messed up: here is a copy of the list: [0].
>
> It seems that the gentoo guys mirrored some of the files which are
> getting a 404: [1].

I encourage you to fix those what you can and then ping others for the 
rest. Just try to find out if those files could be found from some other 
location and fix get_dvb_firmware paths.

regards
Antti


-- 
http://palosaari.fi/
