Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41895 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3KDLEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 06:04:21 -0500
Received: by mail-pd0-f175.google.com with SMTP id g10so6472258pdj.20
        for <linux-media@vger.kernel.org>; Mon, 04 Nov 2013 03:04:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131104085823.6c843100@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
	<1383399097-11615-29-git-send-email-m.chehab@samsung.com>
	<CAOcJUbzNZUE0RxM+2wcgfHnPudq+H7mzbKjY0QaO6L0pdq+Gsw@mail.gmail.com>
	<20131104085823.6c843100@samsung.com>
Date: Mon, 4 Nov 2013 06:04:20 -0500
Message-ID: <CAOcJUbws2WZs4QyzVwEoJw1FdPX4wrm_7YPw=icCh-Q0SGvbpQ@mail.gmail.com>
Subject: Re: [PATCHv2 28/29] mxl111sf: Don't use dynamic static allocation
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 4, 2013 at 5:58 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Sun, 3 Nov 2013 19:50:02 -0500
> Michael Krufky <mkrufky@kernellabs.com> escreveu:
>
>> On Sat, Nov 2, 2013 at 9:31 AM, Mauro Carvalho Chehab
>> <m.chehab@samsung.com> wrote:
>> > Dynamic static allocation is evil, as Kernel stack is too low, and
>> > compilation complains about it on some archs:
>> >
>> >         drivers/media/usb/dvb-usb-v2/mxl111sf.c:74:1: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]
>> >
>> > Instead, let's enforce a limit for the buffer to be the max size of
>> > a control URB payload data (80 bytes).
>> >
>> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>> > Cc: Michael Krufky <mkrufky@kernellabs.com>
>> > ---
>> >  drivers/media/usb/dvb-usb-v2/mxl111sf.c | 7 ++++++-
>> >  1 file changed, 6 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
>> > index e97964ef7f56..6538fd54c84e 100644
>> > --- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
>> > +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
>> > @@ -57,7 +57,12 @@ int mxl111sf_ctrl_msg(struct dvb_usb_device *d,
>> >  {
>> >         int wo = (rbuf == NULL || rlen == 0); /* write-only */
>> >         int ret;
>> > -       u8 sndbuf[1+wlen];
>> > +       u8 sndbuf[80];
>> > +
>> > +       if (1 + wlen > sizeof(sndbuf)) {
>> > +               pr_warn("%s: len=%d is too big!\n", __func__, wlen);
>> > +               return -EREMOTEIO;
>> > +       }
>> >
>> >         pr_debug("%s(wlen = %d, rlen = %d)\n", __func__, wlen, rlen);
>> >
>> > --
>> > 1.8.3.1
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> I don't really love this, but I see your point. You're right - this
>> needs to be fixed.
>>
>> AFAIK, the largest transfer the driver ever does is 61 bytes, but I'd
>> have to double check to be sure...
>>
>> Is there a #define'd macro that we could place there instead of the
>> hardcoded '80' ?  I really don't like the number '80' there,
>> *especially* not without a comment explaining it.  Is 80 even the
>> maximum size of control urb payload data?  Are you sure it isn't 64?
>>
>> http://wiki.osdev.org/Universal_Serial_Bus#Maximum_Data_Payload_Size
>>
>> ...as per the article above, we should be able to read the actual
>> maximum size from the USB endpoint itself, but then again, that would
>> leave us with another dynamic static allocation.
>
> There's one driver using 80 bytes for payload (tm6000). Anyway,
> I double-checked at USB 2.0 specification: the max size for
> control endpoints is 64 bytes for full-speed devices:
>
>         "All Host Controllers are required to have support for 8-, 16-, 32-, and 64-byte maximum data payload sizes
>          for full-speed control endpoints, only 8-byte maximum data payload sizes for low-speed control endpoints,
>          and only 64-byte maximum data payload size for high-speed control endpoints. No Host Controller is
>          required to support larger or smaller maximum data payload sizes."
>
>         Source: USB revision 2.0 - chapter 5.5.3 Control Transfer Packet Size Constraints
>                 http://www.usb.org/developers/docs/usb_20_070113.zip
>
> So, except for devices that violates that, the worse case scenario is
> 64 bytes.
>
> It should be noticed that the I2C bus could use a different limit,
> so, on PCI devices, in theory, it would be possible to use a larger
> window.
>
> Yet, I doubt that any sane tuner/frontend design would require a
> packet size bigger than the max size supported by the USB bus, as
> that would limit their usage. Also, most (if not all) of those
> tuners/frontends were added due to USB devices, anyway.
>
>>
>> How about if we kzalloc the buffer instead?  (maybe not - that isn't
>> very efficient either)
>
> Seems an overkill to me to create/delete a buffer for every single I2C
> transfer. Of course, a latter patch could optimize the buffer size to
> match what's supported by the hardware, or to use a pre-allocated buffer,
> but this is out of my scope: all I want is to get rid of dynamically
> allocated buffers. I don't intend to read all those datasheets and
> optimize each of those drivers, especially since I may not have the
> hardware here for testing.
>
>> If it has to be a static allocation (and it probably should be),
>> please #define the size rather than sticking in the number 80.
>
> Ok.
>
>> This feedback applies to your entire "Don't use dynamic static
>> allocation" patch series.  Please don't merge those without at least
>> #define'ing the size value and adding an appropriate inline comment to
>> explain why the maximum is defined as such.
>
> Well, a comment is provided already at the commit message. I don't
> see any need to overbloat the code with a comment like that. In any
> case, if I were to add a comment, it would be something like:
>         "I guess x bytes would be enough"
>
> As only doing a deep code inspection and reading the datasheets, we'll
> know for sure what's the maximum size supported by each device.
>
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'd really prefer to also see an inline comment, because just in case
we cause a new bug here that may not get identified until time goes
by, the inline comment will give the next developer some clue as to
why this size limit exists.

Then again, if the #define'd macro name is descriptive enough, then
maybe that would be fine.

Thanks & best regards,

Mike

(apologies for sending this twice - accidentally dropped cc to the
list the first time :-P )
