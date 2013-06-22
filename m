Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56018 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423471Ab3FVDqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 23:46:51 -0400
Received: by mail-wi0-f173.google.com with SMTP id hq4so1172965wib.0
        for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 20:46:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306212208.43086.hverkuil@xs4all.nl>
References: <201306212208.43086.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 22 Jun 2013 09:16:30 +0530
Message-ID: <CA+V-a8tVWW8J8rd1tUWc7Nv0+QRkfkk=2CQWFaj02AhdBn-QEQ@mail.gmail.com>
Subject: Re: [GIT PULL FOR v3.11] Conversions to v4l-async
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Jun 22, 2013 at 1:38 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Now that the v4l-async patches have been merged, these patches can be merged
> as well.
>
>         Hans
>
> The following changes since commit ee17608d6aa04a86e253a9130d6c6d00892f132b:
>
>   [media] imx074: support asynchronous probing (2013-06-21 16:36:15 -0300)
>
> are available in the git repository at:
>
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.11
>
> for you to fetch changes up to a6277614fa957a3c26a3160e2fc662838d185c70:
>
>   media: i2c: ths8200: add support v4l-async (2013-06-21 22:00:47 +0200)
>
> ----------------------------------------------------------------
> Lad, Prabhakar (3):
>       media: i2c: tvp7002: add support for asynchronous probing
>       media: i2c: tvp7002: add OF support
>       media: i2c: ths8200: add support v4l-async
>
These patches needs to be reworked on.These patches were based on
earlier version
of v4l-async, the v4l-async got changed in last version due to which
there is a little
bit of rework which I'll work on them today and repost.

Mauro, please don’t pull these patches.

Regards,
--Prabhakar Lad
