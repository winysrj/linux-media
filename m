Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36977 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbbBBRoz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 12:44:55 -0500
Received: from dyn3-82-128-188-129.psoas.suomi.net ([82.128.188.129] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1YIL3M-0006VC-VT
	for linux-media@vger.kernel.org; Mon, 02 Feb 2015 19:44:52 +0200
Message-ID: <54CFB794.2010507@iki.fi>
Date: Mon, 02 Feb 2015 19:44:52 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] rtl28xxu / rtl2830 / rtl2832 / rtl2832_sdr changes
References: <54B6E50F.9050506@iki.fi>
In-Reply-To: <54B6E50F.9050506@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PULL request update.


The following changes since commit ab98180ac2e6e41058f8829c0961aa306c610c16:

   [media] smipcie: return more proper value in interrupt handler 
(2015-02-02 14:42:53 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl28xx

for you to fetch changes up to 5dd18a43dfaa3a17f7f3ab9835ce55740cf20706:

   rtl2832_sdr: add kernel-doc comments for platform_data (2015-02-02 
19:41:31 +0200)

----------------------------------------------------------------
Antti Palosaari (67):
       dvb-usb-v2: add pointer to 'struct usb_interface' for driver usage
       rtl2832: convert driver to I2C binding
       rtl2830: convert driver to kernel I2C model
       rtl28xxu: use I2C binding for RTL2830 demod driver
       rtl2830: get rid of legacy DVB driver binding
       rtl2830: rename 'priv' to 'dev'
       rtl2830: carry pointer to I2C client for every function
       rtl2830: fix logging
       rtl2830: get rid of internal config data
       rtl2830: style related changes
       rtl2830: implement DVBv5 CNR statistic
       rtl2830: implement DVBv5 signal strength statistics
       rtl2830: implement DVBv5 BER statistic
       rtl2830: wrap DVBv5 signal strength to DVBv3
       rtl2830: wrap DVBv5 BER to DVBv3
       rtl2830: wrap DVBv5 CNR to DVBv3 SNR
       rtl2830: implement PID filter
       rtl28xxu: add support for RTL2831U/RTL2830 PID filter
       rtl2830: implement own I2C locking
       rtl2830: convert to regmap API
       rtl2832: add platform data callbacks for exported resources
       rtl28xxu: use rtl2832 demod callbacks accessing its resources
       rtl2832: remove exported resources
       rtl2832: rename driver state variable from 'priv' to 'dev'
       rtl2832: enhance / fix logging
       rtl2832: move all configuration to platform data struct
       rtl28xxu: use platform data config for rtl2832 demod
       rtl2832: convert to regmap API
       rtl2832: implement DVBv5 CNR statistic
       rtl2832: implement DVBv5 BER statistic
       rtl2832: wrap DVBv5 CNR to DVBv3 SNR
       rtl2832: wrap DVBv5 BER to DVBv3
       rtl2832: implement DVBv5 signal strength statistics
       rtl28xxu: use demod mux I2C adapter for every tuner
       rtl2832: drop FE i2c gate control support
       rtl2832: define more demod lock statuses
       rtl2832: implement PID filter
       rtl28xxu: add support for RTL2832U/RTL2832 PID filter
       rtl2832: use regmap reg cache
       rtl2832: remove unneeded software reset from init()
       rtl2832: merge reg page as a part of reg address
       rtl2832: provide register IO callbacks
       rtl2832_sdr: rename state variable from 's' to 'dev'
       rtl2832_sdr: convert to platform driver
       rtl28xxu: switch SDR module to platform driver
       rtl28xxu: use master I2C adapter for slave demods
       rtl2832_sdr: fix logging
       rtl2832_sdr: cleanups
       rtl2832: cleanups and minor changes
       rtl2832: claim copyright and module author
       rtl2832: implement sleep
       rtl28xxu: fix DVB FE callback
       rtl28xxu: simplify FE callback handling
       rtl28xxu: do not refcount rtl2832_sdr module
       rtl2832_sdr: refcount to rtl28xxu
       rtl2832: remove internal mux I2C adapter
       rtl28xxu: rename state variable 'priv' to 'dev'
       rtl28xxu: fix logging
       rtl28xxu: move usb buffers to state
       rtl28xxu: add heuristic to detect chip type
       rtl28xxu: merge chip type specific all callbacks
       rtl28xxu: merge rtl2831u and rtl2832u properties
       rtl28xxu: correct reg access routine name prefixes
       rtl2832: implement own lock for regmap
       rtl2830: add kernel-doc comments for platform_data
       rtl2832: add kernel-doc comments for platform_data
       rtl2832_sdr: add kernel-doc comments for platform_data

  drivers/media/dvb-frontends/Kconfig         |    4 +-
  drivers/media/dvb-frontends/rtl2830.c       |  944 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------
  drivers/media/dvb-frontends/rtl2830.h       |   79 +++-------
  drivers/media/dvb-frontends/rtl2830_priv.h  |   24 +--
  drivers/media/dvb-frontends/rtl2832.c       | 1341 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------
  drivers/media/dvb-frontends/rtl2832.h       |  107 ++++---------
  drivers/media/dvb-frontends/rtl2832_priv.h  |   31 ++--
  drivers/media/dvb-frontends/rtl2832_sdr.c   | 1189 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------------
  drivers/media/dvb-frontends/rtl2832_sdr.h   |   57 ++++---
  drivers/media/usb/dvb-usb-v2/dvb_usb.h      |    2 +
  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |    1 +
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |  881 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h     |   26 +++-
  13 files changed, 2416 insertions(+), 2270 deletions(-)







On 01/14/2015 11:52 PM, Antti Palosaari wrote:
> The following changes since commit
> cb9564e133f4f790920d715714790512085bb2e3:
>
>    [media] rc: img-ir: add philips rc6 decoder module (2014-12-23
> 15:17:31 -0200)
>
> are available in the git repository at:
>
>    git://linuxtv.org/anttip/media_tree.git rtl28xx
>
> for you to fetch changes up to 6fbbe5eee8bda5642a884180216ef498bc46d18f:
>
>    rtl2832: implement own lock for regmap (2014-12-23 22:48:29 +0200)
>
> ----------------------------------------------------------------
> Antti Palosaari (66):
>        dvb-usb-v2: add pointer to 'struct usb_interface' for driver usage
>        rtl2832: convert driver to I2C binding
>        rtl28xxu: switch rtl2832 demod attach to I2C binding
>        rtl28xxu: change module unregister order
>        rtl2830: convert driver to kernel I2C model
>        rtl28xxu: use I2C binding for RTL2830 demod driver
>        rtl2830: get rid of legacy DVB driver binding
>        rtl2830: rename 'priv' to 'dev'
>        rtl2830: carry pointer to I2C client for every function
>        rtl2830: fix logging
>        rtl2830: get rid of internal config data
>        rtl2830: style related changes
>        rtl2830: implement DVBv5 CNR statistic
>        rtl2830: implement DVBv5 signal strength statistics
>        rtl2830: implement DVBv5 BER statistic
>        rtl2830: wrap DVBv5 signal strength to DVBv3
>        rtl2830: wrap DVBv5 BER to DVBv3
>        rtl2830: wrap DVBv5 CNR to DVBv3 SNR
>        rtl2830: implement PID filter
>        rtl28xxu: add support for RTL2831U/RTL2830 PID filter
>        rtl2830: implement own I2C locking
>        rtl2830: convert to regmap API
>        rtl2832: add platform data callbacks for exported resources
>        rtl28xxu: use rtl2832 demod callbacks accessing its resources
>        rtl2832: remove exported resources
>        rtl2832: rename driver state variable from 'priv' to 'dev'
>        rtl2832: enhance / fix logging
>        rtl2832: move all configuration to platform data struct
>        rtl28xxu: use platform data config for rtl2832 demod
>        rtl2832: convert to regmap API
>        rtl2832: implement DVBv5 CNR statistic
>        rtl2832: implement DVBv5 BER statistic
>        rtl2832: wrap DVBv5 CNR to DVBv3 SNR
>        rtl2832: wrap DVBv5 BER to DVBv3
>        rtl2832: implement DVBv5 signal strength statistics
>        rtl28xxu: use demod mux I2C adapter for every tuner
>        rtl2832: drop FE i2c gate control support
>        rtl2832: define more demod lock statuses
>        rtl2832: implement PID filter
>        rtl28xxu: add support for RTL2832U/RTL2832 PID filter
>        rtl2832: use regmap reg cache
>        rtl2832: remove unneeded software reset from init()
>        rtl2832: merge reg page as a part of reg address
>        rtl2832: provide register IO callbacks
>        rtl2832_sdr: rename state variable from 's' to 'dev'
>        rtl2832_sdr: convert to platform driver
>        rtl28xxu: switch SDR module to platform driver
>        rtl28xxu: use master I2C adapter for slave demods
>        rtl2832_sdr: fix logging
>        rtl2832_sdr: cleanups
>        rtl2832: cleanups and minor changes
>        rtl2832: claim copyright and module author
>        rtl2832: implement sleep
>        rtl28xxu: fix DVB FE callback
>        rtl28xxu: simplify FE callback handling
>        rtl28xxu: do not refcount rtl2832_sdr module
>        rtl2832_sdr: refcount to rtl28xxu
>        rtl2832: remove internal mux I2C adapter
>        rtl28xxu: rename state variable 'priv' to 'dev'
>        rtl28xxu: fix logging
>        rtl28xxu: move usb buffers to state
>        rtl28xxu: add heuristic to detect chip type
>        rtl28xxu: merge chip type specific all callbacks
>        rtl28xxu: merge rtl2831u and rtl2832u properties
>        rtl28xxu: correct reg access routine name prefixes
>        rtl2832: implement own lock for regmap
>
>   drivers/media/dvb-frontends/Kconfig         |    4 +-
>   drivers/media/dvb-frontends/rtl2830.c       |  944
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------
>
>   drivers/media/dvb-frontends/rtl2830.h       |   54 ++-----
>   drivers/media/dvb-frontends/rtl2830_priv.h  |   24 +--
>   drivers/media/dvb-frontends/rtl2832.c       | 1341
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------
>
>   drivers/media/dvb-frontends/rtl2832.h       |   88 +++--------
>   drivers/media/dvb-frontends/rtl2832_priv.h  |   32 ++--
>   drivers/media/dvb-frontends/rtl2832_sdr.c   | 1189
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------------
>
>   drivers/media/dvb-frontends/rtl2832_sdr.h   |   51 +++---
>   drivers/media/usb/dvb-usb-v2/dvb_usb.h      |    2 +
>   drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |    1 +
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |  939
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------
>
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.h     |   27 +++-
>   13 files changed, 2499 insertions(+), 2197 deletions(-)
>

-- 
http://palosaari.fi/
