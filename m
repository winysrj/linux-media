Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55954 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2HQMGN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 08:06:13 -0400
Received: by weyx8 with SMTP id x8so2377400wey.19
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 05:06:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345204225.1800.73.camel@dcky-ubuntu64>
References: <1345204225.1800.73.camel@dcky-ubuntu64>
Date: Fri, 17 Aug 2012 09:06:12 -0300
Message-ID: <CA+MoWDrG4HTgc6UyTgU42UcQPq8s3AQhQehRS6rHS-NqvU6-+g@mail.gmail.com>
Subject: Re: Preferred setup for development?
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: pdickeybeta@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Patrick,

There are some information at: http://git.linuxtv.org/media_tree.git


On Fri, Aug 17, 2012 at 8:50 AM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
> I'm looking for information about what distributions people are using,
> and how they go about testing their code.  The reason is, I'm running
> Ubuntu for my main distribution, and it seems like I'll have to go
> through a lot of hoops in order to compile and test changes to the
> kernel.  I realize that I could probably just use the media_build tree,
> and add the changes there.  But, I'd prefer to go the same route that
> the majority of the developers here do.
>
> So, my questions are these:
>
> 1.  Do you use a specific distribution for development, or a roll your
> own (like Linux from Scratch)?
> 2.  If you use a distribution, which one?
I like and use Fedora.

> 3.  Do you do your development on physical computers or on virtual
> machines (or both)?
Most on physical. I use VM for some testing.

> 4.  Do you have a machine that's dedicated to development, or is it one
> that you use for other things?
My notebook for everything.

> 5.  Do you use a newer computer, or older computer for development? (or
> both)
>
> For anyone using the media_build tree (instead of the media_git tree):
>
> Are you able to seamlessly implement changes that are in the media_git
> tree files to the media_build tree, or do you have to make changes in
> order to get them to compile?
>
> Are your files able to be implemented into the media_git tree
> seamlessly, or do you have to make changes to get them to compile?
>
> If you're able to use the media_build tree, and the changes you make can
> be implemented in the media_git tree without hassle, I may go that route
> instead.
>
> I downloaded a Slackware DVD, as it appears to be one that you can "roll
> your own kernel" without too much of a hassle. But, I want to get
> people's opinions before I start.
The key points for Fedora / Ubuntu / ... are:
- how to generate the initrd for allowing you to book your custom Kernel
- what Kernel options are needed for your distro to work

I like to follow distro specific instructions for generate Kernel
packages. This works for me for Fedora. I follow:
http://fedoraproject.org/wiki/Docs/CustomKernel

>
> Thanks to everyone who responds, and have a great day:)
> Patrick.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

[]'s

-- 
Peter Senna Tschudin
peter.senna@gmail.com
gpg id: 48274C36
