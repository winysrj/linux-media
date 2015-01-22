Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42005 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbAVBvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2015 20:51:01 -0500
Received: by mail-ig0-f174.google.com with SMTP id b16so18851108igk.1
        for <linux-media@vger.kernel.org>; Wed, 21 Jan 2015 17:51:01 -0800 (PST)
MIME-Version: 1.0
From: Nathan Meyer <nate.meyer.2011@gmail.com>
Date: Wed, 21 Jan 2015 20:50:33 -0500
Message-ID: <CA+WqcYuan5hDqWcR2VwkOFyNYOqCg=5FOEbMVn3B1cfyjQvjrw@mail.gmail.com>
Subject: Re: Working on Avermedia Duet A188 (saa716x and lgdt3304)
To: linux-media@vger.kernel.org
Cc: richardh68@hotmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tim <richardh68 <at> hotmail.com> writes:
>
>  I'd like to try this again, as my last working tuner died this week. I've had
> this card sitting around for over
> > a year hoping for support, but it doesn't look like anyone else is working on
> it.
> >
> > What kind of information is needed to make the card work? Will I need to find
> firmware somewhere? It looks
> > like the basics are there with Manu's work on the SAA716x and Jared and
> Michael's work on the LGDT3304, but
> > how do I customize these to work with the A188?
> >
> > Any help would be appreciated, thanks!
> >
> > Oblib
> >
> >
> >
>
> I have been playing with this aswell.. I haven't done C since college.
> I hope someone could help us with this..
>
> I have done some leg work here..
>
> 1) I have contacted Avermedia to see if they will release the source to the
> windows drivers.. Can't hurt to ask.. waiting their response.. it had to be
> referred to R&D department. So it Wasnt No..
>
> 2) The actual components on the board are
> 2x TDA18271hdc2 in what appears to be a master slave setup(maybe.. Only one coax
> input)
> 2x LGDT3304
> 1x 60E
>
> 3) I have pulled this repository and worked from there..
> http://linuxtv.org/hg/~endriss/mirror-saa716x/
> I have edited the SAA71x budget Driver so that it recognizes the card and
> the cards rom tells us this..

Hey Tim,

Had you made any more progress on this driver?  Did you ever get
anything more working?

-Nate
