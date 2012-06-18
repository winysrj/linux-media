Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab2FRXBR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 19:01:17 -0400
Message-ID: <4FDFB335.2070503@redhat.com>
Date: Mon, 18 Jun 2012 20:01:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: cheng renquan <crquan@gmail.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	VDR User <user.vdr@gmail.com>
Subject: Re: [PATCH] make VIDEO_MEDIA depends on DVB_CORE only (removing depends
 VIDEO_DEV)
References: <CAH5vBdLM4SnXcj7+5+qUXeWRhp4J=kp_V0eSBXMJVMORPd690Q@mail.gmail.com>
In-Reply-To: <CAH5vBdLM4SnXcj7+5+qUXeWRhp4J=kp_V0eSBXMJVMORPd690Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-06-2012 22:55, cheng renquan escreveu:
> I think the root cause is VIDEO_MEDIA depending on VIDEO_DEV or DVB_CORE;
> since MEDIA_TUNER is depending on VIDEO_MEDIA;
> I have VIDEO_DEV but not DVB_CORE, hence should be no VIDEO_MEDIA,
> 
> config MEDIA_TUNER
>          tristate
>          default VIDEO_MEDIA && I2C
>          depends on VIDEO_MEDIA && I2C
> 
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 9575db4..1b35dae 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -99,7 +99,7 @@ config DVB_NET
> 
>   config VIDEO_MEDIA
>   	tristate
> -	default (DVB_CORE && (VIDEO_DEV = n)) || (VIDEO_DEV && (DVB_CORE =
> n)) || (DVB_CORE && VIDEO_DEV)
> +	default DVB_CORE

Sorry, but this is wrong and will break compilation for analog drivers.

I think my RFC patches should fix this issue[1] and [2]. If not, they will at the final
version, after removing drivers/media/video and drivers/media/dvb, and
re-writing the dependency chain (planned as part 2 and 3 of my patch series).

[1] http://www.spinics.net/lists/linux-media/msg48451.html

[2] http://www.spinics.net/lists/linux-media/msg48974.html

Regards,
Mauro

> 
>   comment "Multimedia drivers"
> 
> 
> On Thu, Jun 7, 2012 at 4:09 PM, VDR User <user.vdr@gmail.com> wrote:
>> On Thu, Jun 7, 2012 at 2:53 PM, cheng renquan <crquan@gmail.com> wrote:
>>> till recently I found that also chosen those media tuner modules,
>>>
>>> $ grep MEDIA_TUNER /boot/config
>>> CONFIG_MEDIA_TUNER=m
>>> # CONFIG_MEDIA_TUNER_CUSTOMISE is not set
>>> CONFIG_MEDIA_TUNER_SIMPLE=m
>>> CONFIG_MEDIA_TUNER_TDA8290=m
>>> CONFIG_MEDIA_TUNER_TDA827X=m
>>> CONFIG_MEDIA_TUNER_TDA18271=m
>>> CONFIG_MEDIA_TUNER_TDA9887=m
>>> CONFIG_MEDIA_TUNER_TEA5761=m
>>> CONFIG_MEDIA_TUNER_TEA5767=m
>>> CONFIG_MEDIA_TUNER_MT20XX=m
>>> CONFIG_MEDIA_TUNER_XC2028=m
>>> CONFIG_MEDIA_TUNER_XC5000=m
>>> CONFIG_MEDIA_TUNER_XC4000=m
>>> CONFIG_MEDIA_TUNER_MC44S803=m
>>>
>>> as I understand, MEDIA_TUNER is for some tv adapters but I don't have
>>> such hardware,
>>> to disable them I need to enable MEDIA_TUNER_CUSTOMISE, then
>>> a menu "Customize TV tuners" becomes visible then I need to enter that
>>> menu and disable all the tuners one-by-one;
>>> this looks not convenient,
>>
>> I hate that too so you're not alone. I've just gotten into the habit
>> of having to manually disabling everything I don't need as opposed to
>> only needing to enable what I do need. :\



> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


