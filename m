Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-proxy002.phy.lolipop.jp ([157.7.104.43]:46618 "EHLO
        smtp-proxy002.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750760AbcIJHZi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 03:25:38 -0400
Subject: Re: [RFC][PATCH 0/2] ALSA: control: export all of TLV related macros
 to user land
To: Takashi Iwai <tiwai@suse.de>
References: <1473483016-10529-1-git-send-email-o-takashi@sakamocchi.jp>
 <s5hr38s9ru2.wl-tiwai@suse.de>
Cc: clemens@ladisch.de, alsa-devel@alsa-project.org,
        linux-media@vger.kernel.org
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Message-ID: <f8ef81e9-37a9-505e-ed66-2df9ae8070e8@sakamocchi.jp>
Date: Sat, 10 Sep 2016 16:25:31 +0900
MIME-Version: 1.0
In-Reply-To: <s5hr38s9ru2.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sep 10 2016 15:44, Takashi Iwai wrote:
> On Sat, 10 Sep 2016 06:50:14 +0200,
> Takashi Sakamoto wrote:
>>
>> Hi,
>>
>> Currently, TLV related protocol is not shared to user land. This is not
>> good in a point of application interfaces, because application developers
>> can't realize the protocol just to see UAPI headers.
>>
>> For this purpose, this patchset moves all of macros related to TLV to UAPI
>> header. As a result, a header just for kernel land is obsoleted. When adding
>> new items to the protocol, it's added to the UAPI header. This change affects
>> some drivers in media subsystem.
>>
>> In my concern, this change can break applications. When these macros are
>> already defined in application side and they includes tlv UAPI header
>> directly, 'redefined' warning is generated at preprocess time. But the
>> compilation will be success itself. If these two macros have different
>> content, the result of preprocess is dominated to the order to define.
>> However, the most applications are assumed to use TLV feature via libraries
>> such as alsa-lib, thus I'm optimistic to this concern.
>>
>> As another my concern, the name of these macros are quite simple, as
>> 'TLV_XXX'. It might be help application developers to rename them with a
>> prefix, as 'SNDRV_CTL_TLV_XXX'. (But not yet. I'm a lazy guy.)
> 
> The second patch does simply wrong.  You must not obsolete
> include/sound/tlv.h.  Even if it includes only uapi/*, it should be
> still there.

Any reasons?

> So, just move the stuff to include/uapi/sound/tlv.h, and that's all.


Regards

Takashi Sakamoto
