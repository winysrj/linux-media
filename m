Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:51999 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753271AbdKJUd7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 15:33:59 -0500
Received: by mail-qk0-f196.google.com with SMTP id n66so13384355qki.8
        for <linux-media@vger.kernel.org>; Fri, 10 Nov 2017 12:33:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171107084245.47dce306@vento.lan>
References: <CACG2urxXyivORcKhgZf=acwA8ajz5UspHf8YTHEQJG=VauqHpg@mail.gmail.com>
 <20171023094305.nxrxsqjrrwtygupc@gofer.mess.org> <CACG2urzPV2q63-bLP98cHDDqzP3a-oydDScPqG=tVKSCzxREBg@mail.gmail.com>
 <20171023185750.5m5qo575myogzbhz@gofer.mess.org> <CACG2urzH5dAtnasGfjiK1Y8owGcsn0VtRSEWX75A6mb0pyuSRw@mail.gmail.com>
 <20171029193121.p2q6dxxz376cpx5y@gofer.mess.org> <CACG2urwdnXs2v8hv24R3+sNW6qOifh6Gtt+semez_c8QC58-gA@mail.gmail.com>
 <20171107084245.47dce306@vento.lan>
From: Laurent Caumont <lcaumont2@gmail.com>
Date: Fri, 10 Nov 2017 21:33:58 +0100
Message-ID: <CACG2ury9Ab3pHGVyNLQeOH03TF3r_oeX1h3=AuJ5XzNgjx+yag@mail.gmail.com>
Subject: Re: 'LITE-ON USB2.0 DVB-T Tune' driver crash with kernel 4.13 /
 ubuntu 17.10
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I could send you a patch but my git doesn't see the modification I
made, so it's unable to generate a patch.
I don't know if it's a git issue on ubunu 17.10 or if it's the way the
repository was created.

Laurent

2017-11-07 11:42 GMT+01:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> Hi Sean/Laurent,
>
> Care sending me a final version of the patch?
>
> Thanks!
> Mauro
>
> Em Mon, 30 Oct 2017 21:59:34 +0100
> Laurent Caumont <lcaumont2@gmail.com> escreveu:
>
>> Hi Sean,
>>
>> I found the problem. The read buffer needs to be allocated with kmalloc too.
>>
>> int dibusb_read_eeprom_byte(struct dvb_usb_device *d, u8 offs, u8 *val)
>> {
>>           u8 *wbuf;
>>           u8 *rbuf;
>>           int rc;
>>
>>           rbuf = kmalloc(1, GFP_KERNEL);
>>           if (!rbuf)
>>             return -ENOMEM;
>>
>>           wbuf = kmalloc(1, GFP_KERNEL);
>>           if (!wbuf)
>>             return -ENOMEM;
>>
>>          *wbuf = offs;
>>
>>          rc = dibusb_i2c_msg(d, 0x50, wbuf, 1, rbuf, 1);
>>          kfree(wbuf);
>>          *val = *rbuf;
>>          kfree(rbuf);
>>
>>         return rc;
>> }
>>
>> It works now.
>> Please update the code in the main branch for futur versions.
>> Thanks.
>> Regards,
>> Laurent
>>
>> 2017-10-29 20:31 GMT+01:00 Sean Young <sean@mess.org>:
>> > On Sun, Oct 29, 2017 at 06:54:28PM +0100, Laurent Caumont wrote:
>> >> Hi Sean,
>> >>
>> >> I recompiled the modules by following the
>> >> https://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>> >> page and applied the patch.
>> >> But I still have problems (see below). It doesn't seem to be the same callstack.
>> >> Is it the right way to get the fix ?
>> >
>> > Yes, it's the right way to get the fix. However, you've hit a new problem
>> > of a similar making. Please can you try with this patch as well:
>> >
>> > Thanks
>> > Sean
>> > ---
>> > From 84efb0bf72ae5d9183f25d69d95fb9ad9b9bc644 Mon Sep 17 00:00:00 2001
>> > From: Sean Young <sean@mess.org>
>> > Date: Sun, 29 Oct 2017 19:28:32 +0000
>> > Subject: [PATCH] media: dibusb: don't do DMA on stack
>> >
>> > The USB control messages require DMA to work. We cannot pass
>> > a stack-allocated buffer, as it is not warranted that the
>> > stack would be into a DMA enabled area.
>> >
>> > Signed-off-by: Sean Young <sean@mess.org>
>> > ---
>> >  drivers/media/usb/dvb-usb/dibusb-common.c | 14 ++++++++++++--
>> >  1 file changed, 12 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
>> > index 8207e6900656..18c6e454b1b7 100644
>> > --- a/drivers/media/usb/dvb-usb/dibusb-common.c
>> > +++ b/drivers/media/usb/dvb-usb/dibusb-common.c
>> > @@ -223,8 +223,18 @@ EXPORT_SYMBOL(dibusb_i2c_algo);
>> >
>> >  int dibusb_read_eeprom_byte(struct dvb_usb_device *d, u8 offs, u8 *val)
>> >  {
>> > -       u8 wbuf[1] = { offs };
>> > -       return dibusb_i2c_msg(d, 0x50, wbuf, 1, val, 1);
>> > +       u8 *wbuf;
>> > +       int rc;
>> > +
>> > +       wbuf = kmalloc(1, GFP_KERNEL);
>> > +       if (!wbuf)
>> > +               return -ENOMEM;
>> > +
>> > +       *wbuf = offs;
>> > +       rc = dibusb_i2c_msg(d, 0x50, wbuf, 1, val, 1);
>> > +       kfree(wbuf);
>> > +
>> > +       return rc;
>> >  }
>> >  EXPORT_SYMBOL(dibusb_read_eeprom_byte);
>> >
>> > --
>> > 2.13.6
>> >
>
>
>
> Thanks,
> Mauro
