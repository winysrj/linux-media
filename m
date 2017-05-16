Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40998 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751523AbdEPQNL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 12:13:11 -0400
Subject: Re: v4l2_subdev_queryctrl and friends
To: Patrick Doyle <wpdster@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CAF_dkJBOf16Xz=wx6KT4FLqU_X+Ok+0ZbsV=JfRGs_tN+YKHeQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2075aeff-6ef9-8fa8-696e-f932d68a03ea@xs4all.nl>
Date: Tue, 16 May 2017 18:13:09 +0200
MIME-Version: 1.0
In-Reply-To: <CAF_dkJBOf16Xz=wx6KT4FLqU_X+Ok+0ZbsV=JfRGs_tN+YKHeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/05/17 16:31, Patrick Doyle wrote:
> There is a statement in the v4l2-controls.txt in my 4.4.55 kernel that
> v4l2_subdev_queryctrl and friends will be removed "Once all the V4L2
> drivers that depend on subdev drivers are converted to the control
> framework".
> 
> How would I be able to tell if my driver (isc-atmel.c) has been
> converted to the control framework?  I would have expected that to be
> the case, given that I have backported the driver (from linux-media in
> the last week or two), but I am not seeing controls that I create in
> my subdev.

Yes, atmel-isc.c has been converted. If a driver has a v4l2_ctrl_handler
struct, then it's OK.

However, it seems it never inherits the controls from the subdev.

It needs something like this (taken from rcar-vin.c):

        ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
        if (ret < 0)
                return ret;

to do this.

Regards,

	Hans

> As long as I am backporting the driver, I may as well do it right.
> Unless there is some reason why the control framework is known to be
> broken in 4.4.
> 
> Any thoughts?
> 
> --wpd
> 
