Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37309 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab2I0HAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 03:00:38 -0400
Received: by wibhq12 with SMTP id hq12so5801861wib.1
        for <linux-media@vger.kernel.org>; Thu, 27 Sep 2012 00:00:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926104202.794c96c5@lwn.net>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-3-git-send-email-javier.martin@vista-silicon.com>
	<20120926104202.794c96c5@lwn.net>
Date: Thu, 27 Sep 2012 09:00:37 +0200
Message-ID: <CACKLOr33ACaXVXj23QDjJx17MO7E7DA-=zhExaGxq2yxLVrpqg@mail.gmail.com>
Subject: Re: [PATCH 2/5] media: ov7670: make try_fmt() consistent with
 'min_height' and 'min_width'.
From: javier Martin <javier.martin@vista-silicon.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 September 2012 18:42, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 26 Sep 2012 11:47:54 +0200
> Javier Martin <javier.martin@vista-silicon.com> wrote:
>
>> 'min_height' and 'min_width' are variables that allow to specify the minimum
>> resolution that the sensor will achieve. This patch make v4l2 fmt callbacks
>> consider this parameters in order to return valid data to user space.
>>
> I'd have preferred to do this differently, perhaps backing toward larger
> sizes if the minimum turns out to be violated.  But so be it...
>
> Acked-by: Jonathan Corbet <corbet@lwn.net>
>
> jon

Thank you. I will have to modify this patch slightly when I fix the
previous one though.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
