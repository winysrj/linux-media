Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:34761 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbZFSNXd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 09:23:33 -0400
Received: by yw-out-2324.google.com with SMTP id 5so967908ywb.1
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 06:23:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906191441.13521.zzam@gentoo.org>
References: <200906191321.05477.zzam@gentoo.org> <4A3B809D.7050709@linuxtv.org>
	 <200906191441.13521.zzam@gentoo.org>
Date: Fri, 19 Jun 2009 09:15:19 -0400
Message-ID: <829197380906190615q2d76542cj9aed55d74d8f9205@mail.gmail.com>
Subject: Re: [PATCH] Use kzalloc for frontend states to have struct
	dvb_frontend properly initialized
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org, Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Steven Toth <stoth@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 19, 2009 at 8:41 AM, Matthias Schwarzott<zzam@gentoo.org> wrote:
> Yes, I did verify that. There are no memset calls for that memory.
>
>> If so, you can add my "Acked-by: Andreas Oberritter
>> <obi@linuxtv.org>".
>>
> Regards
> Matthias

I'm glad to see this finally happen.  This has been bugging me for a
while on s5h1409/s5h1411 and I just never got around to submitting a
patch.

Thanks!

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
