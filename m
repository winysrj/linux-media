Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34743 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1EYWCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 18:02:51 -0400
Received: by qyk7 with SMTP id 7so2378403qyk.19
        for <linux-media@vger.kernel.org>; Wed, 25 May 2011 15:02:50 -0700 (PDT)
References: <1306305788.2390.4.camel@porites> <1306306916.2390.6.camel@porites> <21882CB6-3679-444E-A072-8AAE43610367@wilsonet.com>
In-Reply-To: <21882CB6-3679-444E-A072-8AAE43610367@wilsonet.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <9C58F89F-7B1F-4D72-AD30-59AC8E3921A8@wilsonet.com>
Content-Transfer-Encoding: 8BIT
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: build errors on kinect and rc-main - 2.6.38 (mipi-csis not rc-main)
Date: Wed, 25 May 2011 18:02:57 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On May 25, 2011, at 5:41 PM, Jarod Wilson wrote:

> On May 25, 2011, at 3:01 AM, Nicolas WILL wrote:
> 
>> On Wed, 2011-05-25 at 07:43 +0100, Nicolas WILL wrote:
>>> The second one is on rc-main (I probably need that!):
>>> 
>>> CC [M]  /home/nico/src/media_build/v4l/rc-main.o
>>> /home/nico/src/media_build/v4l/rc-main.c: In function 'rc_allocate_device':
>>> /home/nico/src/media_build/v4l/rc-main.c:993:29: warning: assignment from incompatible pointer type
>>> /home/nico/src/media_build/v4l/rc-main.c:994:29: warning: assignment from incompatible pointer type
>>> CC [M]  /home/nico/src/media_build/v4l/ir-raw.o
>>> CC [M]  /home/nico/src/media_build/v4l/mipi-csis.o
>>> /home/nico/src/media_build/v4l/mipi-csis.c:29:28: fatal error: plat/mipi_csis.h: No such file or directory
>>> compilation terminated.
>> 
>> Oh, not rc-main, but mipi-csis!
> 
> True, but the rc-main warning is actually a valid issue that needs to
> be fixed as well. I'll get the necessary backport patch into media_build
> shortly, I hope...

Patches pushed.

-- 
Jarod Wilson
jarod@wilsonet.com



