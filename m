Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:36573 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdC0QH0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 12:07:26 -0400
Received: by mail-vk0-f43.google.com with SMTP id s68so57155753vke.3
        for <linux-media@vger.kernel.org>; Mon, 27 Mar 2017 09:07:05 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dougsland@redhat.com
In-Reply-To: <20170327124813.0713fabb@vento.lan>
References: <20170327124813.0713fabb@vento.lan>
From: Douglas Landgraf <dlandgra@redhat.com>
Date: Mon, 27 Mar 2017 12:07:03 -0400
Message-ID: <CAHOoGzOYsPz1WoUTYzVgzTM3CFFqqgYDRSzFne09DG7PgpGuZA@mail.gmail.com>
Subject: Re: [ANN] added Zbar repository at linuxtv.org
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 27, 2017 at 11:48 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Hi,
>
> Just to let you know, I added today a repository at linuxtv.org with a fork
> of the ZBar bar code reader.
>
> The Zbar tool is an interesting V4L2 application, as it reads code bars
> from several different codes from a webcam (or a scanned file).
>
> The original page for this project is at http://zbar.sourceforge.net/
>
> Unfortunately, it doesn't have maintenance there, since 2012. This was
> its last commit upstream:
>
>         changeset:   362:38e78368283d
>         tag:         tip
>         user:        spadix@users.sourceforge.net
>         date:        Sun Oct 14 23:02:08 2012 -0700
>         summary:     Added tag iPhoneSDK-1.3.1 for changeset 5eb3c8786845
>
> At least on Fedora, upstream version doesn't even compile
> without fixing configure.ac to work with modern automake tools.
>
> As Douglas and I are maintaining this package under Fedora, and
> I had to write some other patches on Fedora, in order to migrate it
> to Qt5, I'm opting to keep a fork of its patched version at
> linuxtv.org.
>
> The version there is basically the original development tree,
> converted from Mercurial to git. For the few patches at the
> Fedora packaging repository, I added a commit, in order to
> preserve credits for the authors of the changes there.
>
> Please notice that I don't have currently any plans to do any
> development on it, doing mainly bug fixes as required to keep it
> building and working.
>
> So, if anyone is interested on keeping maintaining it, please
> ping me. Feel free to also send patches for it to linux-media ML.
>
> Thanks,
> Mauro
>
>
> [1] I got the zbar patch credits by running:
>
>         $ git log zbar*.patch
>
> Please notice that this doesn't cover other patches that were there
> at the repository, but got removed.
>
>         Author: Douglas Schilling Landgraf <dougsland@redhat.com>
>         Date:   Mon Aug 17 10:37:15 2015 -0300
>             zbar - zbar-0.10-25
>
>             Added:
>                zbar_configure_ac_use_m4_pattern_allow.patch
>
>             Removed:
>                zbar_dont_user_reserved_dprintf.patch
>
>         Author: Douglas Schilling Landgraf <dougsland@redhat.com>
>         Date:   Sat Jun 6 20:46:10 2015 -0300
>
>     Patch: use REQBUFS properly
>
>         Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>         Date:   Fri Feb 22 08:26:55 2013 -0300
>
>             Update to the very latest version of zbar
>
>             zbar was using a 2010 snapshot of its hg tree.
>             Take a new snapshot to get zbar's improvements.
>
>         Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>         Date:   Sat Dec 25 10:57:22 2010 -0200
>
>             Only use emulated formats if real formats aren't supported
>
>             Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>         Author: Rafael Azenha Aquini <aquini@fedoraproject.org>
>         Date:   Sat Dec 18 14:43:10 2010 -0200
>
>             - Update it to the newest version available at zbar git directory
>             - Use libv4l to communicate with video devices
>

Looks good to me Mauro, nice to see the fork at linuxtv.org.

-- 
Cheers
Douglas
