Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:48698 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751876AbdJaOfI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 10:35:08 -0400
Received: by mail-lf0-f50.google.com with SMTP id a69so19292938lfe.5
        for <linux-media@vger.kernel.org>; Tue, 31 Oct 2017 07:35:08 -0700 (PDT)
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, andriy.shevchenko@linux.intel.com
From: Andrei Lavreniyuk <andy.lavr@gmail.com>
Subject: [ov2722 Error] atomisp: ERROR
Message-ID: <9cfdd431-c8e3-c85c-07b5-e2e42f1fddca@gmail.com>
Date: Tue, 31 Oct 2017 16:35:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Very long I try to run ov2722 on Acer Aspire SW5-012 / Fendi2 Z3537F

Kernel 4.13.10 + atomisp from 4.14 and all your corrections for atomisp 
from here

https://patchwork.linuxtv.org/project/linux-media/list/?submitter=Andy+Shevchenko&state=* 
<https://patchwork.linuxtv.org/project/linux-media/list/?submitter=Andy+Shevchenko&state=*>

as a result:

[69.677080] media: Linux media interface: v0.10
[69.699534] Linux video capture interface: v2.00
[69.714154] ov2722: module is from the staging directory, the quality is 
unknown, you have been warned.
[69.777623] ov2722 i2c-INT33FB: 00: gmin: initializing the atomisp 
module subdev data.PMIC ID 1
[69.778097] ov2722 i2c-INT33FB: 00: i2c-INT33FB: 00 supply V1P8SX not 
found, using dummy regulator
[69.778208] ov2722 i2c-INT33FB: 00: i2c-INT33FB: 00 supply V2P8SX not 
found, using dummy regulator
[69.778278] ov2722 i2c-INT33FB: 00: i2c-INT33FB: 00 supply V1P2A not 
found, using dummy regulator
[69.778348] ov2722 i2c-INT33FB: 00: i2c-INT33FB: 00 supply VPROG4B not 
found, using dummy regulator
[69.785182] ov2722 i2c-INT33FB: 00: unable to set PMC rate 0
[69.807860] ov2722 i2c-INT33FB: 00: camera pdata: port: 0 lanes: 1 
order: 00000000
[69.808183] ov2722 i2c-INT33FB: 00: read from offset 0x300a error -121
[69.808203] ov2722 i2c-INT33FB: 00: sensor_id_high = 0xffff
[69.808216] ov2722 i2c-INT33FB: 00: ov2722_detect err s_config.
[69.808259] ov2722 i2c-INT33FB: 00: sensor power-gating failed


Tested the kernels from the repositories:
https://github.com/torvalds/linux 
<https://github.com/torvalds/linux> and master from git.linuxtv.org 
<http://git.linuxtv.org/>

  The result is the same - ov2722 i2c-INT33FB: 00: read from offset 
0x300a error -121

Additional information for debug:
https://drive.google.com/drive/folders/0B5ngHZIeNdyTM0FEbWNVQzlpNUU 
<https://drive.google.com/drive/folders/0B5ngHZIeNdyTM0FEbWNVQzlpNUU>

Kernel build form my repo - 
https://github.com/AndyLavr/Aspire-SW5-012_Kernel_4.13 
<https://github.com/AndyLavr/Aspire-SW5-012_Kernel_4.13>

If you need more information, then I will.


---
Best regards, Andrei Lavreniyuk
