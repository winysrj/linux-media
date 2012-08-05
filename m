Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36203 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2HESol (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2012 14:44:41 -0400
Received: by obbuo13 with SMTP id uo13so4603710obb.19
        for <linux-media@vger.kernel.org>; Sun, 05 Aug 2012 11:44:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344190590-10863-1-git-send-email-mchehab@redhat.com>
References: <1344190590-10863-1-git-send-email-mchehab@redhat.com>
Date: Sun, 5 Aug 2012 14:44:40 -0400
Message-ID: <CAGoCfizhL6=WhV9-9RMx9PX8ctV2Ao+GyMzPL8T67g4y5nBWAw@mail.gmail.com>
Subject: Re: [PATCH 0/2] get rid of fe_ioctl_override()
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 5, 2012 at 2:16 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> There's just one driver using fe_ioctl_override(), and it can be
> replaced at tuner_attach call. This callback is evil, as only DVBv3
> calls are handled.
>
> Removing it is also a nice cleanup, as about 90 lines of code are
> removed.
>
> Get rid of it!

Did you consult with anyone about this?  Did you talk to the
maintainer for the driver that uses this functionality (he's not on
the CC: for this patch series).  Did you actually do any testing to
validate that it didn't break anything?

This might indeed be a piece of functionality that can possibly be
removed, assuming you can answer yes to all three of the questions
above.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
