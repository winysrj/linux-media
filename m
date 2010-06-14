Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50175 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab0FNOT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 10:19:29 -0400
Received: by yxl31 with SMTP id 31so1361482yxl.19
        for <linux-media@vger.kernel.org>; Mon, 14 Jun 2010 07:19:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100614032105.GA3456@localhost.localdomain>
References: <20100317145900.GA7875@localhost.localdomain>
	<829197381003170843u73743ccand32e7d0d2e6d3ca6@mail.gmail.com>
	<20100613150938.GA5483@localhost.localdomain>
	<AANLkTimgmQzy5sAh_lU_RHYj-ZD9XZavvLmgs7tSNNdZ@mail.gmail.com>
	<20100614032105.GA3456@localhost.localdomain>
Date: Mon, 14 Jun 2010 10:19:28 -0400
Message-ID: <AANLkTikSa6M2wzPz9Ro4z-hHOQXBSFvpOapRpk4fKdzX@mail.gmail.com>
Subject: Re: Problem with em28xx card, PAL and teletext
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Eugeniy Meshcheryakov <eugen@debian.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 13, 2010 at 11:21 PM, Eugeniy Meshcheryakov
<eugen@debian.org> wrote:
> Thanks, that patch fixes the shifting problem, all the pixels are in the
> right place.

Ok, I'll issue a PULL request to get that upstream.  Thanks for testing.

>> In the meantime though,
>> you can work around the issue by cropping out the lines with the
>> following command:
>>
>> /usr/bin/mplayer -vo xv,x11 tv:// -tv
>> driver=v4l2:device=/dev/video0:norm=PAL:width=720:height=576:input=1
>> -vf crop=720:572:0:0
> Thanks for the tip. It worked with 640x480. But when I tried to use
> 720x576 I got a picture with a lot of noise made of horizontal white
> lines. However maybe it is because of damaged USB connector...

If you email me a screenshot (preferably off list due to the size), I
can probably provide some additional advice.  Also please provide the
exact mplayer command you used so I can try to reproduce it here.

> Also teletext is still unreadable (both with 640x480 and 720x576). Does
> mplayer support teletext correctly? And can it work with resolution
> 640x480?

I don't know how good mplayer's teletext support is.  When I did the
original work, I did the testing using "mtt", and in fact I had to do
it over an SSH link since I didn't have a teletext feed here.  It
should work at 640x480 though.

I would suggest you try it with mtt/tvtime at 720x576 and see if it
works.  If it does, then we have a starting point to narrow down
whether it's an issue with the application, the selected capture
resolution, the driver itself, or something strange about the teletext
feed itself.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
