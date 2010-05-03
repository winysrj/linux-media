Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47634 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab0ECPpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 11:45:09 -0400
Received: by vws19 with SMTP id 19so1806808vws.19
        for <linux-media@vger.kernel.org>; Mon, 03 May 2010 08:45:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005022216.14727.hverkuil@xs4all.nl>
References: <y2wa3ef07921005011221h4b71c791p7c906ab150875144@mail.gmail.com>
	 <201005022157.08106@orion.escape-edv.de>
	 <201005022216.14727.hverkuil@xs4all.nl>
Date: Mon, 3 May 2010 08:45:06 -0700
Message-ID: <h2ia3ef07921005030845m2c1af449s8c2005635b408e3a@mail.gmail.com>
Subject: Re: av7110 crash when unloading.
From: VDR User <user.vdr@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Oliver Endriss <o.endriss@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 2, 2010 at 1:16 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> The patch to fix this is in the git fixes tree for quite some time, but since
> it hasn't been upstreamed yet it is still not in the v4l-dvb git or hg trees.
> I've asked Mauro when he is going to do that, I can't do much more.
>
> For the time being you can apply the diff from fixes.git:
>
> http://git.linuxtv.org/fixes.git?a=commitdiff_plain;h=40358c8b5380604ac2507be2fac0c9bbd3e02b73
>
> Save to e.g. fix.diff, go to the linux directory in your v4l-dvb tree and apply it.

Hi Hans.  Thank you very much for the pointer to the patch.  I've now
applied it and the problem is resolved (as expected).  I also
forwarded the patch to several other users I know also with a nexus-s.

Thanks again,
Derek
