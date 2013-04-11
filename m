Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42727 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933975Ab3DKO5j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 10:57:39 -0400
Message-ID: <5166CF3A.5040603@iki.fi>
Date: Thu, 11 Apr 2013 17:56:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFC v2013-04-11] SDR API REQUIREMENT SPECIFICATION
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I added some new parameters as described.
Comments are welcome - I haven't got almost any up to date.

I will keep latest version of that document same old address:
http://palosaari.fi/linux/kernel_sdr_api_requirement_specification.txt

regards
Antti


LINUX KERNEL SDR API REQUIREMENT SPECIFICATION
=====================================================================


Ideal SDR specific requirements (basics SDR settings)
*********************************************************************

operation mode
*  values: ADC (Rx) or DAC (Tx)
*  operations
      GET, inquire what HW supports
      GET, get current value
      SET, set desired value

sampling resolution
*  values: 1 - 32 (unit: bit)
      16 bit could be enough, but better to leave some room for future
*  operations
      GET, inquire what HW supports
      GET, get current value
      SET, set desired value

sampling rate
*  values: 1 - infinity (unit: Hz, symbols per second)
      currently 500 MHz is more than enough
*  operations
      GET, inquire what HW supports
      GET, get current value
      SET, set desired value

TODO:
*  inversion?


Practical SDR specific requirements (SDR settings for RF tuner)
*********************************************************************

RF frequency
*  values: 1 - infinity (unit: Hz)
      currently 100 GHz is more than enough
*  operations
      GET, inquire what HW supports
        there could be unsupported ranges between lower and upper freq
      GET, get current value
      SET, set desired value

IF frequency (intermediate frequency)
*  values: 0 - infinity (unit: Hz)
      currently 500 MHz is more than enough
*  operations
      GET, get current value

tuner lock (frequency synthesizer / PLL)
*  values: yes/no
*  operations
      GET, get current value

tuner gains
*  gain and attenuation
*  there could be multiple places to adjust gain on tuner signal path
*  is single overall gain enough or do we want more manual fine tuning?

tuner filters
*  there could be multiple filters on tuner signal path (RF/IF)
*  do we need to control filters at all?
*  calculate from sampling rate?


TODO:
*  pass RF standard to tuner?
    Passing standard is clearly against idea, but some RF tuners does
    "black magic" according to standard. That magic is usually setting
    filters and and gains, but it could be more...

*  inversion?


Hardware specific requirements (board settings)
*********************************************************************

antenna switch
*  values: 0 - 32 (unit: piece)
*  operations
      GET, inquire what HW supports
      GET, get current value
      SET, set desired value

external LNA
*  values: -200000 - 200000 (unit: dB/1000)
*  operations
      GET, inquire what HW supports
      GET, get current value
      SET, set desired value
* range from -200dB to 200dB should be enough

multiple ADCs / DACs on single device
*  there could be multiple ADCs and DACs on single device
*  resources could be shared which limits concurrent usage
*  eg. device has 2 ADC + 2 DAC = 4 total, but only 2 could be used
    at the time


Kernel specific requirements
*********************************************************************

device locking between multiple APIs
*  same device could support multiple APIs which could not be used at
    same time
*  for example DVB API and V4L2 API
*  locking needed


DOCUMENT VERSION HISTORY
=====================================================================
2012-10-15 Antti Palosaari <crope@iki.fi>
* Initial version

2013-04-11 Antti Palosaari <crope@iki.fi>
* add version history
* order requirements per sections
* add IF frequency (intermediate frequency)
* add tuner lock (frequency synthesizer / PLL)
* add external LNA
* add TODOs

-- 
http://palosaari.fi/
