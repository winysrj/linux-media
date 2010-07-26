Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:40816 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614Ab0GZPRb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 11:17:31 -0400
Message-ID: <4C4DA709.3090706@arcor.de>
Date: Mon, 26 Jul 2010 17:17:29 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 bad marge staging/tm6000 into staging/all
References: <4C4BE78A.4090002@arcor.de> <4C4C7B51.3000608@redhat.com>
In-Reply-To: <4C4C7B51.3000608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Am 25.07.2010 19:58, schrieb Mauro Carvalho Chehab:
> Em 25-07-2010 04:28, Stefan Ringel escreveu:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hi Mauro,
>>
>> This marge are wrong! It's added double dvb led off, but my patch has
>> only ones.
>>
>> raw | combined (merge: 011906d 6e5e76f)
>>
>> Merge branch 'staging/tm6000' into staging/all
>> Mauro Carvalho Chehab [Sun, 4 Jul 2010 19:33:26 +0000 (16:33 -0300)]
>>
>> * staging/tm6000: (29 commits)
>>    tm6000: Partially revert some copybuf logic
>>    tm6000: Be sure that the new buffer is empty
>>    tm6000: Fix copybuf continue logic Signed-off-by: Mauro Carvalho
>> Chehab<mchehab@redhat.com>
>>    tm6000: audio packet has always 180 bytes
>>    tm6000: Improve set bitrate routines used by alsa
>>    tm6000-alsa: Implement a routine to store data received from URB
>>    tm6000-alsa: Fix several bugs at the driver initialization code
>>    tm6000: avoid unknown symbol tm6000_debug
>>    tm6000: Add a callback code for buffer fill
>>    tm6000: Use an emum for extension type
>>    tm6000-alsa: rework audio buffer allocation/deallocation
>>    tm6000: Avoid OOPS when loading tm6000-alsa module
>>    tm6000: Fix compilation breakages
>>    V4L/DVB: Staging: tm6000: Fix coding style issues
>>    V4L/DVB: tm6000: move dvb into a separate kern module
>>    V4L/DVB: tm6000: rewrite init and fini
>>    V4L/DVB: tm6000: Fix Video decoder initialization
>>    V4L/DVB: tm6000: rewrite copy_streams
>>    V4L/DVB: tm6000: add DVB support for tuner xc5000
>>    V4L/DVB: tm6000: set variable dev_mode in function tm6000_start_stream
>>    ...
>>
>> diff --cc drivers/staging/tm6000/tm6000-core.c
>>
>> index 27f3f55,1fea5a0..9f60ad5
>> - --- 1/drivers/staging/tm6000/tm6000-core.c
>> - --- 2/drivers/staging/tm6000/tm6000-core.c
>> +++ b/drivers/staging/tm6000/tm6000-core.c
>> @@@ -336,11 -332,11 +332,17 @@@ int tm6000_init_analog_mode(struct tm60
>>          mutex_unlock(&dev->lock);
>>
>>          msleep(100);
>> - -       tm6000_set_standard (dev,&dev->norm);
>> - -       tm6000_set_audio_bitrate (dev,48000);
>> +       tm6000_set_standard(dev,&dev->norm);
>> +       tm6000_set_audio_bitrate(dev, 48000);
>> +
>> +       /* switch dvb led off */
>> +       if (dev->gpio.dvb_led) {
>> ++              tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>> ++                      dev->gpio.dvb_led, 0x01);
>> ++      }
>>   +
>>   +      /* switch dvb led off */
>>   +      if (dev->gpio.dvb_led) {
>>                  tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
>>                          dev->gpio.dvb_led, 0x01);
>>          }
> I hate those merge conflicts ;)
>
> could you please send me a patch fixing it at staging/all? I won't apply it
> upstream, but we shouldn't simply revert a patch at staging, otherwise, we'll
> break every clone of my tree.
cannot found staging/all.
>>
>>
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v2.0.12 (MingW32)
>> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>>
>> iQEcBAEBAgAGBQJMS+eJAAoJEAWtPFjxMvFGDw8IAJnmTxTehH4TeqwI3Gn+8gcn
>> Xp8VPH/F67npT3zHQMq4luBEWdnMKkI/y54en8czoqG+EHEnxZjFZUxJUkAKPbpd
>> pU9vVUrQGtUQOf7zY6qYSqaSPIJr+abTmE1k2Wnd47Zwlu35tfRhuVXqfrTu7JkT
>> /Jy4Xf/IOtJvCa62eDCnhB6+gAq+hj5peHiZb7KBxOQO1NH8DQ8DYQPT9xNn5SFs
>> mCmQv9BdNrLdXS4mCkufBWEinennolOIoaSIyj2GkvJm8aSvzIWGvm28zxjPLKPL
>> PLH7A+WPMHCdor7Psn7QJKCm3DPEKu3vcOTOmFYsBJfV/pUNMK+5y3qV1WP9Ayg=
>> =HCq5
>> -----END PGP SIGNATURE-----
>>

