Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f172.google.com ([209.85.208.172]:34946 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbeHMIys (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 04:54:48 -0400
Received: by mail-lj1-f172.google.com with SMTP id p10-v6so11658153ljg.2
        for <linux-media@vger.kernel.org>; Sun, 12 Aug 2018 23:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <4f89ae25-4ae6-3530-a8f9-171dd39dceb0@cisco.com>
 <85fdad02-5b68-1e62-cc59-d4dd6a33759b@oracle.com> <af4b80cc-1966-b346-a9fd-66db45b0c102@xs4all.nl>
 <cc3bbc46-fca1-a969-a276-3a8d0f7f4745@oracle.com>
In-Reply-To: <cc3bbc46-fca1-a969-a276-3a8d0f7f4745@oracle.com>
From: Daniel Stone <daniel@fooishbar.org>
Date: Mon, 13 Aug 2018 07:13:50 +0100
Message-ID: <CAPj87rPu5uaXZj-Rtj11H_gfpxxn284mr_mt=StiK6GqyjK-4g@mail.gmail.com>
Subject: Re: [ANN] edid-decode maintenance info
To: Alan Coopersmith <alan.coopersmith@oracle.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, hansverk@cisco.com,
        xorg-devel <xorg-devel@lists.x.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, 12 Aug 2018 at 21:53, Alan Coopersmith
<alan.coopersmith@oracle.com> wrote:
> On 06/22/18 01:12 AM, Hans Verkuil wrote:
> > Thank you for this information. I looked through all the bug reports and
> > 100607, 100340 and 93366 were already fixed before I took over maintenance.
> >
> > I just fixed 89348 and 93777 in my git repo, so those can be marked as
> > resolved.
>
> Since no one else has, I marked all of these resolved now with links to your
> repo for the fixes.
>
> > The edid-decode component should probably be removed from the freedesktop
> > bugzilla.
>
> I don't know how to do that without deleting the bugs, so I'm hoping Adam
> or Daniel can do that, much as they've been doing for the stuff migrating
> to gitlab.

edid-decode is already marked as inactive; the old bugs aren't deleted
and it's possible to search by component, but you can't file new bugs
against it.

Cheers,
Daniel
