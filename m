Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63858 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933409AbZDASKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 14:10:31 -0400
Received: by fxm2 with SMTP id 2so160301fxm.37
        for <linux-media@vger.kernel.org>; Wed, 01 Apr 2009 11:10:28 -0700 (PDT)
Message-ID: <49D3AE13.9070201@gmail.com>
Date: Wed, 01 Apr 2009 21:10:27 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc_camera_open() not called
References: <49D37485.7030805@gmail.com> <49D3788D.2070406@gmail.com> <87zlf0cl7o.fsf@free.fr>
In-Reply-To: <87zlf0cl7o.fsf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik wrote:
> Darius Augulis <augulis.darius@gmail.com> writes:
>
>   
>> Darius Augulis wrote:
>>     
>>> Hi,
>>>
>>> I'm trying to launch mx1_camera based on new v4l and soc-camera tree.
>>> After loading mx1_camera module, I see that .add callback is not called.
>>> In debug log I see that soc_camera_open() is not called too.
>>> What should call this function? Is this my driver problem?
>>> p.s. loading sensor driver does not change situation.
>>>       
>
> Are you by any chance using last 2.6.29 kernel ?
> If so, would [1] be the answer to your question ?
>   

thanks. it means we should expect soc-camera fix for this?
I'm using 2.6.29-git8, but seems it's not fixed yet.


> Cheers
>
> --
> Robert
>
> [1] http://lkml.org/lkml/2009/3/24/625
>
>   

