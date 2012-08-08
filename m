Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57391 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab2HHMD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 08:03:59 -0400
Received: by yhmm54 with SMTP id m54so638465yhm.19
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2012 05:03:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344352315-1184-1-git-send-email-kradlow@cisco.com>
References: <1344352315-1184-1-git-send-email-kradlow@cisco.com>
Date: Wed, 8 Aug 2012 12:03:58 +0000
Message-ID: <CAFomkUBdFMJsrKLR1vbeg82dgQbPktcOKhKUy2qo9eGeeLsPAA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Add support for RDS decoding (updated)
From: Konke Radlow <koradlow@googlemail.com>
To: Konke Radlow <kradlow@cisco.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	hdegoede@redhat.com, koradlow@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

just for the record, these patches are:

Signed-off-by: Konke Radlow <kradlow@cisco.com>

Regards,
Konke

On Tue, Aug 7, 2012 at 3:11 PM, Konke Radlow <kradlow@cisco.com> wrote:
> Hello,
> first of all: thank you for the comments to my previous RFC for the
> libv4l2rds library and the rds-ctl control & testing tool.
> The proposed changes have been implemented, and the code has been
> further improved after a thorough code review by Hans Verkuil.
>
> Changes:
>   -the code is rebased on the latest v4l-utils code (as of today 07.08)
>   -added feature: time/date decoding
>   -implementing proposed changes
>   -code cleanup
>   -extended comments
>
> Status:
> From my point of view the RDS decoding is now almost feature complete.
> There are some obscure RDS features like paging that are not supported,
> but they do not seem to used anywhere.
> So in the near future no features will be added and the goal is to get
> the library and control tool merged into the v4l-utils codebase.
>
> Upcoming:
> Work on RDS-TMC decoding is going well and is being done in a seperate
> branch. It will be the subject of a future RFC, once it has reached a
> mature stage. But TMC is not a core feature of RDS but an addition.
>
> Regards,
> Konke
>
