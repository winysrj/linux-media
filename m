Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:64802 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHORf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 13:35:59 -0400
Received: by mail-la0-f47.google.com with SMTP id mc6so2594673lab.34
        for <linux-media@vger.kernel.org>; Fri, 15 Aug 2014 10:35:57 -0700 (PDT)
Message-ID: <53EE4549.7050200@googlemail.com>
Date: Fri, 15 Aug 2014 19:37:13 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: fix compiler warnings
References: <53E080F6.30301@xs4all.nl> <53E0F5AE.2050903@googlemail.com> <53E32077.2070709@xs4all.nl> <53E3AB26.4070601@googlemail.com> <53E5F0B0.803@xs4all.nl>
In-Reply-To: <53E5F0B0.803@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 09.08.2014 um 11:58 schrieb Hans Verkuil:
> On 08/07/2014 06:36 PM, Frank Schäfer wrote:
>> Am 07.08.2014 um 08:45 schrieb Hans Verkuil:
>>> On 08/05/2014 05:18 PM, Frank Schäfer wrote:
>>>> Hi Hans,
>>>>
>>>> Am 05.08.2014 um 09:00 schrieb Hans Verkuil:
>>>>> Fix three compiler warnings:
>>>>>
>>>>> drivers/media/usb/em28xx/em28xx-input.c: In function ‘em28xx_i2c_ir_handle_key’:
>>>>> drivers/media/usb/em28xx/em28xx-input.c:318:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>>  }
>>>>>  ^
>>>>>   CC [M]  drivers/media/usb/em28xx/em28xx-dvb.o
>>>>> drivers/media/usb/em28xx/em28xx-camera.c: In function ‘em28xx_probe_sensor_micron’:
>>>>> drivers/media/usb/em28xx/em28xx-camera.c:199:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>>  }
>>>>>  ^
>>>>> drivers/media/usb/em28xx/em28xx-camera.c: In function ‘em28xx_probe_sensor_omnivision’:
>>>>> drivers/media/usb/em28xx/em28xx-camera.c:304:1: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>>  }
>>>>>  ^
>>>> Hmmm... I don't get these weird warnings.
>>>> How can I reproduce them ?
>>> I'm using gcc 4.9.1 and I'm compiling the kernel using just a regular make command.
>>> In my .config I have CONFIG_FRAME_WARN=1024.
>> Weird. With gcc version 4.8.1 20130909 [gcc-4_8-branch revision 202388]
>> I get much smaller frame sizes:
> Are you compiling for 32 or 64 bits? I'm compiling for 64 bits.

Ah yes, it was a 32 bit kernel.
With a 64 bit kernel I get frame sizes of 736-744 bytes.
Hmm... still much smaller than the 1088-1096 bytes gcc 4.9.1 reports...

>
>> ...
>> drivers/media/usb/em28xx/em28xx-input.c: In function
>> ‘em28xx_i2c_ir_handle_key’:
>> drivers/media/usb/em28xx/em28xx-input.c:318:1: warning: the frame size
>> of 424 bytes is larger than 256 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>> ...
>> drivers/media/usb/em28xx/em28xx-camera.c: In function
>> ‘em28xx_probe_sensor_micron’:
>> drivers/media/usb/em28xx/em28xx-camera.c:199:1: warning: the frame size
>> of 432 bytes is larger than 256 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>> ...
>> drivers/media/usb/em28xx/em28xx-camera.c: In function
>> ‘em28xx_probe_sensor_omnivision’:
>> drivers/media/usb/em28xx/em28xx-camera.c:304:1: warning: the frame size
>> of 428 bytes is larger than 256 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>> ...
[...]
>> 2.) i2c rc key polling:
>>
>> em28xx_i2c_ir_handle_key() passes the client structure to one of the 4
>> get_key functions
>>
>>     rc = ir->get_key_i2c(&client, &protocol, &scancode);
>>
>> which either call
>>
>>     i2c_transfer(client->adapter, msg, len)
>>
>> directly or the helper function
>>
>>     i2c_master_recv(client, buf, len))
>>
>> which creates an i2c message before calling i2c_transfer().
>> The only members used from the i2c_client struct are
>>
>>     msg.addr = client->addr;
>>     msg.flags = client->flags & I2C_M_TEN;
>>
>> So the only fields from struct i2c_client which need to be setup are
>> "adapter" and "addr" and "flags".
>> Adapter an addres are initialized properly to
>>
>>     client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
>>     client.addr = ir->i2c_dev_addr;
>>
>> The only thing which is indeed missing here and needs to be fixed is
>>
>>     client.flags = 0;
> Are there no debugging calls that use client.name? 

No, only adpater, address and flags are required/used for an i2c_transfer().

> Basically what I don't
> understand is why this isn't a proper i2c_client, registered and all and
> in its proper place in the /sys/ hierarchy.
>
> It feels very much like a quick hack. 

The ir i2c decoder is indeed a pure em28xx internal thing. No external
client driver is used.
Hence the code is straight forward.
The only benefit of registering an i2c_client would be to make it
available via sysfs.
I'm not sure If it's worth the amount of extra work+code.

> And if nothing else, at least zero
> the struct before use. That will make any problems that this hack causes
> reproducible instead of dependent on whatever random values were on the
> stack.

The only problem here is the missing initialization of field "flags".
It's a bug that needs to be fixed. Fortunately it doesn't cause any trouble.

In general, if structs with optional fields are used, the reader of the
code easily gets the feeling that something might be missing.
I know what I'm talking about... ;-)

A patch is in the works.

Regards,
Frank

> Regards,
>
> 	Hans

