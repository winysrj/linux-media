Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33272 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932244AbcIHP7k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 11:59:40 -0400
Received: by mail-it0-f68.google.com with SMTP id g185so4956585ith.0
        for <linux-media@vger.kernel.org>; Thu, 08 Sep 2016 08:59:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <973834E5-E192-4EE3-AAAE-AD28086CF3D0@darmarit.de>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
 <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
 <20160824114927.3c6ab0d6@vento.lan> <20160824115241.7e2c90ca@vento.lan>
 <28A9DFEA-1E94-4EE0-A2BB-B22D029683B9@darmarit.de> <20160905102511.6de3dbe4@vento.lan>
 <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com> <20160906064108.5bd84045@vento.lan>
 <CAA7C2qj5ap3PoK2uenF+kqpCrqjO9znR4y5Y7h2UoaENDcT8XA@mail.gmail.com>
 <20160906124723.6783fd39@vento.lan> <7C627C3A-DF3F-4E50-9876-7130D9221D96@darmarit.de>
 <CAA7C2qh-XGBxsZk_GdO+Oj2Q8x9SqA1XOAb+b0ZRbsNCR2eesw@mail.gmail.com> <973834E5-E192-4EE3-AAAE-AD28086CF3D0@darmarit.de>
From: VDR User <user.vdr@gmail.com>
Date: Thu, 8 Sep 2016 08:59:38 -0700
Message-ID: <CAA7C2qhuogG0RgsU9eaO5SxWVL2g2nzqutcDpmzscWjV6soyFA@mail.gmail.com>
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Chris Mayo <aklhfex@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> There is already a publicly available VDR repository offering the
>> current stable & developer versions, along with all previous versions:
>> http://www.tvdr.de/download.htm
>
> ?? these are tarballs, where is the version control system?

That would be a question for Klaus, the author of VDR. I will say that
whatever system he uses for `version control` has seemed to work fine
in the 12 years or so I've been using VDR. If it's that important to
you to download from git instead, you can use the following mirror:
https://projects.vdr-developer.org/git/vdr.git/

Don't expect that to be of any real advantage however. VDR is not
developed that way.

>> It's best to refer to VDRs packaged documention. You can get the
>> channels.conf format definition with `man 5 vdr`.
>
> Good point, but I have only 2.2 installed, so where get I the backward
> informations .. should I extract all theses tarballs and read through
> them .. you see my point?

That's not necessary. Klaus has designed VDR in such a way that things
don't break when they're updated. You only need to refer to the
documentation of the most recent version.

>> That wiki shouldn't be viewed as a main reference point in general but
>> especially for scanning.
>
> And the main ref is https://www.linuxtv.org ... which is not updated?

That page is certainly outdated and has never been considered a main
reference. People by far have always used vdrportal, another forum
which is now defunct (which focused on NA/SA), and the VDR mailing
list as their main reference points.

> What I said, nobody use the vdr format of dvbv5-tools, since it
> is broken and now, Chris and I want to fix it.

That, and there are other tools that are easier and/or simply work
better for some people (such as nscan).

>> I'd recommend posting to the VDR mailing list where you'll find more
>> people who use and would be affected by these changes. Additionally,
>> you could inquire at vdr-portal.de, which is one of the most supported
>> VDR forums for both users and developers.
>
> Chris and I want to patch something in v4l-utils which is broken
> and YOU make the assumption that our patches are not OK ... and now, #
> I have to ask someone other on a different projects ML and their portal?

I made no claim whether your patches are ok or not. I simply said you
should not intentionally or unnecessarily break backwards
compatibility, and I based that comment on what others have said.
Additionally, if you want to update tools to be more usable why
wouldn't you want input from the very people you hope will use them?!
Suggesting you should inquire on the VDR mailing list is clearly NOT
bad advice.

> If you have a doubt about the patches from Chris and mine, make a test and
> if you see any regression it would be great to post your experience here ...

Since everything I say is met with resistance, I think I'll pass. I
only replied in this thread to help but now I've lost interest. Good
luck with your patch however.
