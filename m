Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:19113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab0EMUO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 16:14:27 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1307344fga.1
        for <linux-media@vger.kernel.org>; Thu, 13 May 2010 13:14:25 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: stv090x vs stv0900
Date: Thu, 13 May 2010 23:14:16 +0300
Cc: Manu Abraham <abraham.manu@gmail.com>,
	"Igor M. Liplianin" <liplianin@netup.ru>,
	linux-media@vger.kernel.org
References: <1273135577.16031.11.camel@plop> <201005092134.45226.liplianin@me.by> <1273491848.14370.22.camel@plop>
In-Reply-To: <1273491848.14370.22.camel@plop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005132314.16569.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

В сообщении от 10 мая 2010 14:44:08 автор Pascal Terjan написал:
> Le dimanche 09 mai 2010 à 21:34 +0300, Igor M. Liplianin a écrit :
> > On 6 мая 2010 11:46:17 Pascal Terjan wrote:
> > > Hi,
> > > 
> > > I was adding support for a non working version of DVBWorld HD 2104
> > > 
> > > It is listed on
> > > http://www.linuxtv.org/wiki/index.php/DVBWorld_HD_2104_FTA_USB_Box as :
> > > 
> > > =====
> > > for new solution : 2104B (Sharp0169 Tuner)
> > > 
> > >       * STV6110A tuner
> > >       * ST0903 demod
> > >       * Cyrix CY7C68013A USB controller
> > > 
> > > =====
> > > 
> > > The 2104A is supposed to be working and also have ST0903 but uses
> > > stv0900, so I tried using it too but did not manage to get it working.
> > 
> > But it working. I have the device and test it succesfully.
> 
> OK, but the B does not here while it seems to work with stv090x
> 
> All I get in log with femon is
> 
> stv0900_read_status: <7>DEMOD LOCK FAIL
> <6>stv0900_get_rf_level
> <6>stv0900_get_rf_level: RFLevel = -100
> <6>stv0900_carr_get_quality
> 
> And with scandvb :
> 
> stv0900_read_status: <7>DEMOD LOCK FAIL
> stv0900_read_status: <7>DEMOD LOCK FAIL
> stv0900_read_status: <7>DEMOD LOCK FAIL
> stv0900_read_status: <7>DEMOD LOCK FAIL
> <6>stv0900_search: <7>stv0900_set_tuner: Frequency=1939000
> stv0900_set_tuner: Bandwidth=72000000
> <6>stv0900_activate_s2_modcode
> <6>Search Fail
> stv0900_read_status: <7>DEMOD LOCK FAIL
> 
> > So modprobe dvb-usb-dw2102 demod=2 brings DVBWorld 2104A to you on golden
> > plate.
> 
> Yes but this one is 2104B
OK, modprobe dvb-usb-dw2102 demod=2 brings DVBWorld 2104B to you on golden plate
Look what I was tested already:
    1. DVB-S2 USB 2104A (EARDA4B47, STB6100 + ST0903)
    2. DVB-S2 USB 2104B (sharp0169, stv6110A + ST0903)
    3. DVB-S2 USB 2104C (cx24116) 
    4. DVB-S2 USB 2104D (montage_ts2020 + ds3000)
    5. DVB-S2 USB 2104E (SERIT2636, stv6110A + ST0903)

If someone interested:
md5sum dvb-usb-dw2104*.fw*
4cd4215e169c42f6d05cf23be2edd907  dvb-usb-dw2104.fw
4cd4215e169c42f6d05cf23be2edd907  dvb-usb-dw2104.fw.keep
9ccab99bdd4a0f252455d08dee189794  dvb-usb-dw2104d.fw
9ccab99bdd4a0f252455d08dee189794  dvb-usb-dw2104e.fw

BR
Igor
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
