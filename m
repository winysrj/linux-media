Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41605 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab0EJVlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 17:41:46 -0400
Received: by fxm7 with SMTP id 7so616939fxm.19
        for <linux-media@vger.kernel.org>; Mon, 10 May 2010 14:41:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE84649.3010507@tvdr.de>
References: <E1OBKmg-0006RZ-4R@www.linuxtv.org> <4BE84649.3010507@tvdr.de>
Date: Tue, 11 May 2010 01:41:44 +0400
Message-ID: <AANLkTikkTIhLiAjxLmv3dkc3b8E9FTfebqC6YRtO5uuW@mail.gmail.com>
Subject: Re: [hg:v4l-dvb] Add FE_CAN_PSK_8 to allow apps to identify PSK_8
	capable DVB devices
From: Manu Abraham <abraham.manu@gmail.com>
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 10, 2010 at 9:45 PM, Klaus Schmidinger
<Klaus.Schmidinger@tvdr.de> wrote:
> On 10.05.2010 06:40, Patch from Klaus Schmidinger wrote:
>> The patch number 14692 was added via Douglas Schilling Landgraf <dougsland@redhat.com>
>> to http://linuxtv.org/hg/v4l-dvb master development tree.
>>
>> Kernel patches in this development tree may be modified to be backward
>> compatible with older kernels. Compatibility modifications will be
>> removed before inclusion into the mainstream Kernel
>>
>> If anyone has any objections, please let us know by sending a message to:
>>       Linux Media Mailing List <linux-media@vger.kernel.org>
>
> This patch should not have been applied, as was decided in
> the original thread.
>
> I'm still waiting for any response to my new patch, posted in
>
>  "[PATCH] Add FE_CAN_TURBO_FEC (was: Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable DVB devices)"
>
> which replaces my original suggestion.

I did a reply but that happened to be on another thread on patchwork,
but here it is again.

Reviewed-by: Manu Abraham <manu <at> linuxtv.org>
Acked-by: Manu Abraham <manu <at> linuxtv.org>
