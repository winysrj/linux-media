Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35731 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbcJJLpB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 07:45:01 -0400
Received: by mail-io0-f196.google.com with SMTP id p26so7186317ioo.2
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 04:44:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5e53e19c-80df-523f-2d93-5c94b80ba22d@iki.fi>
References: <cover.1475860773.git.mchehab@s-opensource.com> <5e53e19c-80df-523f-2d93-5c94b80ba22d@iki.fi>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Mon, 10 Oct 2016 07:44:53 -0400
Message-ID: <CAOcJUbxv_jm4SVtPYpm=+jhFh_0cFx4-h_N8gZoQ9r2+nqULOg@mail.gmail.com>
Subject: Re: [PATCH 00/26] Don't use stack for DMA transers on dvb-usb drivers
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti makes a very good point.  If we consider a situation where we
are streaming data while concurrently checking frontend status and
polling for IR codes, some locking will certainly be required in all
of these drivers.

-Mike Krufky

On Mon, Oct 10, 2016 at 7:24 AM, Antti Palosaari <crope@iki.fi> wrote:
> Hello
> If you use usb buffers from the state you will need add lock in order to
> protect concurrent access to buffer. There may have multiple concurrent
> operations from rc-polling/demux/frontend. Lets say you are reading ber and
> it sets data to buffer (state), then context switch to remote controller
> polling => buffer in state is overwritten, then context is changed back to
> ber reading and now there is bad data.
>
> regards
> Antti
>
>
>
> On 10/07/2016 08:24 PM, Mauro Carvalho Chehab wrote:
>>
>> Sending URB control messages from stack was never supported. Yet, on x86,
>> the stack was usually at a memory region that allows DMA transfer.
>>
>> So, several drivers got it wrong. On Kernel 4.9, if VMAP_STACK=y, none of
>> those drivers will work, as the stack won't be on a DMA-able area anymore.
>>
>> So, fix the dvb-usb drivers that requre it.
>>
>> Please notice that, while all those patches compile, I don't have devices
>> using those drivers to test. So, I really appreciate if people with
>> devices
>> using those drivers could test and report if they don't break anything.
>>
>> Thanks!
>> Mauro
>>
>> Mauro Carvalho Chehab (26):
>>   af9005: don't do DMA on stack
>>   cinergyT2-core: don't do DMA on stack
>>   cinergyT2-core:: handle error code on RC query
>>   cinergyT2-fe: cache stats at cinergyt2_fe_read_status()
>>   cinergyT2-fe: don't do DMA on stack
>>   cxusb: don't do DMA on stack
>>   dib0700: be sure that dib0700_ctrl_rd() users can do DMA
>>   dib0700_core: don't use stack on I2C reads
>>   dibusb: don't do DMA on stack
>>   dibusb: handle error code on RC query
>>   digitv: don't do DMA on stack
>>   dtt200u-fe: don't do DMA on stack
>>   dtt200u-fe: handle errors on USB control messages
>>   dtt200u: don't do DMA on stack
>>   dtt200u: handle USB control message errors
>>   dtv5100: : don't do DMA on stack
>>   gp8psk: don't do DMA on stack
>>   gp8psk: don't go past the buffer size
>>   nova-t-usb2: don't do DMA on stack
>>   pctv452e: don't do DMA on stack
>>   pctv452e: don't call BUG_ON() on non-fatal error
>>   technisat-usb2: use DMA buffers for I2C transfers
>>   dvb-usb: warn if return value for USB read/write routines is not
>>     checked
>>   nova-t-usb2: handle error code on RC query
>>   dw2102: return error if su3000_power_ctrl() fails
>>   digitv: handle error code on RC query
>>
>>  drivers/media/usb/dvb-usb/af9005.c          | 211
>> +++++++++++++++-------------
>>  drivers/media/usb/dvb-usb/cinergyT2-core.c  |  52 ++++---
>>  drivers/media/usb/dvb-usb/cinergyT2-fe.c    |  91 ++++--------
>>  drivers/media/usb/dvb-usb/cxusb.c           |  20 +--
>>  drivers/media/usb/dvb-usb/cxusb.h           |   5 +
>>  drivers/media/usb/dvb-usb/dib0700_core.c    |  31 +++-
>>  drivers/media/usb/dvb-usb/dib0700_devices.c |  25 ++--
>>  drivers/media/usb/dvb-usb/dibusb-common.c   | 112 +++++++++++----
>>  drivers/media/usb/dvb-usb/dibusb.h          |   5 +
>>  drivers/media/usb/dvb-usb/digitv.c          |  26 ++--
>>  drivers/media/usb/dvb-usb/digitv.h          |   3 +
>>  drivers/media/usb/dvb-usb/dtt200u-fe.c      |  90 ++++++++----
>>  drivers/media/usb/dvb-usb/dtt200u.c         |  80 +++++++----
>>  drivers/media/usb/dvb-usb/dtv5100.c         |  10 +-
>>  drivers/media/usb/dvb-usb/dvb-usb.h         |   6 +-
>>  drivers/media/usb/dvb-usb/dw2102.c          |   2 +-
>>  drivers/media/usb/dvb-usb/gp8psk.c          |  25 +++-
>>  drivers/media/usb/dvb-usb/nova-t-usb2.c     |  25 +++-
>>  drivers/media/usb/dvb-usb/pctv452e.c        | 118 ++++++++--------
>>  drivers/media/usb/dvb-usb/technisat-usb2.c  |  16 ++-
>>  20 files changed, 577 insertions(+), 376 deletions(-)
>>
>
> --
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
