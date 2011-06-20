Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47746 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab1FTXAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 19:00:45 -0400
Received: by qyk29 with SMTP id 29so1774082qyk.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 16:00:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DFFBBC5.2080503@iki.fi>
References: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>
	<4DF49E2A.9030804@iki.fi>
	<BANLkTi=dGyN8SEwwAStD0Ob99k+FKkQPFg@mail.gmail.com>
	<BANLkTik=37qHUx273bSRN91HeyYrtUv6og@mail.gmail.com>
	<BANLkTi=gdVhVKjF4tqUwy+DxFv9imUipHw@mail.gmail.com>
	<4DFFB56B.3000802@iki.fi>
	<BANLkTikYWVU814UWNAZFTTC9dX43Ydy4sA@mail.gmail.com>
	<4DFFBABD.3040302@iki.fi>
	<4DFFBBC5.2080503@iki.fi>
Date: Tue, 21 Jun 2011 01:00:44 +0200
Message-ID: <BANLkTik3Nj0DqOsF50UM_JR5A7w3v19GuQ@mail.gmail.com>
Subject: Re: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
From: Rune Evjen <rune.evjen@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/20 Antti Palosaari <crope@iki.fi>:
> On 06/21/2011 12:25 AM, Antti Palosaari wrote:
>>
>> On 06/21/2011 12:20 AM, Rune Evjen wrote:
>>>
>>> 2011/6/20 Antti Palosaari<crope@iki.fi>:
>>>>
>>>> LNA is controlled by demod GPIO line. I don't remember if it is on or
>>>> off
>>>> for DVB-C currently. Look em28xx-dvb.c file, you can disable or
>>>> enable it
>>>> from there (needs re-compiling driver).
>>>>
>>>> I also saw BER counter running some muxes during development, but I
>>>> think
>>>> all channels I have are still working. And I didn't even have time to
>>>> optimal parameters for tuner / demod. I will try to examine those
>>>> later...
>>>>
>>> Thank you Antti,
>>>
>>> I will test with lna disabled in the em28xx-dvb module
>>>
>>> In line 349 of the code, I see this:
>>> /* enable LNA for DVB-T2 and DVB-C */
>>> .gpio_dvbt2[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
>>> .gpio_dvbc[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
>>>
>>> I suspect I should modify line 351, what should it be changed to ?
>>
>> Remove corresponding line (.gpio_dvbc[0]).
>
> Or change CXD2820R_GPIO_L => CXD2820R_GPIO_H. Have to check that too, I
> suspect removing it leaves it Hi-Z (which could result same).
>
>
Thank you Antti,

I just wanted to report back on the LNA issue.

I compiled and tested with line 351 commented out, and with debug
enabled for em28xx-dvb and cxd2820r, and got some errors in syslog
[1].

I have now tested the following:
a. drivers from media_build, w/o debug option on
-> I am able to watch QAM-64 channels, but not QAM-256 channels
(distorted picture and sound)
b. drivers from media_build, with debug option on
-> No locks on any channel
c. Modified em28xx-dvb (line 351 commented out),
-> I am able to watch QAM-64 channels with quite a lot of artifacts,
but not QAM-256 channels. Scanning gives error as described in [1]

Thank you for your assistance so far!

Best regards,

Rune


[1] syslog output when scanning

Jun 21 00:45:46 server kernel: [  397.784043] cxd2820r: cxd2820r_init: delsys=1
Jun 21 00:45:46 server kernel: [  397.784051] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:46 server kernel: [  397.787404] cxd2820r:
cxd2820r_get_tune_settings: delsys=1
Jun 21 00:45:46 server kernel: [  397.787411] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:46 server kernel: [  397.787433] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 21 00:45:46 server kernel: [  397.787438] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:46 server kernel: [  397.787444] cxd2820r:
cxd2820r_set_frontend_c: RF=354000000 SR=6950000
Jun 21 00:45:46 server kernel: [  397.787449] cxd2820r: cxd2820r_gpio: delsys=1
Jun 21 00:45:46 server kernel: [  397.987515] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 21 00:45:46 server kernel: [  397.987523] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:46 server kernel: [  397.988324] cxd2820r:
cxd2820r_read_status_c: lock=05 5a
Jun 21 00:45:46 server kernel: [  398.007081] em28xx #0/2-dvb: URB
packet 0, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:46 server kernel: [  398.007090] em28xx #0/2-dvb: URB
packet 1, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:46 server kernel: [  398.007097] em28xx #0/2-dvb: URB
packet 2, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:46 server kernel: [  398.007103] em28xx #0/2-dvb: URB
packet 3, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:46 server kernel: [  398.351148] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 21 00:45:46 server kernel: [  398.351153] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:46 server kernel: [  398.351998] cxd2820r:
cxd2820r_read_status_c: lock=05 5a
Jun 21 00:45:46 server kernel: [  398.352006] cxd2820r:
cxd2820r_get_frontend: delsys=1
Jun 21 00:45:46 server kernel: [  398.352010] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:46 server kernel: [  398.359552] cxd2820r:
cxd2820r_get_tune_settings: delsys=1
Jun 21 00:45:46 server kernel: [  398.359557] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:46 server kernel: [  398.359576] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 21 00:45:46 server kernel: [  398.359580] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:46 server kernel: [  398.359586] cxd2820r:
cxd2820r_set_frontend_c: RF=362000000 SR=6950000
Jun 21 00:45:46 server kernel: [  398.359591] cxd2820r: cxd2820r_gpio: delsys=1
Jun 21 00:45:47 server kernel: [  398.559650] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 21 00:45:47 server kernel: [  398.559657] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:47 server kernel: [  398.560510] cxd2820r:
cxd2820r_read_status_c: lock=05 5a
Jun 21 00:45:47 server kernel: [  398.579142] em28xx #0/2-dvb: URB
packet 0, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:47 server kernel: [  398.579152] em28xx #0/2-dvb: URB
packet 1, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:47 server kernel: [  398.921283] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 21 00:45:47 server kernel: [  398.921290] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:47 server kernel: [  398.922051] cxd2820r:
cxd2820r_read_status_c: lock=05 5a
Jun 21 00:45:47 server kernel: [  398.922056] cxd2820r:
cxd2820r_get_frontend: delsys=1
Jun 21 00:45:47 server kernel: [  398.922060] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:47 server kernel: [  398.931623] cxd2820r:
cxd2820r_get_tune_settings: delsys=1
Jun 21 00:45:47 server kernel: [  398.931628] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:47 server kernel: [  398.931680] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 21 00:45:47 server kernel: [  398.931684] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:47 server kernel: [  398.931690] cxd2820r:
cxd2820r_set_frontend_c: RF=370000000 SR=6950000
Jun 21 00:45:47 server kernel: [  398.931695] cxd2820r: cxd2820r_gpio: delsys=1
Jun 21 00:45:47 server kernel: [  399.131713] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 21 00:45:47 server kernel: [  399.131718] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:47 server kernel: [  399.132572] cxd2820r:
cxd2820r_read_status_c: lock=05 5a
Jun 21 00:45:47 server kernel: [  399.151203] em28xx #0/2-dvb: URB
packet 0, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:47 server kernel: [  399.151212] em28xx #0/2-dvb: URB
packet 1, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:48 server kernel: [  399.491277] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 21 00:45:48 server kernel: [  399.491283] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:48 server kernel: [  399.492114] cxd2820r:
cxd2820r_read_status_c: lock=05 5a
Jun 21 00:45:48 server kernel: [  399.492120] cxd2820r:
cxd2820r_get_frontend: delsys=1
Jun 21 00:45:48 server kernel: [  399.492124] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:48 server kernel: [  399.663569] cxd2820r:
cxd2820r_get_tune_settings: delsys=1
Jun 21 00:45:48 server kernel: [  399.663574] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:48 server kernel: [  399.663604] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 21 00:45:48 server kernel: [  399.663611] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:48 server kernel: [  399.663617] cxd2820r:
cxd2820r_set_frontend_c: RF=378000000 SR=6950000
Jun 21 00:45:48 server kernel: [  399.663622] cxd2820r: cxd2820r_gpio: delsys=1
Jun 21 00:45:48 server kernel: [  399.863666] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 21 00:45:48 server kernel: [  399.863672] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:48 server kernel: [  399.864528] cxd2820r:
cxd2820r_read_status_c: lock=05 5a
Jun 21 00:45:48 server kernel: [  399.883278] em28xx #0/2-dvb: URB
packet 0, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:48 server kernel: [  399.883287] em28xx #0/2-dvb: URB
packet 1, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:48 server kernel: [  399.883294] em28xx #0/2-dvb: URB
packet 2, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:48 server kernel: [  399.883300] em28xx #0/2-dvb: URB
packet 3, status -71 [Bit-stuff error (bad cable?)].
Jun 21 00:45:48 server kernel: [  400.221282] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 21 00:45:48 server kernel: [  400.221289] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:48 server kernel: [  400.222069] cxd2820r:
cxd2820r_read_status_c: lock=05 5a
Jun 21 00:45:48 server kernel: [  400.222075] cxd2820r:
cxd2820r_get_frontend: delsys=1
Jun 21 00:45:48 server kernel: [  400.222079] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:49 server kernel: [  400.730765] cxd2820r: cxd2820r_sleep: delsys=1
Jun 21 00:45:49 server kernel: [  400.730772] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 21 00:45:49 server kernel: [  400.730776] cxd2820r: cxd2820r_sleep_c
Jun 21 00:45:49 server kernel: [  400.732621] cxd2820r:
cxd2820r_unlock: active_fe=1
