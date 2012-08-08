Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40668 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932508Ab2HHJhn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Aug 2012 05:37:43 -0400
Received: by lagy9 with SMTP id y9so283560lag.19
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2012 02:37:39 -0700 (PDT)
Message-ID: <50223357.1020203@iki.fi>
Date: Wed, 08 Aug 2012 12:37:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: linux-media@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 2/2] dvb_usb_v2: use %*ph to dump usb xfer debugs
References: <1344380196-9488-1-git-send-email-crope@iki.fi> <1344380196-9488-2-git-send-email-crope@iki.fi> <CAHp75Vd=EiGvgWh=t22DTOx0=3x8EjC2wbcgXKba56YtSr22_w@mail.gmail.com>
In-Reply-To: <CAHp75Vd=EiGvgWh=t22DTOx0=3x8EjC2wbcgXKba56YtSr22_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2012 07:16 AM, Andy Shevchenko wrote:
> On Wed, Aug 8, 2012 at 1:56 AM, Antti Palosaari <crope@iki.fi> wrote:
>> diff --git a/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c
>> index 5f5bdd0..0431bee 100644
>> --- a/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c
>> +++ b/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c
>
>> @@ -37,10 +36,8 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
>>          if (ret < 0)
>>                  return ret;
>>
>> -#ifdef DVB_USB_XFER_DEBUG
>> -       print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": >>> ", DUMP_PREFIX_NONE,
>> -                       32, 1, wbuf, wlen, 0);
>> -#endif
>> +       dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, wlen, wbuf);
>> +
>>          ret = usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev,
>>                          d->props->generic_bulk_ctrl_endpoint), wbuf, wlen,
>>                          &actual_length, 2000);
>> @@ -64,11 +61,8 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
>>                          dev_err(&d->udev->dev, "%s: 2nd usb_bulk_msg() " \
>>                                          "failed=%d\n", KBUILD_MODNAME, ret);
>>
>> -#ifdef DVB_USB_XFER_DEBUG
>> -               print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": <<< ",
>> -                               DUMP_PREFIX_NONE, 32, 1, rbuf, actual_length,
>> -                               0);
>> -#endif
>> +               dev_dbg(&d->udev->dev, "%s: <<< %*ph\n", __func__,
>> +                               actual_length, rbuf);
>>          }
>>
> Antti, I didn't check how long buffer could be in above cases, but be
> aware that %*ph prints up to 64 bytes only. Is it enough here?

It is correct behavior. I saw from the LKML patch limit was selected 
using min_t() not causing any other side effect than cut print length.

For some cases it could be more than 64 here, likely for the firmware 
download packed. I suspect, situation where control message is longer 
than 64 byte does not exist in real life as USB1.1 BULK max is 64. And 
even such case exists, we are not interested those not printed bytes.

regards
Antti

-- 
http://palosaari.fi/
