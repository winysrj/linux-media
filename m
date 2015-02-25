Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:37992 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbbBYR4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 12:56:32 -0500
Received: by mail-qa0-f54.google.com with SMTP id x12so3868648qac.13
        for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 09:56:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54EDD761.6060900@osg.samsung.com>
References: <1424798958-2819-1-git-send-email-dheitmueller@kernellabs.com>
	<54EDD761.6060900@osg.samsung.com>
Date: Wed, 25 Feb 2015 12:56:31 -0500
Message-ID: <CAGoCfiyN_iQ6vGn0YGUD_OxngwKEMs056Gzp4yW9wWjSa8Lisw@mail.gmail.com>
Subject: Re: [PATCH] xc5000: fix memory corruption when unplugging device
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: "mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I would request you to add a comment here indicating the
> hybrid case scenario to avoid any future cleanup type work
> deciding there is no need to set priv->firmware to null
> since priv gets released in hybrid_tuner_release_state(priv);

No, I'm not going to rebase my tree and regenerate the patch just to
add a comment explaining how hybrid_tuner_[request/release]_state()
works (which, btw, is how it works in all hybrid tuner drivers).  I
already wasted enough of my time tracking down the source of the
memory corruption and providing a fix for this regression.  If you
want to submit a subsequent patch with a comment, be my guest.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
