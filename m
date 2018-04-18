Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35532 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751444AbeDREtl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 00:49:41 -0400
Received: by mail-qt0-f195.google.com with SMTP id s2-v6so499942qti.2
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 21:49:40 -0700 (PDT)
Received: from mail-qk0-f170.google.com (mail-qk0-f170.google.com. [209.85.220.170])
        by smtp.gmail.com with ESMTPSA id x203sm289910qka.77.2018.04.17.21.49.39
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Apr 2018 21:49:39 -0700 (PDT)
Received: by mail-qk0-f170.google.com with SMTP id c136so473567qkb.12
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 21:49:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180409091441.GX4043@hirez.programming.kicks-ass.net>
References: <CAAZRmGz8iTDSZ6S=05V0JKDXBnS47e43MBBSvnGtrVv-QioirA@mail.gmail.com>
 <20180409091441.GX4043@hirez.programming.kicks-ass.net>
From: Olli Salonen <olli.salonen@iki.fi>
Date: Wed, 18 Apr 2018 06:49:38 +0200
Message-ID: <CAAZRmGw9DTHX65cYch6ozjGejMnDNQx_aNF-RYPRo+E4COEoRA@mail.gmail.com>
Subject: Re: Regression: DVBSky S960 USB tuner doesn't work in 4.10 or newer
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nibble Max <nibble.max@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        wsa@the-dreams.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for your response Peter!

Indeed, it seems strange. dvbsky.c driver seems to use mutex_lock in
very much the same way as many other drivers. I've now confirmed that
I can get a 4.10 kernel with working DVBSky S960 by reverting the
following 4 patches:

549bdd3 Revert "locking/mutex: Add lock handoff to avoid starvation"
3210f31 Revert "locking/mutex: Restructure wait loop"
418a170 Revert "locking/mutex: Simplify some ww_mutex code in
__mutex_lock_common()"
0b1fb8f Revert "locking/mutex: Enable optimistic spinning of woken waiter"
c470abd Linux 4.10

The other 3 three I need to revert to be able to revert 9d659ae.

I added some more debugging into the DVBsky driver to better
understand what's happening.

After the point when the fault starts any I2C read from the m88ds3103
demodulator provides answer "07 ff 49 00" or a subset of it. Before
13:59:42 there are no I2C reads returning an answer starting with 07.

Apr 10 13:59:42 nucserver kernel: [ 4744.048206]
dvb_usb_dvbsky:dvbsky_rc_query: usb 1-1:
Apr 10 13:59:42 nucserver kernel: [ 4744.048319]
dvb_usb_dvbsky:dvbsky_usb_generic_rw: usb 1-1: write: 10, read: ff ff
Apr 10 13:59:42 nucserver kernel: [ 4744.080229]
dvb_usb_dvbsky:dvbsky_usb_read_status: usb 1-1:
Apr 10 13:59:42 nucserver kernel: [ 4744.080245]
dvb_usb_dvbsky:dvbsky_i2c_xfer: usb 1-1: num: 2
Apr 10 13:59:42 nucserver kernel: [ 4744.080915]
dvb_usb_dvbsky:dvbsky_usb_generic_rw: usb 1-1: write: 09 01 01 68 0d,
read: 08 01
Apr 10 13:59:42 nucserver kernel: [ 4744.080931]
m88ds3103:m88ds3103_read_status: m88ds3103 4-0068: lock=01 status=00
Apr 10 13:59:42 nucserver kernel: [ 4744.080943]
m88ds3103:m88ds3103_set_frontend: m88ds3103 4-0068: delivery_system=6
modulation=9 frequency=1097000 symbol_rate=23000000 inversion=2
pilot=2 rolloff=0
Apr 10 13:59:42 nucserver kernel: [ 4744.080953]
dvb_usb_dvbsky:dvbsky_i2c_xfer: usb 1-1: num: 1
Apr 10 13:59:42 nucserver kernel: [ 4744.081452]
dvb_usb_dvbsky:dvbsky_usb_generic_rw: usb 1-1: write: 08 68 02 07 80,
read: 08
Apr 10 13:59:42 nucserver kernel: [ 4744.081562]
dvb_usb_dvbsky:dvbsky_i2c_xfer: usb 1-1: num: 2
Apr 10 13:59:42 nucserver kernel: [ 4744.082263]
dvb_usb_dvbsky:dvbsky_usb_generic_rw: usb 1-1: write: 09 01 01 68 3f,
read: 08 ff
Apr 10 13:59:42 nucserver kernel: [ 4744.082287]
dvb_usb_dvbsky:dvbsky_i2c_xfer: usb 1-1: num: 1
Apr 10 13:59:42 nucserver kernel: [ 4744.082706]
dvb_usb_dvbsky:dvbsky_usb_generic_rw: usb 1-1: write: 08 68 02 03 11,
read: 07
Apr 10 13:59:42 nucserver kernel: [ 4744.082715]
dvb_usb_dvbsky:dvbsky_i2c_xfer: usb 1-1: num: 2
Apr 10 13:59:42 nucserver kernel: [ 4744.083119]
dvb_usb_dvbsky:dvbsky_usb_generic_rw: usb 1-1: write: 09 01 01 60 3d,
read: 07 ff
Apr 10 13:59:42 nucserver kernel: [ 4744.083230]
dvb_usb_dvbsky:dvbsky_i2c_xfer: usb 1-1: num: 1
Apr 10 13:59:42 nucserver kernel: [ 4744.083645]
dvb_usb_dvbsky:dvbsky_usb_generic_rw: usb 1-1: write: 08 68 02 07 00,
read: 07
Apr 10 13:59:42 nucserver kernel: [ 4744.083752]
dvb_usb_dvbsky:dvbsky_i2c_xfer: usb 1-1: num: 1
Apr 10 13:59:42 nucserver kernel: [ 4744.084114]
dvb_usb_dvbsky:dvbsky_usb_generic_rw: usb 1-1: write: 08 68 02 03 11,
read: 07
Apr 10 13:59:42 nucserver kernel: [ 4744.084130]
dvb_usb_dvbsky:dvbsky_i2c_xfer: usb 1-1: num: 2
Apr 10 13:59:42 nucserver kernel: [ 4744.084484]
dvb_usb_dvbsky:dvbsky_usb_generic_rw: usb 1-1: write: 09 01 01 60 21,
read: 07 ff

