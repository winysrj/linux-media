Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34896 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760040Ab2J3S3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 14:29:30 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so327166bkc.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 11:29:29 -0700 (PDT)
Message-ID: <50900E76.8080903@googlemail.com>
Date: Tue, 30 Oct 2012 19:29:26 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: dheitmueller@kernellabs.com
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com> <20121028175752.447c39d5@redhat.com> <508EA1B8.3070304@googlemail.com> <20121029180348.7e7967aa@redhat.com> <508EF1CF.8090602@googlemail.com> <20121030010012.30e1d2de@redhat.com> <20121030020619.6e854f70@redhat.com> <CAGoCfiw+G2CnGJSum2k9M80XizKSTfw34gXZOkOZBp_OvSTtjQ@mail.gmail.com>
In-Reply-To: <CAGoCfiw+G2CnGJSum2k9M80XizKSTfw34gXZOkOZBp_OvSTtjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 30.10.2012 15:08, schrieb Devin Heitmueller:
> On Tue, Oct 30, 2012 at 12:06 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Did a git bisect. The last patch where the bug doesn't occur is this
>> changeset:
>>         em28xx: add module parameter for selection of the preferred USB transfer type
>>
>> That means that this changeset broke it:
>>
>>         em28xx: use common urb data copying function for vbi and non-vbi devices
> Oh good, when I saw the subject line for that patch, I got worried.
> Looking at the patch, it seems like he just calls the VBI version for
> both cases assuming the VBI version is a complete superset of the
> non-VBI version, which it is clearly not.

Devin, I've read the code carefully and both functions are basically
doing the same, except that the non-VBI-version bails out when it
detects a VBI-header (see the FIXME statement ;) ).
Btw: the header checks at the end of the non-VBI-version are incomplete,
which corrupts frames from time to time when using bulk transfers.
Fixing this would make both functions even more similar.

> That whole patch should just be reverted.  If he's going to spend the
> time to refactor the code to allow the VBI version to be used for both
> then fine, but blindly calling the VBI version without making real
> code changes is *NOT* going to work.

That's all plain wrong.
a) Nothing needs to be reverted, because these patches are not yet in
the repo.
b) I'm doing nothing blindly here, I tested the patch carefully and it
works with Silvercrest webcam (em2820).
c) the patch not just calls the VBI-version of the function, it also
fixes/improves some issues. And (as mentioned above), it does a few
things better than non-VBI-version, so I don't need to fix the latter.

> Frank, good job in naming your patch - it made me scream "WAIT!" when
> I saw it.

Ehm... ??? That sounded a bit different in your previous mail...

Citation:
"This is generally good stuff. When I originally added the VBI support,
I kept the URB handlers separate initially to reduce the risk of breaking
existing devices, and always assumed that at some point the two routines
would be merged."
> Bad job for blindly submitting a code change without any
> idea whether it actually worked.  ;-)

See above, it's plain wrong.

> I know developers have the tendency to look at code and say "oh,
> that's ugly, I should change that."  However it's more important that
> it actually work than it be pretty.

I agree.
And some developers have the tendency to just add tons of very similar
new code which is basically doing the same just because it saves time. ;)
But thinking about things a few minutes longer / doing some more testing
at the beginning saves much more time in the long run...

Devin, your whole message really isn't helpfull.
Instead of making lots of wrong assertions, it would be nice to get some
constructive comments regarding the code changes or hardware behavior.

Regards,
Frank

> Devin
>


