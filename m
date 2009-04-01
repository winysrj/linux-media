Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:45090 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189AbZDAShj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 14:37:39 -0400
To: Darius Augulis <augulis.darius@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc_camera_open() not called
References: <49D37485.7030805@gmail.com> <49D3788D.2070406@gmail.com>
	<87zlf0cl7o.fsf@free.fr> <49D3AE13.9070201@gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 01 Apr 2009 20:37:27 +0200
In-Reply-To: <49D3AE13.9070201@gmail.com> (Darius Augulis's message of "Wed\, 01 Apr 2009 21\:10\:27 +0300")
Message-ID: <87r60cmd94.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Darius Augulis <augulis.darius@gmail.com> writes:

>>> Darius Augulis wrote:
>>>     
>>>> Hi,
>>>>
>>>> I'm trying to launch mx1_camera based on new v4l and soc-camera tree.
>>>> After loading mx1_camera module, I see that .add callback is not called.
>>>> In debug log I see that soc_camera_open() is not called too.
>>>> What should call this function? Is this my driver problem?
>>>> p.s. loading sensor driver does not change situation.
>>>>       
>>
>> Are you by any chance using last 2.6.29 kernel ?
>> If so, would [1] be the answer to your question ?
>>
>> [1] http://lkml.org/lkml/2009/3/24/625

> thanks. it means we should expect soc-camera fix for this?
> I'm using 2.6.29-git8, but seems it's not fixed yet.
No, I don't think so.

The last time I checked there had to be an amendement to the patch which
introduced the driver core regression, as it touches other areas as well
(sound/soc and mtd from memory).

I think Guennadi can confirm this, as he's the one who raised the issue in the
first place.

Cheers.

--
Robert
