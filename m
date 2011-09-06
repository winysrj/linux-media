Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33510 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1IFVSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 17:18:11 -0400
Received: by bke11 with SMTP id 11so5830934bke.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 14:18:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E667094.6010508@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
	<4E663EE2.3050403@redhat.com>
	<CAGoCfiz9YAHYNJdEAT51fyfLY8RS_TcRpzKzLYCdNFCc3JcbEA@mail.gmail.com>
	<4E666417.9090706@redhat.com>
	<CAGoCfiy9QK1vcrDSBw7J382LXAdE+YzN3SdAu+fCkD-6-8M8=g@mail.gmail.com>
	<4E667094.6010508@redhat.com>
Date: Tue, 6 Sep 2011 17:18:09 -0400
Message-ID: <CAGoCfiyFTwHRLvct_Rf7Mmiua4MZ7Mtq_G4ka+F6sYEjAQ-aow@mail.gmail.com>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 6, 2011 at 3:12 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> From a practical standpoint, the Ubuntu folks have the original tvtime
>> tarball and all their changes in one patch, which is clearly a bunch
>> of patches that are mashed together probably in their build system. I
>> need to reach out to them to find where they have an actual SCM tree
>> or the individual patches.  They've got a bunch of patches which would
>> be good to get into a single tree (autobuild fixes, cross-compilation,
>> locale updates, etc).
>
> Yeah, it seems interesting. Maybe we can get something from this place:
>        http://packages.qa.debian.org/t/tvtime.html
>
> The maintainer there seems to be:
>        http://qa.debian.org/developer.php?login=bartm@debian.org

I reached out to the Ubuntu maintainer; we'll see if he gets back to
me.  From what I can tell it seems like Debian is actually taking the
patches from Ubuntu (yes, I realize this is backwards from their
typical process where Ubuntu bases their stuff on Debian).

>> In the long term I have no real issue with the LinuxTV group being the
>> official maintainer of record.  I've got lots of ideas and things I
>> would like to do to improve tvtime, but in practice I've done a pretty
>> crappy job of maintaining the source (merging patches, etc) at this
>> point.
>
> Putting it on a common place and giving permissions to a group of people
> is interesting, as none of us are focused on userspace, so we all
> have a very limited amount of time for dealing with userspace applications.
>
> By giving commit rights to a group of developers, it ends that more
> developers will contribute, speeding up the development.
>
> That was what happened with v4l-utils and, on a minor scale, with xawtv3.
>
> If you're ok with that, I can set a tvtime git repository at LinuxTV,
> cloning the tree I've created there already (it is a pure conversion
> of your tree from mercurial into git, if I remove the patches I've
> done so far from your clone), giving you the ownership of the new tree,
> and marking it as a shared repository.

I have no problem with this.  Let's set it up.

> I have already all set there to allow shared access to the repository
> (in opposite to -hg, git works really cool with shared repositories).

I actually haven't hosted any git repos on linuxtv.org before.  I'm
assuming my ssh public key got copied over from when I was hosting hg
repos there?

> We can later add permissions to the developers interested on helping
> the tvtime maintenance that you agree to add.

Sounds good.

As said earlier, Kernel Labs never really wanted to be the maintainer
for tvtime - we did it because nobody else wanted to (and vektor never
responded to emails I sent him offering to help).  That said, a
community oriented approach is probably the best for everybody
involved.

I'll probably be looking in the next couple of weeks to write some
fresh content for a tvtime website.  The stuff on
tvtime.sourceforge.net is so dated almost none of it still applies.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
