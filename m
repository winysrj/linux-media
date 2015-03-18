Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:32960 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbbCRKo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 06:44:29 -0400
Received: by lbbzq9 with SMTP id zq9so26449723lbb.0
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2015 03:44:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEmZozNLC_2pUD9h2vQeVMUQvt0apHdWas=SEpeuftp4PYiRNw@mail.gmail.com>
References: <20150225223036.23353.77716.stgit@zeus.muc.hardeman.nu> <CAEmZozNLC_2pUD9h2vQeVMUQvt0apHdWas=SEpeuftp4PYiRNw@mail.gmail.com>
From: =?UTF-8?Q?David_Cimb=C5=AFrek?= <david.cimburek@gmail.com>
Date: Wed, 18 Mar 2015 11:43:56 +0100
Message-ID: <CAEmZozNTy1UUF9BrR+VxzJ145+o9swY=Vs+gyMubdJJxNbpuhw@mail.gmail.com>
Subject: Re: [PATCH] rc-core: fix dib0700 scancode generation for RC5
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

any progress?? Do you need some more debugging output from me?

Regards,
David


2015-02-26 19:14 GMT+01:00 David Cimbůrek <david.cimburek@gmail.com>:
> 2015-02-25 23:30 GMT+01:00 David Härdeman <david@hardeman.nu>:
>> David, could you please test this patch?
>> ---
>>  drivers/media/usb/dvb-usb/dib0700_core.c |   70 +++++++++++++++++-------------
>>  1 file changed, 40 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
>> index 50856db..605b090 100644
>> --- a/drivers/media/usb/dvb-usb/dib0700_core.c
>> +++ b/drivers/media/usb/dvb-usb/dib0700_core.c
>> @@ -658,10 +658,20 @@ out:
>>  struct dib0700_rc_response {
>>         u8 report_id;
>>         u8 data_state;
>> -       u8 system;
>> -       u8 not_system;
>> -       u8 data;
>> -       u8 not_data;
>> +       union {
>> +               struct {
>> +                       u8 system;
>> +                       u8 not_system;
>> +                       u8 data;
>> +                       u8 not_data;
>> +               } nec;
>> +               struct {
>> +                       u8 not_used;
>> +                       u8 system;
>> +                       u8 data;
>> +                       u8 not_data;
>> +               } rc5;
>> +       };
>>  };
>>  #define RC_MSG_SIZE_V1_20 6
>>
>> @@ -697,8 +707,8 @@ static void dib0700_rc_urb_completion(struct urb *purb)
>>
>>         deb_data("IR ID = %02X state = %02X System = %02X %02X Cmd = %02X %02X (len %d)\n",
>>                  poll_reply->report_id, poll_reply->data_state,
>> -                poll_reply->system, poll_reply->not_system,
>> -                poll_reply->data, poll_reply->not_data,
>> +                poll_reply->nec.system, poll_reply->nec.not_system,
>> +                poll_reply->nec.data, poll_reply->nec.not_data,
>>                  purb->actual_length);
>>
>>         switch (d->props.rc.core.protocol) {
>> @@ -707,30 +717,30 @@ static void dib0700_rc_urb_completion(struct urb *purb)
>>                 toggle = 0;
>>
>>                 /* NEC protocol sends repeat code as 0 0 0 FF */
>> -               if (poll_reply->system     == 0x00 &&
>> -                   poll_reply->not_system == 0x00 &&
>> -                   poll_reply->data       == 0x00 &&
>> -                   poll_reply->not_data   == 0xff) {
>> +               if (poll_reply->nec.system     == 0x00 &&
>> +                   poll_reply->nec.not_system == 0x00 &&
>> +                   poll_reply->nec.data       == 0x00 &&
>> +                   poll_reply->nec.not_data   == 0xff) {
>>                         poll_reply->data_state = 2;
>>                         break;
>>                 }
>>
>> -               if ((poll_reply->data ^ poll_reply->not_data) != 0xff) {
>> +               if ((poll_reply->nec.data ^ poll_reply->nec.not_data) != 0xff) {
>>                         deb_data("NEC32 protocol\n");
>> -                       keycode = RC_SCANCODE_NEC32(poll_reply->system     << 24 |
>> -                                                    poll_reply->not_system << 16 |
>> -                                                    poll_reply->data       << 8  |
>> -                                                    poll_reply->not_data);
>> -               } else if ((poll_reply->system ^ poll_reply->not_system) != 0xff) {
>> +                       keycode = RC_SCANCODE_NEC32(poll_reply->nec.system     << 24 |
>> +                                                    poll_reply->nec.not_system << 16 |
>> +                                                    poll_reply->nec.data       << 8  |
>> +                                                    poll_reply->nec.not_data);
>> +               } else if ((poll_reply->nec.system ^ poll_reply->nec.not_system) != 0xff) {
>>                         deb_data("NEC extended protocol\n");
>> -                       keycode = RC_SCANCODE_NECX(poll_reply->system << 8 |
>> -                                                   poll_reply->not_system,
>> -                                                   poll_reply->data);
>> +                       keycode = RC_SCANCODE_NECX(poll_reply->nec.system << 8 |
>> +                                                   poll_reply->nec.not_system,
>> +                                                   poll_reply->nec.data);
>>
>>                 } else {
>>                         deb_data("NEC normal protocol\n");
>> -                       keycode = RC_SCANCODE_NEC(poll_reply->system,
>> -                                                  poll_reply->data);
>> +                       keycode = RC_SCANCODE_NEC(poll_reply->nec.system,
>> +                                                  poll_reply->nec.data);
>>                 }
>>
>>                 break;
>> @@ -738,19 +748,19 @@ static void dib0700_rc_urb_completion(struct urb *purb)
>>                 deb_data("RC5 protocol\n");
>>                 protocol = RC_TYPE_RC5;
>>                 toggle = poll_reply->report_id;
>> -               keycode = RC_SCANCODE_RC5(poll_reply->system, poll_reply->data);
>> +               keycode = RC_SCANCODE_RC5(poll_reply->rc5.system, poll_reply->rc5.data);
>> +
>> +               if ((poll_reply->rc5.data ^ poll_reply->rc5.not_data) != 0xff) {
>> +                       /* Key failed integrity check */
>> +                       err("key failed integrity check: %02x %02x %02x %02x",
>> +                           poll_reply->rc5.not_used, poll_reply->rc5.system,
>> +                           poll_reply->rc5.data, poll_reply->rc5.not_data);
>> +                       goto resubmit;
>> +               }
>>
>>                 break;
>>         }
>>
>> -       if ((poll_reply->data + poll_reply->not_data) != 0xff) {
>> -               /* Key failed integrity check */
>> -               err("key failed integrity check: %02x %02x %02x %02x",
>> -                   poll_reply->system,  poll_reply->not_system,
>> -                   poll_reply->data, poll_reply->not_data);
>> -               goto resubmit;
>> -       }
>> -
>>         rc_keydown(d->rc_dev, protocol, keycode, toggle);
>>
>>  resubmit:
>>
>
> Hi David,
>
> yes! Your patch seems to work fine on my side, my remote is working again!
>
> Here is the relevant debug log (press and release of the "1" key):
>
> [ 4131.099573] IR ID = 01 state = 01 System = 00 07 Cmd = 0F F0 (len 6)
> [ 4131.099579] RC5 protocol
> [ 4131.099581] protocol = 03 keycode = 070F toggle = 01
> [ 4131.212813] IR ID = 01 state = 02 System = 00 07 Cmd = 0F F0 (len 6)
> [ 4131.212819] RC5 protocol
>
> This is the output of debug output which I added in
> dib0700_core.c:dib0700_rc_urb_completion() before the call of
> rc_keydown() function:
>
> deb_data("protocol = %02X keycode = %04X toggle = %02X\n", protocol,
> keycode, toggle);
> [ 4131.212821] protocol = 03 keycode = 070F toggle = 01
>
> Regards,
> David
