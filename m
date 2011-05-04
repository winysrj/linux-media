Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:33468 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab1EDOqs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 10:46:48 -0400
Message-ID: <4DC166D4.4090408@linuxtv.org>
Date: Wed, 04 May 2011 16:46:44 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Martin Vidovic <xtronom@gmail.com>
CC: Ralph Metzler <rjkm@metzlerbros.de>,
	Issa Gorissen <flop.m@usa.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>	<4DC1236C.3000006@linuxtv.org> <19905.13923.40846.342434@morden.metzler> <4DC146E1.3000103@linuxtv.org> <4DC15633.3030300@gmail.com>
In-Reply-To: <4DC15633.3030300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/04/2011 03:35 PM, Martin Vidovic wrote:
>>
>>> Or is there a standard way this is supposed to be handled?
>>
>> Yes. Since ages. The ioctl is called DMX_SET_SOURCE.
> 
> DMX_SET_SOURCE seems to not be implemented anywhere, all it does is
> return EINVAL. I also fail to find any useful documentation about what
> it is supposed to do.

It is supposed to connect the TS output of frontend X to the TS input of
demux Y. Whether you need to manually connect anything depends on your
application and hardware environment. It's not required at all when
using the software demux, which is what almost all in-tree drivers do.

>>> There are no mechanism to connect a frontend with specific dvr or
>>> demux devices in the current API. But you demand it for the caio device.
>>
> 
> I think there is currently no useful API to connect devices. Every few
> months there comes a new device which deprecates how I enumerate devices
> and determine types of FE's.

Can you describe the most common problems? What do you mean by connecting?

> The most useful way to query devices seems to be using HAL, and I think
> this is the correct way in Linux, but DVB-API may be lacking with
> providing the necessary information. Maybe this is the direction we
> should consider? Device names under /dev seem to be irrelevant nowadays.

I think in the long run we should look closely at how V4L2 is solving
similar problems.

Regards,
Andreas
