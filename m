Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38056 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1IYMeA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 08:34:00 -0400
Received: by yxl31 with SMTP id 31so3659307yxl.19
        for <linux-media@vger.kernel.org>; Sun, 25 Sep 2011 05:33:59 -0700 (PDT)
Message-ID: <4E7F1FB5.5030803@gmail.com>
Date: Sun, 25 Sep 2011 07:33:57 -0500
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Problems cloning the git repostories
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello there,

I tried to follow the steps for cloning both the "media_tree.git" and
"media_build.git" repositories, and received errors for both.  The
media_tree repository failed on the first line

> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb 

which I'm assuming is because kernel.org is down.

The media_build.git repository fails on the first line also

> git clone git://linuxtv.org/media_build.git 

with a fatal: read error: Connection reset by peer.

Is it possible to clone either (or both) repositories at this time, or
are they down?  And in the absence of cloning the kernel for the
media_tree.git repository, is it possible to simply clone the
git://linuxtv.org/media_tree.git repository and work from that?

My interest in this is to install some patches created by Devin
Heitmueller for the Pinnacle PCTV 80e USB tuner (at least the ATSC
portion of the tuner). Once I'm able to determine exactly what changes
are made, I would like to either submit the patches to the repository,
or send them to someone who has more experience in patching the files
for submission.

One other question (totally unrelated to this post though): When I send
emails, normally they are GPG signed. Should I disable that for this
list, or is it acceptable?

Thank you for any information, and have a great day:)
Patrick.

