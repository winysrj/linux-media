Return-path: <linux-media-owner@vger.kernel.org>
Received: from ryu.zarb.org ([212.85.158.22]:55109 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab0EJLoV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 07:44:21 -0400
Subject: Re: stv090x vs stv0900
From: Pascal Terjan <pterjan@mandriva.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	"Igor M. Liplianin" <liplianin@netup.ru>,
	linux-media@vger.kernel.org
In-Reply-To: <201005092134.45226.liplianin@me.by>
References: <1273135577.16031.11.camel@plop>
	 <201005092134.45226.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 13:44:08 +0200
Message-ID: <1273491848.14370.22.camel@plop>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le dimanche 09 mai 2010 à 21:34 +0300, Igor M. Liplianin a écrit :
> On 6 мая 2010 11:46:17 Pascal Terjan wrote:
> > Hi,
> >
> > I was adding support for a non working version of DVBWorld HD 2104
> >
> > It is listed on
> > http://www.linuxtv.org/wiki/index.php/DVBWorld_HD_2104_FTA_USB_Box as :
> >
> > =====
> > for new solution : 2104B (Sharp0169 Tuner)
> >
> >       * STV6110A tuner
> >       * ST0903 demod
> >       * Cyrix CY7C68013A USB controller
> > =====
> >
> > The 2104A is supposed to be working and also have ST0903 but uses
> > stv0900, so I tried using it too but did not manage to get it working.
> But it working. I have the device and test it succesfully.

OK, but the B does not here while it seems to work with stv090x

All I get in log with femon is

stv0900_read_status: <7>DEMOD LOCK FAIL
<6>stv0900_get_rf_level
<6>stv0900_get_rf_level: RFLevel = -100
<6>stv0900_carr_get_quality

And with scandvb :

stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
<6>stv0900_search: <7>stv0900_set_tuner: Frequency=1939000
stv0900_set_tuner: Bandwidth=72000000
<6>stv0900_activate_s2_modcode
<6>Search Fail
stv0900_read_status: <7>DEMOD LOCK FAIL

> So modprobe dvb-usb-dw2102 demod=2 brings DVBWorld 2104A to you on golden plate.

Yes but this one is 2104B

