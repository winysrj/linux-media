Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38171 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965427Ab2EOUcT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 16:32:19 -0400
Received: by bkcji2 with SMTP id ji2so5195461bkc.19
        for <linux-media@vger.kernel.org>; Tue, 15 May 2012 13:32:18 -0700 (PDT)
Message-ID: <4FB2BD50.6040206@gmail.com>
Date: Tue, 15 May 2012 22:32:16 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR v3.5] Rebased version of the new Timings API
References: <201205151320.19569.hverkuil@xs4all.nl>
In-Reply-To: <201205151320.19569.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/15/2012 01:20 PM, Hans Verkuil wrote:
> Hi Mauro,
>
> Rebased as there were some conflicts after all the recent changes.
>
> Also tested DocBook, works fine for me.
>
> Note that I get this:
>
> Error: no ID for constraint linkend: v4l2-auto-focus-area.
>
> Something missing in those focus control patches.

These are leftovers from V4L2_CID_AUTO_FOCUS_AREA control. I missed to
remove one chunk from Documentation/DocBook/media/v4l/compat.xml while
rebasing the patches. To follow a patch rectifying that issue. Sorry
about that omission.


Regards,
Sylwester
