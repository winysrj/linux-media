Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1816 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab3GZM7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 08:59:38 -0400
Message-ID: <51F272B2.1000808@xs4all.nl>
Date: Fri, 26 Jul 2013 14:59:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] bttv: Convert to generic TEA575x interface
References: <1368564885-20940-1-git-send-email-linux@rainbow-software.org> <1368564885-20940-4-git-send-email-linux@rainbow-software.org> <201306031046.42057.hverkuil@xs4all.nl>
In-Reply-To: <201306031046.42057.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ondrej,

On 06/03/2013 10:46 AM, Hans Verkuil wrote:
> On Tue May 14 2013 22:54:45 Ondrej Zary wrote:
>> Remove tea575x-specific code from bttv and use the common driver instead.
>>
>> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>> ---
>>  drivers/media/pci/bt8xx/bttv-cards.c  |  317 ++++++++++++---------------------
>>  drivers/media/pci/bt8xx/bttv-driver.c |    6 +-
>>  drivers/media/pci/bt8xx/bttvp.h       |   14 +-
>>  sound/pci/Kconfig                     |    4 +-
>>  4 files changed, 124 insertions(+), 217 deletions(-)
>>
> 
> ...
> 
>> diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
>> index fe6fa93..83e0df5 100644
>> --- a/sound/pci/Kconfig
>> +++ b/sound/pci/Kconfig
>> @@ -2,8 +2,8 @@
>>  
>>  config SND_TEA575X
>>  	tristate
>> -	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
>> -	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
>> +	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK || VIDEO_BT848
>> +	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK || VIDEO_BT848
>>  
>>  menuconfig SND_PCI
>>  	bool "PCI sound devices"
>>
> 
> In addition, bttv should also become dependent on SND.
> 
> Frankly, isn't it time that tea575x-tuner moves to drivers/media/common or
> driver/media/radio? It's really weird to have such a fairly widely used v4l
> module in sound.

It makes more sense to add this patch to the patch series moving tea575x to drivers/media.
It simplifies the Kconfig handling substantially.

Regards,

	Hans
