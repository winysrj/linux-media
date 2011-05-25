Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56626 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab1EYVlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 17:41:14 -0400
Received: by qwk3 with SMTP id 3so77727qwk.19
        for <linux-media@vger.kernel.org>; Wed, 25 May 2011 14:41:13 -0700 (PDT)
References: <1306305788.2390.4.camel@porites> <1306306916.2390.6.camel@porites>
In-Reply-To: <1306306916.2390.6.camel@porites>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <21882CB6-3679-444E-A072-8AAE43610367@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: build errors on kinect and rc-main - 2.6.38 (mipi-csis not rc-main)
Date: Wed, 25 May 2011 17:41:21 -0400
To: Nicolas WILL <nico@youplala.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On May 25, 2011, at 3:01 AM, Nicolas WILL wrote:

> On Wed, 2011-05-25 at 07:43 +0100, Nicolas WILL wrote:
>> The second one is on rc-main (I probably need that!):
>> 
>>  CC [M]  /home/nico/src/media_build/v4l/rc-main.o
>> /home/nico/src/media_build/v4l/rc-main.c: In function 'rc_allocate_device':
>> /home/nico/src/media_build/v4l/rc-main.c:993:29: warning: assignment from incompatible pointer type
>> /home/nico/src/media_build/v4l/rc-main.c:994:29: warning: assignment from incompatible pointer type
>>  CC [M]  /home/nico/src/media_build/v4l/ir-raw.o
>>  CC [M]  /home/nico/src/media_build/v4l/mipi-csis.o
>> /home/nico/src/media_build/v4l/mipi-csis.c:29:28: fatal error: plat/mipi_csis.h: No such file or directory
>> compilation terminated.
> 
> Oh, not rc-main, but mipi-csis!

True, but the rc-main warning is actually a valid issue that needs to
be fixed as well. I'll get the necessary backport patch into media_build
shortly, I hope...

-- 
Jarod Wilson
jarod@wilsonet.com



