Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:36731 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbcGTMpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 08:45:34 -0400
Date: Wed, 20 Jul 2016 08:45:25 -0400
From: William Breathitt Gray <vilhelm.gray@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] radio: Utilize the module_isa_driver macro
Message-ID: <20160720124502.GA1119@sophia>
References: <cover.1468852798.git.vilhelm.gray@gmail.com>
 <6e689553-b3bc-c5d1-1246-ff109d2bba17@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6e689553-b3bc-c5d1-1246-ff109d2bba17@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 20, 2016 at 12:37:31PM +0200, Hans Verkuil wrote:
>On 07/18/2016 04:45 PM, William Breathitt Gray wrote:
>> The module_isa_driver macro is a helper macro for ISA drivers which do
>> not do anything special in module init/exit. This patchset eliminates a
>> lot of ISA driver registration boilerplate code by utilizing
>> module_isa_driver, which replaces module_init and module_exit.
>> 
>> William Breathitt Gray (6):
>>   radio: terratec: Utilize the module_isa_driver macro
>>   radio: rtrack2: Utilize the module_isa_driver macro
>>   radio: trust: Utilize the module_isa_driver macro
>>   radio: zoltrix: Utilize the module_isa_driver macro
>>   radio: aztech: Utilize the module_isa_driver macro
>>   radio: aimslab: Utilize the module_isa_driver macro
>
>Good idea, but it doesn't compile:
>
>module_isa_driver(terratec_driver.driver, 1);
>
>expands to:
>
>static int __init terratec_driver.driver_init(void)
>{
>        return isa_register_driver(&(terratec_driver.driver), 1);
>}
>
>So now the function name contains a '.' and it won't compile.
>
>Regards,
>
>	Hans

Oops, looks like I was a bit on autopilot there. I'll have to rethink
this patchset at a later point to overcome the symbol naming issue.

Thank you,

William Breathitt Gray
