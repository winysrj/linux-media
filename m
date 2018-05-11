Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:36934 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751210AbeEKPXM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:23:12 -0400
Subject: Re: [PATCH 7/7] Add config-compat.h override config-mycompat.h
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-8-git-send-email-brad@nextdimension.cc>
 <c20ac1dd-153c-5d43-f0fd-ade27c548f86@xs4all.nl>
 <777ec77a-1a1c-138b-b5ca-33201649acc7@nextdimension.cc>
 <996b40ec-b4a2-8ce8-61ab-ce58269d3627@xs4all.nl>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <1ec2af8b-ee4a-29ed-56f0-b1a8c9201558@nextdimension.cc>
Date: Fri, 11 May 2018 10:23:10 -0500
MIME-Version: 1.0
In-Reply-To: <996b40ec-b4a2-8ce8-61ab-ce58269d3627@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 2018-05-11 10:11, Hans Verkuil wrote:
> On 05/11/18 17:08, Brad Love wrote:
>> Hi Hans,
>>
>>
>> On 2018-05-11 09:41, Hans Verkuil wrote:
>>> Hi Brad,
>>>
>>> On 04/26/18 19:19, Brad Love wrote:
>>>> config-mycompat.h is for overriding macros which are incorrectly
>>>> enabled on certain kernels by the build system. The file should be
>>>> left empty, unless build errors are encountered for a kernel. The
>>>> file is removed by distclean, therefore should be externally
>>>> sourced, before the build process starts, when required.
>>>>
>>>> In standard operation the file is empty, but if a particular kernel =
has
>>>> incorrectly enabled options defined this allows them to be undefined=
=2E
>>> Can you give an example where this will be used?
>>>
>>> FYI: I've committed patches 1-6, but I don't quite understand when th=
is patch
>>> is needed.
>>>
>>> With "for overriding macros which are incorrectly enabled on certain =
kernels"
>>> do you mean when distros do backports of features from later kernels?=

>>>
>>> Regards,
>>>
>>> 	Hans
>>
>> Apologies if I was not very clear. Yes, this is for use in
>> kernels/distros whose maintainers have integrated various backports, a=
nd
>> which the media_build system does not pick up on for whatever reason. =
At
>> that point there are options defined in config-compat.h, which enable
>> backports in compat.h, but which already exist in the target kernel.
>>
>> For example, on the device I'm working on right now, in kernel 3.10, I=

>> have to supply the following three options in config-mycompat.h or
>> modify the tree and stuff them right into the top of compat.h:
>>
>> #undef NEED_WRITEL_RELAXED
>> #undef NEED_PM_RUNTIME_GET
>> #undef NEED_PFN_TO_PHYS
>>
>>
>> The above disables those three media_build backports and allows
>> everything to build. It seems there is quite often at least one backpo=
rt
>> I must disable, and some target kernels require multiple backports dis=
abled.
> OK, that's what I thought. Can you post a v2 of this patch with this ex=
planation
> included? Both in the commit log and in the compat.h comment.
>
> That should make it clear what the purpose of this file is.
>
> Regards,
>
> 	Hans


Will do now.



>
>> Cheers,
>>
>> Brad
>>
>>
>>
>>>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>>>> ---
>>>>  v4l/Makefile | 3 ++-
>>>>  v4l/compat.h | 7 +++++++
>>>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/v4l/Makefile b/v4l/Makefile
>>>> index 270a624..ee18d11 100644
>>>> --- a/v4l/Makefile
>>>> +++ b/v4l/Makefile
>>>> @@ -273,6 +273,7 @@ links::
>>>>  	@find ../linux/drivers/misc -name '*.[ch]' -type f -print0 | xargs=
 -0n 255 ln -sf --target-directory=3D.
>>>> =20
>>>>  config-compat.h:: $(obj)/.version .myconfig scripts/make_config_com=
pat.pl
>>>> +	-touch $(obj)/config-mycompat.h
>>>>  	perl scripts/make_config_compat.pl $(SRCDIR) $(obj)/.myconfig $(ob=
j)/config-compat.h
>>>> =20
>>>>  kernel-links makelinks::
>>>> @@ -298,7 +299,7 @@ clean::
>>>>  distclean:: clean
>>>>  	-rm -f .version .*.o.flags .*.o.d *.mod.gcno Makefile.media \
>>>>  		Kconfig Kconfig.kern .config .config.cmd .myconfig \
>>>> -		.kconfig.dep
>>>> +		.kconfig.dep config-mycompat.h
>>>>  	-rm -rf .tmp_versions .tmp*.ver .tmp*.o .*.gcno .cache.mk
>>>>  	-rm -f scripts/lxdialog scripts/kconfig
>>>>  	@find .. -name '*.orig' -exec rm '{}' \;
>>>> diff --git a/v4l/compat.h b/v4l/compat.h
>>>> index 87ce401..db48fdf 100644
>>>> --- a/v4l/compat.h
>>>> +++ b/v4l/compat.h
>>>> @@ -8,6 +8,13 @@
>>>>  #include <linux/version.h>
>>>> =20
>>>>  #include "config-compat.h"
>>>> +/* config-mycompat.h is for overriding #defines which
>>>> + * are incorrectly enabled on certain kernels. The file
>>>> + * should be left empty, unless build errors are encountered
>>>> + * for a kernel. The file is removed by distclean, therefore
>>>> + * should be externally sourced, before compilation, when required.=

>>>> + */
>>>> +#include "config-mycompat.h"
>>>> =20
>>>>  #ifndef SZ_512
>>>>  #define SZ_512				0x00000200
>>>>
>>
