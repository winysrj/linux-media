Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:64919 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaIXIMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 04:12:07 -0400
Received: by mail-we0-f177.google.com with SMTP id t60so5744750wes.22
        for <linux-media@vger.kernel.org>; Wed, 24 Sep 2014 01:12:05 -0700 (PDT)
Message-ID: <54227CD2.5020705@linaro.org>
Date: Wed, 24 Sep 2014 09:12:02 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, kernel@stlinux.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [STLinux Kernel] [PATCH 1/3] media: st-rc: move to using reset_control_get_optional
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org> <1411424546-12718-1-git-send-email-srinivas.kandagatla@linaro.org> <20140923180255.GA3430@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20140923180255.GA3430@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pete,

On 23/09/14 19:02, Peter Griffin wrote:
> Hi Srini,
>
> On Mon, 22 Sep 2014, Srinivas Kandagatla wrote:
>
>> This patch fixes a compilation error while building with the
>> random kernel configuration.
>>
>> drivers/media/rc/st_rc.c: In function 'st_rc_probe':
>> drivers/media/rc/st_rc.c:281:2: error: implicit declaration of
>> function 'reset_control_get' [-Werror=implicit-function-declaration]
>>    rc_dev->rstc = reset_control_get(dev, NULL);
>>
>> drivers/media/rc/st_rc.c:281:15: warning: assignment makes pointer
>> from integer without a cast [enabled by default]
>>    rc_dev->rstc = reset_control_get(dev, NULL);
>
> Is managing the reset line actually optional though? I can't test atm as I don't have
> access to my board, but quite often if the IP's aren't taken out of reset reads / writes
> to the perhpiheral will hang the SoC.
>
Yes and No.
AFAIK reset line is optional on SOCs like 7108, 7141.
I think having the driver function without reset might is a value add in 
case we plan to reuse the mainline driver for these SOCs.

On latest ARM SOCs with SBC the IRB IP is moved to SBC and held in reset.
Am not sure, if the reset line is optional in next generation SOCs?

> If managing the reset line isn't optional then I think the correct fix is to add
> depends on RESET_CONTROLLER in the kconfig.
I agree.
This would make the COMPILE_TEST less useful though.


thanks,
srini
>
> This will then do the right thing for randconfig builds as well.
>
> regards,
>
> Peter.
>
