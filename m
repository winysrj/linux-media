Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36408 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbcCDH2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 02:28:08 -0500
Received: by mail-qk0-f174.google.com with SMTP id s68so17944915qkh.3
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 23:28:07 -0800 (PST)
Received: from mail-qk0-f181.google.com (mail-qk0-f181.google.com. [209.85.220.181])
        by smtp.gmail.com with ESMTPSA id r189sm1103050qhr.4.2016.03.03.23.28.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Mar 2016 23:28:07 -0800 (PST)
Received: by mail-qk0-f181.google.com with SMTP id s68so17944828qkh.3
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 23:28:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9+P=e+fPouiOHi3DEmVb3eRreVJyQM9E-KeV9uw+KHPnA@mail.gmail.com>
References: <CAGGr8Nt3pWTOsDJZQ9_hQo1j1Aow47W6xrTsPgXsH_+0S1sksA@mail.gmail.com>
	<CAHFNz9L_wxNwju6nXuhv+H4ObhBPJnrauYqv0Gmp4soQG7fgrg@mail.gmail.com>
	<CAGGr8Nsc4NPcG6WK0ZJoa3-ev7Bo3+tSH-no-xxLigs6ALXj3Q@mail.gmail.com>
	<CAHFNz9+R-Twg+LALn9VUbNMmPr4-L1bUF7dtzFsoyaNg8Y_Ekg@mail.gmail.com>
	<56655DE1.7000109@gmail.com>
	<CAHFNz9+P=e+fPouiOHi3DEmVb3eRreVJyQM9E-KeV9uw+KHPnA@mail.gmail.com>
Date: Fri, 4 Mar 2016 09:28:06 +0200
Message-ID: <CAAZRmGw9-jUDwOC1qpeyT+Ng0sS2nJ4=GnBsP95JNELBsDsyVQ@mail.gmail.com>
Subject: Re: AverMedia HD Duet (White Box) A188WB drivers
From: Olli Salonen <olli.salonen@iki.fi>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Jemma Denson <jdenson@gmail.com>,
	David Nelson <nelson.dt@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manu,

How's it going with the SAA7160? I'd be really happy to see the driver
being mainlined, but do not really understand if there is some major
showstoppers still that keep this from happening.

Luis has his personal media_tree here
https://github.com/ljalves/linux_media/wiki that contains Manu's
SAA7160 driver and as far as I understand many people are using that
tree with good success. If that could integrated into the tree, I'm
sure the community can help to iron out any possible issues existing
there still.

Cheers,
-olli

On 7 December 2015 at 14:06, Manu Abraham <abraham.manu@gmail.com> wrote:
> Hi Jemma,
>
> I am having a downtime, the development machine in a recovery
> process. If things go well, expecting the system next week.
>
> Regards,
>
> Manu
>
>
> On Mon, Dec 7, 2015 at 3:52 PM, Jemma Denson <jdenson@gmail.com> wrote:
>> Hi Manu,
>>
>> On 08/10/15 17:28, Manu Abraham wrote:
>>>
>>> Hi,
>>>
>>> I just got back at work again. Will set things up this weekend/next week.
>>
>>
>> Have you had a chance to make any more progress on this?
>>
>> As you're probably aware there are quite a few drivers waiting for saa716x
>> to be integrated into the tree; if you need some help here is the work
>> remaining to be done something that can be picked up by other people?
>>
>> Regards,
>>
>> Jemma.
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
