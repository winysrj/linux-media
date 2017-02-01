Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54948 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753359AbdBARXq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 12:23:46 -0500
Subject: Re: rtl2832_sdr and /dev/swradio0
To: Russel Winder <russel@winder.org.uk>,
        DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1485885027.10632.13.camel@winder.org.uk>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <a0d6afa8-74e8-1aeb-5a30-912e158735f7@iki.fi>
Date: Wed, 1 Feb 2017 19:23:43 +0200
MIME-Version: 1.0
In-Reply-To: <1485885027.10632.13.camel@winder.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/31/2017 07:50 PM, Russel Winder wrote:
> Hi,
>
> Is anyone actively working on the rtl2832_sdr driver?
>
> I am particularly interested in anyone who has code for turning the
> byte stream from /dev/swradio0 into an ETI stream. Or failing that
> getting enough data about the API for using /dev/swradio0 so as to
> write a byte sequence to ETI driver based on the dab2eti program in
> DABtool (which uses the librtlsdr mechanism instead of the
> /dev/swradio0 one).
>

Easiest way to test it just use v4l2-ctl to configure device and then 
read data from device file.

$ #set ADC 2M
$ v4l2-ctl -d /dev/swradio0 --tuner=0 --set-freq=2.000
Frequency for tuner 0 set to 2000000 (2.000000 MHz)
$ #set rf tuner 98.1MHz
$ v4l2-ctl -d /dev/swradio0 --tuner=1 --set-freq=98.1
Frequency for tuner 1 set to 98100000 (98.100000 MHz)
$ # dump 32 I/Q samples
$ cat /dev/swradio0 |hexdump -n 64 -C
00000000  80 80 7e 7d 84 84 70 71  a8 5f 74 9f 6e 53 b4 9d 
|..~}..pq._t.nS..|
00000010  53 8f 9e 4c 71 b8 75 28  a1 8a 57 8c 9d 46 73 c7 
|S..Lq.u(..W..Fs.|
00000020  79 60 a6 ae 36 82 94 60  6c bf 7e 6a a7 9e 55 73 
|y`..6..`l.~j..Us|
00000030  a8 72 5c a6 7f 35 a2 a2  61 54 ce 8a 57 b3 8e 50 
|.r\..5..aT..W..P|
00000040
$

Looking v4l2-ctl code could give some ideas how to use control IOCTLs. 
Data can be read both read() or mmap() method.


regards
Antti

-- 
http://palosaari.fi/
