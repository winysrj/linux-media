Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:56284 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZHQVUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 17:20:40 -0400
Received: by fxm11 with SMTP id 11so14996fxm.39
        for <linux-media@vger.kernel.org>; Mon, 17 Aug 2009 14:20:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <37219a840908171359m152363a2ub377abe6e27ff237@mail.gmail.com>
References: <bc18792f0908171325s391d9e36nb0ce20f40017678@mail.gmail.com>
	 <37219a840908171359m152363a2ub377abe6e27ff237@mail.gmail.com>
Date: Mon, 17 Aug 2009 16:20:39 -0500
Message-ID: <bc18792f0908171420x3a395795r5cd4afba05e32df4@mail.gmail.com>
Subject: Re: [linux-dvb] au0828: experimental support for Syntek Teledongle
	[05e1:0400]
From: Malcolm Lewis <coyoteuser@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 17, 2009 at 3:59 PM, Michael Krufky<mkrufky@kernellabs.com> wrote:
> On Mon, Aug 17, 2009 at 4:25 PM, Malcolm Lewis<coyoteuser@gmail.com> wrote:
>> Hi
>> I've been using the patches from
>> http://linuxtv.org/hg/~mkrufky/teledongle/rev/676e2f4475ed
>> on a Sabrent device in openSuSE and SLED, during testing with the
>> milestone 5 release of
>> 11.2 and kernel version 2.6.31-rc5-git3-2-desktop there needs to be
>> some changes to the
>> au0828-cards.c patch to enable building a kmp module;
>>
>> --- au0828-cards.c    2009-08-12 18:16:39.435886920 -0500
>> +++ au0828-cards.c.orig    2009-08-12 18:28:22.176126368 -0500
>> @@ -116,6 +116,12 @@
>>          .tuner_addr = ADDR_UNSET,
>>          .i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
>>      },
>> +    [AU0828_BOARD_SYNTEK_TELEDONGLE] = {
>> +        .name = "Syntek Teledongle [EXPERIMENTAL]",
>> +         .tuner_type = UNSET,
>> +        .tuner_addr = ADDR_UNSET,
>> +        .i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
>> +    },
>>  };
>>
>>  /* Tuner callback function for au0828 boards. Currently only needed
>> @@ -248,6 +254,7 @@
>>      case AU0828_BOARD_HAUPPAUGE_HVR950Q:
>>      case AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL:
>>      case AU0828_BOARD_HAUPPAUGE_WOODBURY:
>> +    case AU0828_BOARD_SYNTEK_TELEDONGLE: /* FIXME */
>>          /* GPIO's
>>           * 4 - CS5340
>>           * 5 - AU8522 Demodulator
>> @@ -325,6 +332,8 @@
>>          .driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
>>      { USB_DEVICE(0x2040, 0x8200),
>>          .driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
>> +    { USB_DEVICE(0x05e1, 0x0400),
>> +                .driver_info = AU0828_BOARD_SYNTEK_TELEDONGLE },
>>      { },
>>  };
>>
>>
>> There are two versions I'm building and src for both can be found here;
>> http://download.opensuse.org/repositories/home:/malcolmlewis/
>
>
> Malcolm,
>
> I would strongly advise against distributing packages based on these
> patches... This code was never merged into the master branch because
> it has potential to break devices at the hardware level, and it will
> create a support nightmare, based on the fact that there are multiple
> UNLIKE devices that use the same USB ID but actually contain different
> hardware components.  As the patch may enable support for ONE of the
> variations, nobody has ever verified that the GPIO programming is safe
> to use, and there is no way to prevent the potentially harmful code
> from running on the wrong device.
>
> I, personally, do not want the responsibility of explaining to users
> that their usb sticks may be damaged because of code that got merged
> into the kernel -- that's why the code is in a separate repository
> until the issues can be dealt with.  In general, users know that if
> they have to manually apply patches themselves, that they are doing so
> at their own risk.
>
> If you succeed in getting your device to work, please let me know -- I
> will be very interested to hear about it.
>
> Good Luck,
>
> Mike
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
Hi Mike
Ahh, OK :) I can confirm I've had no issues using it with smplayer on
openSuSE 11.0, openSuSE 11.1 and openSuSE 11.2 M5 i586 (ViA Artigo and
ASUS 1000HE) and SLED 11 x86_64 (home build AMD 4400 X2 system).
System tunes into FTA HDTV great, have scan in different areas and all
scanned channels found have worked. (I'm in Mississippi)

I'm happy to do further testing if you can advise on what is required.

-- 
Cheers
Malcolm
