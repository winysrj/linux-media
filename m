Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:41185 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753162AbeCPQv5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 12:51:57 -0400
Received: by mail-wr0-f172.google.com with SMTP id f14so12341587wre.8
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 09:51:57 -0700 (PDT)
References: <20180313113311.8617-3-rui.silva@linaro.org> <201803150338.2LzbxAYM%fengguang.wu@intel.com> <m3a7v98z5u.fsf@linaro.org> <20180316161011.yelt3mqkqo7qnlnn@kekkonen.localdomain>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Rui Miguel Silva <rui.silva@linaro.org>,
        kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v3 2/2] media: ov2680: Add Omnivision OV2680 sensor driver
In-reply-to: <20180316161011.yelt3mqkqo7qnlnn@kekkonen.localdomain>
Date: Fri, 16 Mar 2018 16:51:53 +0000
Message-ID: <m3woyc6k0m.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
On Fri 16 Mar 2018 at 16:10, Sakari Ailus wrote:
> On Thu, Mar 15, 2018 at 09:29:33AM +0000, Rui Miguel Silva 
> wrote:
>> Hi,
>> On Wed 14 Mar 2018 at 19:39, kbuild test robot wrote:
>> > Hi Rui,
>> > 
>> > I love your patch! Yet something to improve:
>> > 
>> > [auto build test ERROR on v4.16-rc4]
>> > [cannot apply to next-20180314]
>> > [if your patch is applied to the wrong git tree, please drop 
>> > us a note
>> > to help improve the system]
>> > 
>> > url: 
>> > https://github.com/0day-ci/linux/commits/Rui-Miguel-Silva/media-Introduce-Omnivision-OV2680-driver/20180315-020617
>> > config: sh-allmodconfig (attached as .config)
>> > compiler: sh4-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
>> > reproduce:
>> >         wget
>> > https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
>> > -O ~/bin/make.cross
>> >         chmod +x ~/bin/make.cross
>> >         # save the attached .config to linux build tree
>> >         make.cross ARCH=sh
>> > 
>> > All errors (new ones prefixed by >>):
>> > 
>> >    drivers/media/i2c/ov2680.c: In function 'ov2680_set_fmt':
>> > > > drivers/media/i2c/ov2680.c:713:9: error: implicit 
>> > > > declaration of
>> > > > function 'v4l2_find_nearest_size'; did you mean
>> > > > 'v4l2_find_nearest_format'?
>> > > > [-Werror=implicit-function-declaration]
>> >      mode = v4l2_find_nearest_size(ov2680_mode_data,
>> >             ^~~~~~~~~~~~~~~~~~~~~~
>> >             v4l2_find_nearest_format
>> 
>> As requested by maintainer this series depend on this patch 
>> [0], which
>> introduce this macro. I am not sure of the status of that patch 
>> though.
>
> No need to worry about that, the sensor driver will just be 
> merged after
> the dependencies are in. Mauro said he'd handle the pull request 
> early next
> week.

Great, Many thanks for everything.

---
Cheers,
	Rui
