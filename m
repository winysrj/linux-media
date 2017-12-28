Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:25535 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750800AbdL1QF3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 11:05:29 -0500
Message-ID: <1514477126.7000.439.camel@linux.intel.com>
Subject: Re: [ov2722 Error] atomisp: ERROR
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrei Lavreniyuk <andy.lavr@gmail.com>,
        linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com
Date: Thu, 28 Dec 2017 18:05:26 +0200
In-Reply-To: <9cfdd431-c8e3-c85c-07b5-e2e42f1fddca@gmail.com>
References: <9cfdd431-c8e3-c85c-07b5-e2e42f1fddca@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-10-31 at 16:35 +0200, Andrei Lavreniyuk wrote:
> Hi,
> 
> Very long I try to run ov2722 on Acer Aspire SW5-012 / Fendi2 Z3537F
> 
> Kernel 4.13.10 + atomisp from 4.14 and all your corrections for
> atomisp 
> from here

Check this [1] thread, please.


[1]: https://www.spinics.net/lists/linux-media/msg126250.html

> 
> https://patchwork.linuxtv.org/project/linux-media/list/?submitter=Andy
> +Shevchenko&state=* 
> <https://patchwork.linuxtv.org/project/linux-media/list/?submitter=And
> y+Shevchenko&state=*>
> 
> as a result:
> 
> [69.677080] media: Linux media interface: v0.10
> [69.699534] Linux video capture interface: v2.00
> [69.714154] ov2722: module is from the staging directory, the quality
> is 
> unknown, you have been warned.
> [69.777623] ov2722 i2c-INT33FB: 00: gmin: initializing the atomisp 
> module subdev data.PMIC ID 1
> [69.778097] ov2722 i2c-INT33FB: 00: i2c-INT33FB: 00 supply V1P8SX not 
> found, using dummy regulator
> [69.778208] ov2722 i2c-INT33FB: 00: i2c-INT33FB: 00 supply V2P8SX not 
> found, using dummy regulator
> [69.778278] ov2722 i2c-INT33FB: 00: i2c-INT33FB: 00 supply V1P2A not 
> found, using dummy regulator
> [69.778348] ov2722 i2c-INT33FB: 00: i2c-INT33FB: 00 supply VPROG4B
> not 
> found, using dummy regulator
> [69.785182] ov2722 i2c-INT33FB: 00: unable to set PMC rate 0
> [69.807860] ov2722 i2c-INT33FB: 00: camera pdata: port: 0 lanes: 1 
> order: 00000000
> [69.808183] ov2722 i2c-INT33FB: 00: read from offset 0x300a error -121
> [69.808203] ov2722 i2c-INT33FB: 00: sensor_id_high = 0xffff
> [69.808216] ov2722 i2c-INT33FB: 00: ov2722_detect err s_config.
> [69.808259] ov2722 i2c-INT33FB: 00: sensor power-gating failed
> 
> 
> Tested the kernels from the repositories:
> https://github.com/torvalds/linux 
> <https://github.com/torvalds/linux> and master from git.linuxtv.org 
> <http://git.linuxtv.org/>
> 
>   The result is the same - ov2722 i2c-INT33FB: 00: read from offset 
> 0x300a error -121
> 
> Additional information for debug:
> https://drive.google.com/drive/folders/0B5ngHZIeNdyTM0FEbWNVQzlpNUU 
> <https://drive.google.com/drive/folders/0B5ngHZIeNdyTM0FEbWNVQzlpNUU>
> 
> Kernel build form my repo - 
> https://github.com/AndyLavr/Aspire-SW5-012_Kernel_4.13 
> <https://github.com/AndyLavr/Aspire-SW5-012_Kernel_4.13>
> 
> If you need more information, then I will.
> 
> 
> ---
> Best regards, Andrei Lavreniyuk
> 
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
