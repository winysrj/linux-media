Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34504 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbL1Od2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 09:33:28 -0500
Received: by mail-io0-f174.google.com with SMTP id e126so305954899ioa.1
        for <linux-media@vger.kernel.org>; Mon, 28 Dec 2015 06:33:27 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Dec 2015 16:33:27 +0200
Message-ID: <CAM_ZknVmAnoa=+BA9Q+BSJ_dKwtBWWXHqZyJ_BH=FppqGLpFUg@mail.gmail.com>
Subject: On Lindent shortcomings and massive style fixing
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	Linux Media <linux-media@vger.kernel.org>,
	devel@driverdev.osuosl.org
Cc: andrey.od.utkin@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After some iterations of checkpatch.pl, on a new developed driver
(tw5864), now I have the following:

 $ grep 'WARNING\|ERROR' /src/checkpatch.tw5864 | sort | uniq -c
     31 ERROR: do not use C99 // comments
    147 WARNING: Block comments use a trailing */ on a separate line
    144 WARNING: Block comments use * on subsequent lines
    435 WARNING: line over 80 characters

At this point, Lindent was already used, and checkpatch.pl warnings
introduced by Lindent itself were fixed. Usage of "indent
--linux-style" (which behaves differently BTW) doesn't help anymore,
too.

Could anybody please advise how to sort out these issues
automatically, because they look like perfectly solvable in automated
fashion. Of course manual work would result in more niceness, but I am
not eager to go through hundreds of place of code just to fix "over 80
characters" issues now.

First one ("do not use C99 // comments") looks easy with regexps, but
the other are not.

Is there any known improvements or successors for Lindent? Or could we
get indent/Lindent improved if we collect some money for this task?

If anybody wants to look at actual code, here it is:
https://github.com/bluecherrydvr/linux.git , branch tw5864_stable,
drivers/staging/media/tw5864

Current output of "checkpatch.pl -f" for all source files in the
driver is here:
https://gist.github.com/andrey-utkin/12295148475e34ef948b

Thanks in advance.
