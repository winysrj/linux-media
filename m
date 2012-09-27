Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52076 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2I0Hlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 03:41:46 -0400
Received: by weyt9 with SMTP id t9so444144wey.19
        for <linux-media@vger.kernel.org>; Thu, 27 Sep 2012 00:41:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926105244.177b2471@lwn.net>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-6-git-send-email-javier.martin@vista-silicon.com>
	<20120926105244.177b2471@lwn.net>
Date: Thu, 27 Sep 2012 09:41:44 +0200
Message-ID: <CACKLOr0D9=oeYH0ZxKTOdKWXanFSHagRQu18x2SAPBJ1yiZ3zQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] media: ov7670: Add possibility to disable pixclk
 during hblank.
From: javier Martin <javier.martin@vista-silicon.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 September 2012 18:52, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 26 Sep 2012 11:47:57 +0200
> Javier Martin <javier.martin@vista-silicon.com> wrote:
>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/media/i2c/ov7670.c |    8 ++++++++
>>  include/media/ov7670.h     |    1 +
>>  2 files changed, 9 insertions(+)
>
> Again, needs a changelog.  Otherwise

Our soc-camera host driver captures pixels during blanking periods if
pixclk is enabled. In order to avoid capturing bogus data we need to
disable pixclk during those blanking periods

I'll add it to v2.

> Acked-by: Jonathan Corbet <corbet@lwn.net>
>

Thank you.



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
