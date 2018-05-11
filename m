Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:42600 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750806AbeEKPLu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:11:50 -0400
Subject: Re: [PATCH 7/7] Add config-compat.h override config-mycompat.h
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-8-git-send-email-brad@nextdimension.cc>
 <c20ac1dd-153c-5d43-f0fd-ade27c548f86@xs4all.nl>
 <777ec77a-1a1c-138b-b5ca-33201649acc7@nextdimension.cc>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <996b40ec-b4a2-8ce8-61ab-ce58269d3627@xs4all.nl>
Date: Fri, 11 May 2018 17:11:46 +0200
MIME-Version: 1.0
In-Reply-To: <777ec77a-1a1c-138b-b5ca-33201649acc7@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/18 17:08, Brad Love wrote:
> Hi Hans,
> 
> 
> On 2018-05-11 09:41, Hans Verkuil wrote:
>> Hi Brad,
>>
>> On 04/26/18 19:19, Brad Love wrote:
>>> config-mycompat.h is for overriding macros which are incorrectly
>>> enabled on certain kernels by the build system. The file should be
>>> left empty, unless build errors are encountered for a kernel. The
>>> file is removed by distclean, therefore should be externally
>>> sourced, before the build process starts, when required.
>>>
>>> In standard operation the file is empty, but if a particular kernel has
>>> incorrectly enabled options defined this allows them to be undefined.
>> Can you give an example where this will be used?
>>
>> FYI: I've committed patches 1-6, but I don't quite understand when this patch
>> is needed.
>>
>> With "for overriding macros which are incorrectly enabled on certain kernels"
>> do you mean when distros do backports of features from later kernels?
>>
>> Regards,
>>
>> 	Hans
> 
> 
> Apologies if I was not very clear. Yes, this is for use in
> kernels/distros whose maintainers have integrated various backports, and
> which the media_build system does not pick up on for whatever reason. At
> that point there are options defined in config-compat.h, which enable
> backports in compat.h, but which already exist in the target kernel.
> 
> For example, on the device I'm working on right now, in kernel 3.10, I
> have to supply the following three options in config-mycompat.h or
> modify the tree and stuff them right into the top of compat.h:
> 
> #undef NEED_WRITEL_RELAXED
> #undef NEED_PM_RUNTIME_GET
> #undef NEED_PFN_TO_PHYS
> 
> 
> The above disables those three media_build backports and allows
> everything to build. It seems there is quite often at least one backport
> I must disable, and some target kernels require multiple backports disabled.

OK, that's what I thought. Can you post a v2 of this patch with this explanation
included? Both in the commit log and in the compat.h comment.

That should make it clear what the purpose of this file is.

Regards,

	Hans

> 
> Cheers,
> 
> Brad
> 
> 
> 
>>
>>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>>> ---
>>>  v4l/Makefile | 3 ++-
>>>  v4l/compat.h | 7 +++++++
>>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/v4l/Makefile b/v4l/Makefile
>>> index 270a624..ee18d11 100644
>>> --- a/v4l/Makefile
>>> +++ b/v4l/Makefile
>>> @@ -273,6 +273,7 @@ links::
>>>  	@find ../linux/drivers/misc -name '*.[ch]' -type f -print0 | xargs -0n 255 ln -sf --target-directory=.
>>>  
>>>  config-compat.h:: $(obj)/.version .myconfig scripts/make_config_compat.pl
>>> +	-touch $(obj)/config-mycompat.h
>>>  	perl scripts/make_config_compat.pl $(SRCDIR) $(obj)/.myconfig $(obj)/config-compat.h
>>>  
>>>  kernel-links makelinks::
>>> @@ -298,7 +299,7 @@ clean::
>>>  distclean:: clean
>>>  	-rm -f .version .*.o.flags .*.o.d *.mod.gcno Makefile.media \
>>>  		Kconfig Kconfig.kern .config .config.cmd .myconfig \
>>> -		.kconfig.dep
>>> +		.kconfig.dep config-mycompat.h
>>>  	-rm -rf .tmp_versions .tmp*.ver .tmp*.o .*.gcno .cache.mk
>>>  	-rm -f scripts/lxdialog scripts/kconfig
>>>  	@find .. -name '*.orig' -exec rm '{}' \;
>>> diff --git a/v4l/compat.h b/v4l/compat.h
>>> index 87ce401..db48fdf 100644
>>> --- a/v4l/compat.h
>>> +++ b/v4l/compat.h
>>> @@ -8,6 +8,13 @@
>>>  #include <linux/version.h>
>>>  
>>>  #include "config-compat.h"
>>> +/* config-mycompat.h is for overriding #defines which
>>> + * are incorrectly enabled on certain kernels. The file
>>> + * should be left empty, unless build errors are encountered
>>> + * for a kernel. The file is removed by distclean, therefore
>>> + * should be externally sourced, before compilation, when required.
>>> + */
>>> +#include "config-mycompat.h"
>>>  
>>>  #ifndef SZ_512
>>>  #define SZ_512				0x00000200
>>>
> 
> 
