Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:34726 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472AbZJIP1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Oct 2009 11:27:24 -0400
Received: by bwz6 with SMTP id 6so1663014bwz.37
        for <linux-media@vger.kernel.org>; Fri, 09 Oct 2009 08:26:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ACF714A.2090209@xfce.org>
References: <4ACDF829.3010500@xfce.org>
	 <37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>
	 <4ACDFED9.30606@xfce.org>
	 <829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>
	 <4ACE2D5B.4080603@xfce.org>
	 <829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>
	 <4ACF03BA.4070505@xfce.org>
	 <829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>
	 <4ACF714A.2090209@xfce.org>
Date: Fri, 9 Oct 2009 11:26:46 -0400
Message-ID: <829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>
Subject: Re: Hauppage WinTV-HVR-900H
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ali Abdallah <aliov@xfce.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 9, 2009 at 1:22 PM, Ali Abdallah <aliov@xfce.org> wrote:
> Screenshots here for TV and S-Video input configuration with TV time.
>
> http://ali.blogsite.org/files/tvtime/
>>
>> Could you try the S-Video or composite input and see if the picture
>> quality is still bad (as this well help isolate whether it's a problem
>> with the tuner chip or the decoder.
>>
>
> Same picture quality with S-Video, but with composite there is no picture.

Ok, this helps alot.  This rules out the tuner and suggests that
perhaps the video decoder is not being programmed properly.

Could you please send me the output of "dmesg"?  I'll see about
setting up a tree with some additional debugging for you to try out.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
