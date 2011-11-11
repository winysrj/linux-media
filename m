Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55295 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1KKN2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 08:28:05 -0500
Received: by iage36 with SMTP id e36so4127808iag.19
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2011 05:28:04 -0800 (PST)
Message-ID: <4EBD22E5.7030405@gmail.com>
Date: Fri, 11 Nov 2011 07:28:05 -0600
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
> <pdickeybeta@gmail.com> wrote: snipped to conserve space and also
> unrelated to this email....
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

Here are the results of applying the first patch (c119f08c4dd2.patch)
to my branch:

patch -p2 -i c119f08c4dd2.patch
patching file Documentation/video4linux/CARDLIST.em28xx
Hunk #1 FAILED at 72.
1 out of 1 hunk FAILED -- saving rejects to file
Documentation/video4linux/CARDLIST.em28xx.rej
patching file drivers/media/dvb/frontends/Kconfig
Hunk #1 FAILED at 614.
1 out of 1 hunk FAILED -- saving rejects to file
drivers/media/dvb/frontends/Kconfig.rej
patching file drivers/media/dvb/frontends/Makefile
Hunk #1 FAILED at 82.
1 out of 1 hunk FAILED -- saving rejects to file
drivers/media/dvb/frontends/Makefile.rej
patching file drivers/media/video/em28xx/em28xx-cards.c
Hunk #1 succeeded at 193 with fuzz 1 (offset 12 lines).
Hunk #2 succeeded at 1852 with fuzz 2 (offset 121 lines).
Hunk #3 succeeded at 1980 with fuzz 1 (offset 125 lines).
patching file drivers/media/video/em28xx/em28xx-dvb.c
Hunk #1 FAILED at 35.
Hunk #2 succeeded at 420 with fuzz 1 (offset 120 lines).
Hunk #3 succeeded at 639 with fuzz 2 (offset 172 lines).
Hunk #4 succeeded at 848 with fuzz 2 (offset 262 lines).
1 out of 4 hunks FAILED -- saving rejects to file
drivers/media/video/em28xx/em28xx-dvb.c.rej
patching file drivers/media/video/em28xx/em28xx.h
Hunk #1 FAILED at 114.
1 out of 1 hunk FAILED -- saving rejects to file
drivers/media/video/em28xx/em28xx.h.rej
patching file drivers/media/dvb/frontends/drx39xyj/Kconfig
patching file drivers/media/dvb/frontends/drx39xyj/Makefile
patching file drivers/media/dvb/frontends/drx39xyj/bsp_host.h
patching file drivers/media/dvb/frontends/drx39xyj/bsp_i2c.h
patching file drivers/media/dvb/frontends/drx39xyj/bsp_tuner.h
patching file drivers/media/dvb/frontends/drx39xyj/bsp_types.h
patching file drivers/media/dvb/frontends/drx39xyj/drx39xxj.c
patching file drivers/media/dvb/frontends/drx39xyj/drx39xxj.h
patching file drivers/media/dvb/frontends/drx39xyj/drx39xxj_dummy.c
patching file drivers/media/dvb/frontends/drx39xyj/drx_dap_fasi.c
patching file drivers/media/dvb/frontends/drx39xyj/drx_dap_fasi.h
patching file drivers/media/dvb/frontends/drx39xyj/drx_driver.c
patching file drivers/media/dvb/frontends/drx39xyj/drx_driver.h
patching file drivers/media/dvb/frontends/drx39xyj/drx_driver_version.h
patching file drivers/media/dvb/frontends/drx39xyj/drxj.c
patching file drivers/media/dvb/frontends/drx39xyj/drxj.h
patching file drivers/media/dvb/frontends/drx39xyj/drxj_map.h
patching file drivers/media/dvb/frontends/drx39xyj/drxj_mc.h
patching file drivers/media/dvb/frontends/drx39xyj/drxj_mc_vsb.h
patching file drivers/media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h
patching file drivers/media/dvb/frontends/drx39xyj/drxj_options.h

> That approach should only take a few minutes, given the conflicts
> are trivial to resolve.

Yes they are trivial to resolve. The CARDLIST.em28xx needs to be
changed to 81 and reflect the preceeding lines. The Kconfig and
Makefile just need to have lines adjusted (and the endif removed from
the Kconfig).

I successfully applied the second patch (30c6512030ac.patch) to
everything (since it's only changing your email address on the
drx39xyj files).

I have your two patches in my branch directory.Now I have a few
options to choose from (as I see it)

1. Should I submit your two patches and then go back and fix the bugs,
then submit those patches?

2. Should I fix the bugs first, then submit your two patches as 01 and
02, and my bug-fixes as 03 through 07?

3. Should I fix the bugs, then fix as many of the coding style issues
as I can find, and submit all of the patches as one giant group (your
two patches being 01 and 02, the bug fixes being 03 through 07, and
the coding style fixes being 08 through 25 or so)?

or

4.  Should I fix your patches and submit those (I'm already ruling
this out, but it does seem like the easiest way through this whole
process)?


If these seem like trivial or newbie questions, I'm sorry. I look at
it like this: I messed up my first time through. So I want to make
sure I have all of my ducks in a row before I make my second attempt.


> 
> Good luck!
> 
> Devin
> 

Thank you. My first time through wasn't as clean and pretty as I hoped
it would be. And I appreciate all of the help that I'm getting (from
you and everyone else).

Have a great day:)
Patrick.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk69IuUACgkQMp6rvjb3CAT4nQCfdppURISh7+PfD0nvd+lulfEz
rSUAn1IxrAKQv9vcf7AdQENKsLRFEnpE
=plxb
-----END PGP SIGNATURE-----
