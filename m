Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:49025 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751269AbdJ3Igk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 04:36:40 -0400
Subject: Re: [PATCH 0/6] [media] omap_vout: Adjustments for three function
 implementations
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Muralidharan Karicheri <mkaricheri@gmail.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <356f75b2-d303-7f10-b76c-95e2f686bd3c@xs4all.nl>
Date: Mon, 30 Oct 2017 09:36:33 +0100
MIME-Version: 1.0
In-Reply-To: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

On 09/24/2017 12:20 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 24 Sep 2017 12:06:54 +0200
> 
> A few update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (6):
>   Delete an error message for a failed memory allocation in omap_vout_create_video_devices()
>   Improve a size determination in two functions
>   Adjust a null pointer check in two functions
>   Fix a possible null pointer dereference in omap_vout_open()
>   Delete an unnecessary variable initialisation in omap_vout_open()
>   Delete two unnecessary variable initialisations in omap_vout_probe()
> 
>  drivers/media/platform/omap/omap_vout.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 

While we do not mind cleanup patches, the way you post them (one fix per file) is really
annoying and takes us too much time to review.

I'll take the "Fix a possible null pointer" patch since it is an actual bug fix, but
will reject the others, not just this driver but all of them that are currently pending
in our patchwork (https://patchwork.linuxtv.org).

Feel free to repost, but only if you organize the patch as either fixing the same type of
issue for a whole subdirectory (media/usb, media/pci, etc) or fixing all issues for a
single driver.

Actual bug fixes (like the null pointer patch in this series) can still be posted as
separate patches, but cleanups shouldn't.

So in this particular case I would expect two omap_vout patches: one for the bug fix,
one for the cleanups.

Just so you know, I'll reject any future patch series that do not follow these rules.
Just use common sense when posting these things in the future.

I would also suggest that your time might be spent more productively if you would
work on some more useful projects. There is more than enough to do. However, that's
up to you.

Regards,

	Hans
