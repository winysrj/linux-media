Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34884 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbcCUTvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 15:51:00 -0400
Received: by mail-wm0-f48.google.com with SMTP id l68so124545593wml.0
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2016 12:50:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56EFDEAC.2040904@xs4all.nl>
References: <1453699436-4309-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<1456929016-4160-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<56EFDEAC.2040904@xs4all.nl>
Date: Mon, 21 Mar 2016 15:49:36 -0300
Message-ID: <CAAEAJfB+UBChTt0LHteGAJb8QJsG589nXkoMC5d7Z0hZW95t5w@mail.gmail.com>
Subject: Re: [PATCH v3] media: Support Intersil/Techwell TW686x-based video
 capture cards
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	=?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 March 2016 at 08:44, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Ezequiel,
>
> On 03/02/2016 03:30 PM, Ezequiel Garcia wrote:
>> This commit introduces the support for the Techwell TW686x video
>> capture IC. This hardware supports a few DMA modes, including
>> scatter-gather and frame (contiguous).
>>
>> This commit makes little use of the DMA engine and instead has
>> a memcpy based implementation. DMA frame and scatter-gather modes
>> support may be added in the future.
>>
>> Currently supported chips:
>> - TW6864 (4 video channels),
>> - TW6865 (4 video channels, not tested, second generation chip),
>> - TW6868 (8 video channels but only 4 first channels using
>>            built-in video decoder are supported, not tested),
>> - TW6869 (8 video channels, second generation chip).
>>
>> Cc: Krzysztof Hałasa <khalasa@piap.pl>
>> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
>
> I've tested this with my PCIe tw6869 card (arrived this week).
>
> Video is fine, but only the first audio input is available. I suspect you
> have only one audio input?
>

The driver exposes the eight audio channels as subdevices
(ALSA substreams) of a single device.

$ sudo arecord -l
**** List of CAPTURE Hardware Devices ****
[..]
card 1: tw686x [tw686x], device 0: tw686x [tw686x PCM]
  Subdevices: 8/8
  Subdevice #0: vch0 audio
  Subdevice #1: vch1 audio
  Subdevice #2: vch2 audio
  Subdevice #3: vch3 audio
  Subdevice #4: vch4 audio
  Subdevice #5: vch5 audio
  Subdevice #6: vch6 audio
  Subdevice #7: vch7 audio

> Regarding the memcpy: if you have a patch for me that reverts back to a non-memcpy
> situation, then I can do duration tests for you.
>

Yes, that would be great. I've just pushed my staging branch:

http://git.infradead.org/users/ezequielg/linux/shortlog/refs/heads/tw686x-upstream-for-v4.7

It introduces a dma_mode parameter which let's the user pick the
DMA operation. It accepts these values: memcpy, contig, sg. Only
"memcpy" and "contig" are working, while "sg" needs more work.

Feel free to test it and let me know how it goes.

Thanks,
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
