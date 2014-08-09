Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4195 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaHIJ6Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 05:58:24 -0400
Message-ID: <53E5F0B0.803@xs4all.nl>
Date: Sat, 09 Aug 2014 11:58:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: fix compiler warnings
References: <53E080F6.30301@xs4all.nl> <53E0F5AE.2050903@googlemail.com> <53E32077.2070709@xs4all.nl> <53E3AB26.4070601@googlemail.com>
In-Reply-To: <53E3AB26.4070601@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/07/2014 06:36 PM, Frank Schäfer wrote:
> 
> Am 07.08.2014 um 08:45 schrieb Hans Verkuil:
>> On 08/05/2014 05:18 PM, Frank Schäfer wrote:
>>> Hi Hans,
>>>
>>> Am 05.08.2014 um 09:00 schrieb Hans Verkuil:
>>>> Fix three compiler warnings:
>>>>
>>>> drivers/media/usb/em28xx/em28xx-input.c: In function ‘em28xx_i2c_ir_handle_key’:
>>>> drivers/media/usb/em28xx/em28xx-input.c:318:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>  }
>>>>  ^
>>>>   CC [M]  drivers/media/usb/em28xx/em28xx-dvb.o
>>>> drivers/media/usb/em28xx/em28xx-camera.c: In function ‘em28xx_probe_sensor_micron’:
>>>> drivers/media/usb/em28xx/em28xx-camera.c:199:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>  }
>>>>  ^
>>>> drivers/media/usb/em28xx/em28xx-camera.c: In function ‘em28xx_probe_sensor_omnivision’:
>>>> drivers/media/usb/em28xx/em28xx-camera.c:304:1: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>  }
>>>>  ^
>>> Hmmm... I don't get these weird warnings.
>>> How can I reproduce them ?
>> I'm using gcc 4.9.1 and I'm compiling the kernel using just a regular make command.
>> In my .config I have CONFIG_FRAME_WARN=1024.
> Weird. With gcc version 4.8.1 20130909 [gcc-4_8-branch revision 202388]
> I get much smaller frame sizes:

Are you compiling for 32 or 64 bits? I'm compiling for 64 bits.

> 
> ...
> drivers/media/usb/em28xx/em28xx-input.c: In function
> ‘em28xx_i2c_ir_handle_key’:
> drivers/media/usb/em28xx/em28xx-input.c:318:1: warning: the frame size
> of 424 bytes is larger than 256 bytes [-Wframe-larger-than=]
>  }
>  ^
> ...
> drivers/media/usb/em28xx/em28xx-camera.c: In function
> ‘em28xx_probe_sensor_micron’:
> drivers/media/usb/em28xx/em28xx-camera.c:199:1: warning: the frame size
> of 432 bytes is larger than 256 bytes [-Wframe-larger-than=]
>  }
>  ^
> ...
> drivers/media/usb/em28xx/em28xx-camera.c: In function
> ‘em28xx_probe_sensor_omnivision’:
> drivers/media/usb/em28xx/em28xx-camera.c:304:1: warning: the frame size
> of 428 bytes is larger than 256 bytes [-Wframe-larger-than=]
>  }
>  ^
> ...
> 
> 
> Anyway, I really don't think a framesize of 1096 is a problem.

And I agree. I did some digging and for some reason the framesize warning was configured
for 1024 bytes on my 64-bit system, when the default is 2048. In fact, in the daily
build I removed the hacks that increased the size of this config option and everything
compiles just fine without warnings. Apparently all the offenders have been addressed
over the years.

> 
>>>> Note: there is no way the code in em28xx_i2c_ir_handle_key() is correct: it's
>>>> using an almost completely uninitialized i2c_client struct with random flags,
>>>> dev and name fields. Can't this turned into a proper i2c_client struct in
>>>> struct em28xx? At least with this patch it's no longer random data.
>>> Why do you think the client setup is random ?
>> Well, this is the code:
>>
>> 	struct i2c_client client;
>>  
>> 	client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
>> 	client.addr = ir->i2c_dev_addr;
>>
>> All other fields of the client struct are undefined, but it is used as is. That
>> can't be right. With my patch the i2c_client is either that that was used by the
>> probe, or it is all zero. Which is still better than having random values.
> Take a closer look at the code:
> 
> 1.) sensor probing:
> 
>     struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
> 
> dev->i2c_client[bus] is initialized on bus registration in
> em28xx_i2c_register():
> 
>     dev->i2c_client[bus] = em28xx_client_template;
>     dev->i2c_client[bus].adapter = &dev->i2c_adap[bus];
> 
> em28xx_client_template is defined static:
> 
> static struct i2c_client em28xx_client_template = {
>     .name = "em28xx internal",
> };
> 
> So nothing is random or undefined here.

I never said that. For sensor probing it is fine.

> 
> 
> 2.) i2c rc key polling:
> 
> em28xx_i2c_ir_handle_key() passes the client structure to one of the 4
> get_key functions
> 
>     rc = ir->get_key_i2c(&client, &protocol, &scancode);
> 
> which either call
> 
>     i2c_transfer(client->adapter, msg, len)
> 
> directly or the helper function
> 
>     i2c_master_recv(client, buf, len))
> 
> which creates an i2c message before calling i2c_transfer().
> The only members used from the i2c_client struct are
> 
>     msg.addr = client->addr;
>     msg.flags = client->flags & I2C_M_TEN;
> 
> So the only fields from struct i2c_client which need to be setup are
> "adapter" and "addr" and "flags".
> Adapter an addres are initialized properly to
> 
>     client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
>     client.addr = ir->i2c_dev_addr;
> 
> The only thing which is indeed missing here and needs to be fixed is
> 
>     client.flags = 0;

Are there no debugging calls that use client.name? Basically what I don't
understand is why this isn't a proper i2c_client, registered and all and
in its proper place in the /sys/ hierarchy.

It feels very much like a quick hack. And if nothing else, at least zero
the struct before use. That will make any problems that this hack causes
reproducible instead of dependent on whatever random values were on the
stack.

Regards,

	Hans
