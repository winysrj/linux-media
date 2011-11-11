Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35380 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab1KKLj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 06:39:27 -0500
Received: by iage36 with SMTP id e36so4039715iag.19
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2011 03:39:26 -0800 (PST)
Message-ID: <4EBD096F.8080406@gmail.com>
Date: Fri, 11 Nov 2011 05:39:27 -0600
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 00/25] Add PCTV-80e Support to v4l
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com> <CAGoCfiz5O4_GHnYWtt4RQsRCWV7iXEh8DYYNFX1_R7Ni2e3Yvg@mail.gmail.com> <4EBC8A2C.40305@gmail.com> <CAGoCfiyox6rW_g4paHXL7_U4wx3MF_178xCta3n2R58OgvZVCQ@mail.gmail.com>
In-Reply-To: <CAGoCfiyox6rW_g4paHXL7_U4wx3MF_178xCta3n2R58OgvZVCQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/10/2011 09:19 PM, Devin Heitmueller wrote:
> On Thu, Nov 10, 2011 at 9:36 PM, Patrick Dickey
> <pdickeybeta@gmail.com> wrote:
>> Also, I started to clean up the files tonight. Then I started
>> thinking about what you told me about the as102 drivers, and
>> thought I should submit them "as is" and then start the cleanup
>> and submit those patches separately. Also that way others could
>> help with some of the cleanup. I have to figure out if there's an
>> easy way to convert all of the "DOS Line Endings" to the
>> appropriate style, or if I'll have to do that manually (and
>> whether my editor(s) caused this).
> 
> Definitely you want the cleanup fixes to be in separate patches
> from the original patch with the driver.  This is necessary because
> it makes it *much* easier to figure out if something got broken as
> a result of a cleanup patch (which isn't supposed to make any
> functional change).
> 
>> One reason I did the extra work is because your tree had other
>> files (the cx18 drivers for example) that didn't seem to be
>> needed by the tuner. So, I cleaned them out (partially because I
>> have two cards that use those drivers and didn't want to break
>> those).  I can review all of the files to make sure that I didn't
>> miss any.  And I can update all of the files from your tree to
>> the most current versions and submit everything again.
> 
> This shouldn't be the case (the two patches will have no
> interaction with any driver other than em28xx).  I would suggest
> that instead of treating it as a tree, just suck the two patches
> off the top and apply them to your current tree one at a time, and
> fix any conflicts that pop up.
> 
> http://kernellabs.com/hg/~dheitmueller/v4l-dvb-80e/raw-rev/c119f08c4dd2
>
> 
http://kernellabs.com/hg/~dheitmueller/v4l-dvb-80e/raw-rev/30c6512030ac
> 
> If you just apply the patches instead of trying to hand-merge the
> two trees together, you will only get the delta and will likely
> just have to fix the 4 or five conflicts in em28xx.h and
> em28xx-cards.c (related to the fact that subsequent boards were
> added to the driver after my patch).
> 
> That approach should only take a few minutes, given the conflicts
> are trivial to resolve.
> 
> Good luck!
> 
> Devin
> 

Thank you again for the quick reply. I think that the problem I had
was that I hand merged everything (using meld, but that's beside the
point). While I was at work last night, I decided that I need to do
exactly what you suggested here.  Hopefully that will take care of the
Signed Off By problems too (if not, then I'll manually enter them).

If this works as it should, how do I retract this patch series (as
they'll no longer be valid) or is it safe to say that they'll be
ignored from here out?

Have a great day:)
Patrick.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk69CW8ACgkQMp6rvjb3CAQm+QCcD9W6MlDVOWyLF6g9pK8GJPOs
YLoAn3YINjWVGBRW+nhP02YHxAmT4nAu
=ll3c
-----END PGP SIGNATURE-----
