Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35140 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbbDIRng (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 13:43:36 -0400
Received: by wgyo15 with SMTP id o15so117193126wgy.2
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2015 10:43:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1513746.9Yk7IklJT9@avalon>
References: <1426193947-12850-1-git-send-email-drake@endlessm.com>
	<1513746.9Yk7IklJT9@avalon>
Date: Thu, 9 Apr 2015 11:43:35 -0600
Message-ID: <CAD8Lp44GUdBiqGA_3=AdGcvCx1WTUzg2CLp0mSLA0udL8tfGPQ@mail.gmail.com>
Subject: Re: [PATCH] uvcvideo: Add quirk for Quanta NL3 laptop camera
From: Daniel Drake <drake@endlessm.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-uvc-devel@lists.sourceforge.net, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sat, Apr 4, 2015 at 3:44 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> I'm not sure that adding a device-specific quirk is the bast way to handle
> this problem, as it wouldn't really scale if other devices expose buggy
> descriptors. A more generic way to patch or override descriptors might be
> better, with a single quirk and a pointer to a patch function. This would
> require refactoring the quirks system to store a structure pointer instead of
> a bitfield in the driver_info field.

I agree, but I don't currently have time to work on a more advanced approach.

I think that's OK for everyone, as I can work with this patch for the
time being, and if nobody else has broken descriptors, there's no
particular rush.

Thanks,
Daniel