I really cannot see any obvious link between the mutexes and the I2C
operations starting to fail, but indeed the device starts to work as
normal if I revert that patch.

Cheers,
-olli


On 9 April 2018 at 11:14, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Apr 04, 2018 at 02:41:51PM +0300, Olli Salonen wrote:
>> Hello Peter and Max,
>>
>> I noticed that when using kernel 4.10 or newer my DVBSky S960 and
>> S960CI satellite USB TV tuners stopped working properly. Basically,
>> they will fail at one point when tuning to a channel. This typically
>> takes less than 100 tuning attempts. For perspective, when performing
>> a full channel scan on my system, the tuner tunes at least 500 times.
>> After the tuner fails, I need to reboot the PC (probably unloading the
>> driver and loading it again would do).
>>
>> 2018-04-04 10:17:36.756 [   INFO] mpegts: 12149H in 4.8E - tuning on
>> Montage Technology M88DS3103 : DVB-S #0
>> 2018-04-04 10:17:37.159 [  ERROR] diseqc: failed to send diseqc cmd
>> (e=Connection timed out)
>> 2018-04-04 10:17:37.160 [   INFO] mpegts: 12265H in 4.8E - tuning on
>> Montage Technology M88DS3103 : DVB-S #0
>> 2018-04-04 10:17:37.535 [  ERROR] diseqc: failed to send diseqc cmd
>> (e=Connection timed out)
>>
>> I did a kernel bisect between 4.9 and 4.10. It seems the commit that
>> breaks my tuner is the following one:
>>
>> 9d659ae14b545c4296e812c70493bfdc999b5c1c is the first bad commit
>> commit 9d659ae14b545c4296e812c70493bfdc999b5c1c
>> Author: Peter Zijlstra <peterz@infradead.org>
>> Date:   Tue Aug 23 14:40:16 2016 +0200
>>
>>     locking/mutex: Add lock handoff to avoid starvation
>>
>> I couldn't easily revert that commit only. I can see that the
>> drivers/media/usb/dvb-usb-v2/dvbsky.c driver does use mutex_lock() and
>> mutex_lock_interruptible() in a few places.
>>
>> Do you guys see anything that's obviously wrong in the way the mutexes
>> are used in dvbsky.c or anything in that particular patch that could
>> cause this issue?
>
> Nothing, sorry.. really weird. That driver looks fairly straight forward
> with respect to mutex usage (although obviously I have less than 0 clue
> on the whole usb media thing).
>
> That it breaks that driver would suggest something funny with it though;
> because the kernel has loads and loads of mutexes in and they all appear
> to work well with that patch -- in fact, it fixed a reported starvation
> case.
>
> The only way for that patch to affect things is if there is contention
> on the mutex though; so who or what is also trying to acquire the mutex?
>
> The reported error is a timeout, suggesting that whoever is contending
> on the lock is keeping it held too long? I do notice that
> dvbsky_stream_ctrl() has an msleep() while holding a mutex.
>
> Do you have any idea which of the 3 (afaict) mutexes in that driver is
> failing? Going by the fact that it's failing to send, I'd hazard a guess
> it's the i2c mutex, but again, I have less than 0 clues about i2c.
>
