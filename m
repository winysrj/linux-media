Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34130 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0CHAQf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 19:16:35 -0500
Received: by vws9 with SMTP id 9so2516961vws.19
        for <linux-media@vger.kernel.org>; Sun, 07 Mar 2010 16:16:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1003071557020.23682@banach.math.auburn.edu>
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>
	 <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu>
	 <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com>
	 <4B91AADD.4030300@xenotime.net> <4B91CE02.4090200@redhat.com>
	 <a3ef07921003070955q7d7ce7e8j747c07d56a0ad98e@mail.gmail.com>
	 <alpine.LNX.2.00.1003071557020.23682@banach.math.auburn.edu>
Date: Sun, 7 Mar 2010 16:16:34 -0800
Message-ID: <a3ef07921003071616l742095c1mfdc19b2cea88f22@mail.gmail.com>
Subject: Re: "Invalid module format"
From: VDR User <user.vdr@gmail.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 7, 2010 at 2:03 PM, Theodore Kilgore
<kilgota@banach.math.auburn.edu> wrote:
> It seems that the problem is solved by a local re-compile of the kernel plus
> its modules, using the original distro .config settings in order to do this.
> What I suspect has happened is that there was a simultaneous minor upgrade
> of gcc at the same time, and it is possible that this interfered. I would
> further speculate that a similar problem happened with you, in your Debian
> installation.
>
> Hoping that we have finally tracked this down.

It's a good theory.  However, when I did my "update", I had compiled
the kernel, installed it, rebooted into it and then proceeded to grab
a fresh v4l tree and go from there.  There wern't any package updates
or anything else involved between the kernel compile and v4l compile.
(except for the reboot into 2.6.33 of course.)
