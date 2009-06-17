Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4218 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZFQHoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 03:44:07 -0400
Message-ID: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>
Date: Wed, 17 Jun 2009 09:43:50 +0200 (CEST)
Subject: Re: Convert cpia driver to v4l2,
      drop parallel port version support?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi,
>
> I recently have been bying second hand usb webcams left and right
> one of them (a creative unknown model) uses the cpia1 chipset, and
> works with the v4l1 driver currently in the kernel.
>
> One of these days I would like to convert it to a v4l2 driver using
> gspca as basis, this however will cause us to use parallel port support
> (that or we need to keep the old code around for the parallel port
> version).
>
> I personally think that loosing support for the parallel port
> version is ok given that the parallel port itslef is rapidly
> disappearing, what do you think ?

I agree wholeheartedly. If we remove pp support, then we can also remove
the bw-qcam and c-qcam drivers since they too use the parallel port.

BTW, I also have a cpia1 camera available for testing. I can also test
ov511 (I saw that you added support for that to gspca). Ditto for the
stv680 and w9968cf.

Note that I can mail these devices to you if you want to work on
integrating them into gspca. I'm pretty sure I won't have time for that
myself.

Regards,

           Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

