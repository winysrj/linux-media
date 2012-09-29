Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35679 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab2I2SmC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 14:42:02 -0400
Message-ID: <506740E5.1030708@iki.fi>
Date: Sat, 29 Sep 2012 21:41:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.7] all the rest patches!
References: <5064CFEF.7040301@iki.fi> <50657B0C.70706@iki.fi>
In-Reply-To: <50657B0C.70706@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated, one new USB ID for RTL2832U.

The following changes since commit 8928b6d1568eb9104cc9e2e6627d7086437b2fb3:

   [media] media: mx2_camera: use managed functions to clean up code 
(2012-09-27 15:56:47 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git for_v3.7_mauro-3

for you to fetch changes up to bf342b50ac6c5801a95d6a089086587446c8d6cf:

   rtl28xxu: [0ccd:00d3] TerraTec Cinergy T Stick RC (Rev. 3) 
(2012-09-29 21:39:26 +0300)

----------------------------------------------------------------
Antti Palosaari (5):
       em28xx: implement FE set_lna() callback
       cxd2820r: use static GPIO config when GPIOLIB is undefined
       em28xx: do not set PCTV 290e LNA handler if fe attach fail
       em28xx: PCTV 520e workaround for DRX-K fw loading
       rtl28xxu: [0ccd:00d3] TerraTec Cinergy T Stick RC (Rev. 3)

Gianluca Gennari (3):
       fc2580: define const as UL to silence a warning
       fc2580: silence uninitialized variable warning
       fc2580: use macro for 64 bit division and reminder

  drivers/media/dvb-frontends/cxd2820r_core.c | 29 
++++++++++++++++++++---------
  drivers/media/tuners/fc2580.c               |  7 +++----
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |  2 ++
  drivers/media/usb/em28xx/em28xx-dvb.c       | 61 
++++++++++++++++++++++++++++++++++++++++++++++++++-----------
  4 files changed, 75 insertions(+), 24 deletions(-)



On 09/28/2012 01:25 PM, Antti Palosaari wrote:
> PULL request updated, contains now 3 fc2580 driver fixes from  Gianluca
> Gennari. Could you handle these quickly :)
>
> The following changes since commit
> 8928b6d1568eb9104cc9e2e6627d7086437b2fb3:
>
>    [media] media: mx2_camera: use managed functions to clean up code
> (2012-09-27 15:56:47 -0300)
>
> are available in the git repository at:
>
>    git://linuxtv.org/anttip/media_tree.git for_v3.7_mauro-3
>
> for you to fetch changes up to 5c3cc06e4922d2d6a050948181a8601281227c66:
>
>    fc2580: use macro for 64 bit division and reminder (2012-09-28
> 13:18:56 +0300)
>
> ----------------------------------------------------------------
> Antti Palosaari (4):
>        em28xx: implement FE set_lna() callback
>        cxd2820r: use static GPIO config when GPIOLIB is undefined
>        em28xx: do not set PCTV 290e LNA handler if fe attach fail
>        em28xx: PCTV 520e workaround for DRX-K fw loading
>
> Gianluca Gennari (3):
>        fc2580: define const as UL to silence a warning
>        fc2580: silence uninitialized variable warning
>        fc2580: use macro for 64 bit division and reminder
>
>   drivers/media/dvb-frontends/cxd2820r_core.c | 29
> ++++++++++++++++++++---------
>   drivers/media/tuners/fc2580.c               |  7 +++----
>   drivers/media/usb/em28xx/em28xx-dvb.c       | 61
> ++++++++++++++++++++++++++++++++++++++++++++++++++-----------
>   3 files changed, 73 insertions(+), 24 deletions(-)
>
>
> On 09/28/2012 01:15 AM, Antti Palosaari wrote:
>> Mauro,
>> New attempt. I really want that "PCTV 520e workaround for DRX-K fw
>> loading" in too or find out other fix quickly. I have answered too many
>> bug reports according to it currently. Will take debugs now...
>>
>> regards
>> Antti
>>
>>
>> The following changes since commit
>> 8928b6d1568eb9104cc9e2e6627d7086437b2fb3:
>>
>>    [media] media: mx2_camera: use managed functions to clean up code
>> (2012-09-27 15:56:47 -0300)
>>
>> are available in the git repository at:
>>
>>    git://linuxtv.org/anttip/media_tree.git for_v3.7_mauro-2
>>
>> for you to fetch changes up to 2baf1e9dd547402b8a5748e66f894af9c6a2789a:
>>
>>    em28xx: PCTV 520e workaround for DRX-K fw loading (2012-09-28
>> 01:06:38 +0300)
>>
>> ----------------------------------------------------------------
>> Antti Palosaari (4):
>>        em28xx: implement FE set_lna() callback
>>        cxd2820r: use static GPIO config when GPIOLIB is undefined
>>        em28xx: do not set PCTV 290e LNA handler if fe attach fail
>>        em28xx: PCTV 520e workaround for DRX-K fw loading
>>
>>   drivers/media/dvb-frontends/cxd2820r_core.c | 29
>> ++++++++++++++++++++---------
>>   drivers/media/usb/em28xx/em28xx-dvb.c       | 61
>> ++++++++++++++++++++++++++++++++++++++++++++++++++-----------
>>   2 files changed, 70 insertions(+), 20 deletions(-)
>>
>>
>
>


-- 
http://palosaari.fi/
