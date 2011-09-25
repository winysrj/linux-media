Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58198 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab1IYOxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 10:53:33 -0400
Received: by gwb15 with SMTP id 15so4743886gwb.19
        for <linux-media@vger.kernel.org>; Sun, 25 Sep 2011 07:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7F1FB5.5030803@gmail.com>
References: <4E7F1FB5.5030803@gmail.com>
Date: Sun, 25 Sep 2011 17:53:30 +0300
Message-ID: <CAJL_dMtcYegWvh3fKn7SH6F_7th7aRNTUu+y9N0hkwFdspYvqg@mail.gmail.com>
Subject: Re: Problems cloning the git repostories
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Patrick Dickey <pdickeybeta@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 25, 2011 at 3:33 PM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
> Hello there,
>
> I tried to follow the steps for cloning both the "media_tree.git" and
> "media_build.git" repositories, and received errors for both.  The
> media_tree repository failed on the first line
>
>> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb
>
> which I'm assuming is because kernel.org is down.
>
> The media_build.git repository fails on the first line also
>
>> git clone git://linuxtv.org/media_build.git
>
> with a fatal: read error: Connection reset by peer.
>

The linux tree is at: https://github.com/torvalds/linux
git clone git://github.com/torvalds/linux.git

The Mauro's media tree is at: http://git.linuxtv.org/mchehab/media-next.git
