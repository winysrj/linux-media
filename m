Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweblb05fl.versatel.de ([89.246.255.248]:42218 "EHLO
	mxweblb05fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0CBWSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 17:18:32 -0500
Received: from ens28fl.versatel.de (ens28fl.versatel.de [82.140.32.10])
	by mxweblb05fl.versatel.de (8.13.1/8.13.1) with ESMTP id o22MIUlM016898
	for <linux-media@vger.kernel.org>; Tue, 2 Mar 2010 23:18:30 +0100
Received: from cinnamon-sage.de (i577A5985.versanet.de [87.122.89.133])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id o22MIUJm031644
	for <linux-media@vger.kernel.org>; Tue, 2 Mar 2010 23:18:30 +0100
Received: from 192.168.23.2:49911 by cinnamon-sage.de for <linux-media@vger.kernel.org> ; 02.03.2010 23:18:30
Message-ID: <4B8D8EB6.4030305@cinnamon-sage.de>
Date: Tue, 02 Mar 2010 23:18:30 +0100
From: Lars Hanisch <dvb@cinnamon-sage.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx18: where do the transport stream PIDs come from?
References: <4B87F59A.7070006@cinnamon-sage.de> <1267362273.3106.12.camel@palomino.walls.org>
In-Reply-To: <1267362273.3106.12.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.02.2010 14:04, schrieb Andy Walls:
> On Fri, 2010-02-26 at 17:23 +0100, Lars Hanisch wrote:
>> Hi,
>>
>>    while working on a small test app which repacks the ivtv-PS into a TS, I received a sample from a cx18-based card. The
>> TS contains the video PID 301, audio PID 300 and PCR pid 101.
>>
>>    Where do these PIDs come from, are they set by the driver or are they firmware given?
>
> For analog captures, for which the firmware creates the TS, the firmware
> sets them.

  That's what I thought. So I will use the same IDs for my conversion of an ivtv-PS.

>
>
>>    Is it possible to change them?
>
> It is not possible to tell the firmware to change them.  There are two
> documented CX23418 API commands in cx23418.h:
>
> CX18_CPU_SET_VIDEO_PID
> CX18_CPU_SET_AUDIO_PID
>
> Unfortunately, I know they do nothing and will always directly return
> 0x200800ff, which is a CX23418 API error code.

  Good to know.

Thanks!
Lars.

>
> Regards,
> Andy
>
>> Regards,
>> Lars.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
