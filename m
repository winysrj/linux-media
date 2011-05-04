Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61859 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1EDNeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 09:34:12 -0400
Received: by bwz15 with SMTP id 15so970510bwz.19
        for <linux-media@vger.kernel.org>; Wed, 04 May 2011 06:34:11 -0700 (PDT)
Message-ID: <4DC15633.3030300@gmail.com>
Date: Wed, 04 May 2011 15:35:47 +0200
From: Martin Vidovic <xtronom@gmail.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Ralph Metzler <rjkm@metzlerbros.de>,
	Issa Gorissen <flop.m@usa.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>	<4DC1236C.3000006@linuxtv.org> <19905.13923.40846.342434@morden.metzler> <4DC146E1.3000103@linuxtv.org>
In-Reply-To: <4DC146E1.3000103@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> 
>> Or is there a standard way this is supposed to be handled?
> 
> Yes. Since ages. The ioctl is called DMX_SET_SOURCE.

DMX_SET_SOURCE seems to not be implemented anywhere, all it does is 
return EINVAL. I also fail to find any useful documentation about what 
it is supposed to do.

> 
>> There are no mechanism to connect a frontend with specific dvr or
>> demux devices in the current API. But you demand it for the caio device.
> 

I think there is currently no useful API to connect devices. Every few 
months there comes a new device which deprecates how I enumerate devices 
and determine types of FE's.

The most useful way to query devices seems to be using HAL, and I think 
this is the correct way in Linux, but DVB-API may be lacking with 
providing the necessary information. Maybe this is the direction we 
should consider? Device names under /dev seem to be irrelevant nowadays.

Best regards,
Martin Vidovic
