Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63172 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab2CTQHW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 12:07:22 -0400
Received: by obbeh20 with SMTP id eh20so88494obb.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 09:07:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120320153717.GB4458@kroah.com>
References: <1332257451.6182.60.camel@VPir>
	<20120320153717.GB4458@kroah.com>
Date: Tue, 20 Mar 2012 13:00:02 -0300
Message-ID: <CALF0-+XSkO4=2=O-M6Nk4hXsdQ-HKtUPcSBATKQpDjDJ=i-wBQ@mail.gmail.com>
Subject: Re: [PATCH] go7007 patch for 3.2.x
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: volokh <volokh@telros.ru>
Cc: linux-media@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Volokh,

>
> You would need to make this at least against the 3.3 kernel, preferably
> against the linux-next branch.

You can follow the instructions here to work off the for_v3.4 branch:

http://git.linuxtv.org/media_tree.git

>
> Also, you didn't read the Documentation/SubmittingPatches file, please
> follow it properly, otherwise there is nothing we can do with your patch :(

I think you will find this useful:

http://www.youtube.com/watch?v=LLBrBBImJt4

It shows how you can submit patches using nothing but git.
It's *much* easier than using diff yourself.
It also shows the usage of checkpatch and get_maintainers script.

Also, please read other patches sent to the list, so you can see
how commit messages should look like.
A little googling won't hurt:

http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
http://spheredev.org/wiki/Git_for_the_lazy#Writing_good_commit_messages

Don't get discourage if your patches aren't accepted right away:
it looks hard at first, but it's only until you get used to.

Hope it helps,
Ezequiel.
