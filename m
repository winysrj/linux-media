Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:41638 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbeF1EGc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 00:06:32 -0400
Received: by mail-io0-f195.google.com with SMTP id k16-v6so3896050ioa.8
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2018 21:06:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bdf5bac2-4011-5172-ddf5-d6099b71de4e@roeck-us.net>
References: <20180627181243.14630-1-matt.ranostay@konsulko.com>
 <201806280548.XGuVj1ZB%fengguang.wu@intel.com> <CAJCx=g=SAhbS+_ZWhQwQLErMTMijaytdPxsWgyXqVPXqxG6cUg@mail.gmail.com>
 <bdf5bac2-4011-5172-ddf5-d6099b71de4e@roeck-us.net>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Wed, 27 Jun 2018 21:06:31 -0700
Message-ID: <CAJCx=gm17RjS013W2O1O7g6k4DGe37SpZK5wg_zyDCpaCZMmwQ@mail.gmail.com>
Subject: Re: [PATCH v3] media: video-i2c: add hwmon support for amg88xx
To: Guenter Roeck <linux@roeck-us.net>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        linux-media@vger.kernel.org, linux-hwmon@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 27, 2018 at 8:42 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 06/27/2018 06:39 PM, Matt Ranostay wrote:
>>
>> On Wed, Jun 27, 2018 at 3:43 PM, kbuild test robot <lkp@intel.com> wrote:
>>>
>>> Hi Matt,
>>>
>>> I love your patch! Yet something to improve:
>>>
>>> [auto build test ERROR on linuxtv-media/master]
>>> [also build test ERROR on v4.18-rc2 next-20180627]
>>> [if your patch is applied to the wrong git tree, please drop us a note to
>>> help improve the system]
>>>
>>> url:
>>> https://github.com/0day-ci/linux/commits/Matt-Ranostay/media-video-i2c-add-hwmon-support-for-amg88xx/20180628-032019
>>> base:   git://linuxtv.org/media_tree.git master
>>> config: x86_64-randconfig-g0-06280029 (attached as .config)
>>> compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
>>> reproduce:
>>>          # save the attached .config to linux build tree
>>>          make ARCH=x86_64
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>     drivers/media/i2c/video-i2c.o: In function `amg88xx_hwmon_init':
>>>>>
>>>>> drivers/media/i2c/video-i2c.c:167: undefined reference to
>>>>> `devm_hwmon_device_register_with_info'
>>>
>>>
>>> vim +167 drivers/media/i2c/video-i2c.c
>>>
>>
>> Guenter,
>>
>> Before I resubmit this change do you agree an "imply HWMON" in the
>> Kconfig is the right way to avoid this race condition on build?
>> Using 'select HWMON' would of course defeat the purpose of '#if
>> IS_ENABLED(CONFIG_HWMON)'
>>
>
> Looks like it, but you'll have to try. I have not used it myself, so I
> don't really know what exactly it does. Another option might be to use
> IS_REACHABLE().
>

Looking at IS_REACHABLE documentation and that seems less than ideal
since it will return false if CONFIG_HWMON is a module.
Testing out 'imply HWMON' tonight.

- Matt

> Guenter
>
>
>> Thanks,
>>
>> Matt
>>
>>>     164
>>>     165  static int amg88xx_hwmon_init(struct video_i2c_data *data)
>>>     166  {
>>>   > 167          void *hwmon =
>>> devm_hwmon_device_register_with_info(&data->client->dev,
>>>     168                                  "amg88xx", data,
>>> &amg88xx_chip_info, NULL);
>>>     169
>>>     170          return PTR_ERR(hwmon);
>>>     171  }
>>>     172  #else
>>>     173  #define amg88xx_hwmon_init      NULL
>>>     174  #endif
>>>     175
>>>
>>> ---
>>> 0-DAY kernel test infrastructure                Open Source Technology
>>> Center
>>> https://lists.01.org/pipermail/kbuild-all                   Intel
>>> Corporation
>>
>>
>
