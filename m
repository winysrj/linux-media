Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61597 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2JIVdX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 17:33:23 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so6154359wib.1
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 14:33:22 -0700 (PDT)
Message-ID: <50749814.2000204@uni-bielefeld.de>
Date: Tue, 09 Oct 2012 23:33:08 +0200
From: Robert Abel <abel@uni-bielefeld.de>
Reply-To: abel@uni-bielefeld.de
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] libv4lconvert: update the list of pac7302 webcams
References: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com> <1347215768-9843-3-git-send-email-fschaefer.oss@googlemail.com> <504D0996.6010405@redhat.com>
In-Reply-To: <504D0996.6010405@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

sorry for digging this up.

On 09.09.2012 23:26, Hans de Goede wrote:
> The 0x0f here is a mask, so this one entry covers all device ids from
> 0x2620 - 0x262f, so...
>
>>       { 0x06f8, 0x3009, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>>       { 0x06f8, 0x301b, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x2620, 0x0f, NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x2611, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x2622, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x2624, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x2625, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x2626, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x2627, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x2628, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x2629, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x262a, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>> +    { 0x093a, 0x262c, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>
> The addition of all these is not necessary.
Actually
> { 0x093a, 0x2611, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG }, 
is not covered by the bitmask and it's not in the current HEAD tree, either.

Regards,

Robert

