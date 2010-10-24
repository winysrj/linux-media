Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41970 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0JXUO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 16:14:58 -0400
Received: by eye27 with SMTP id 27so3530219eye.19
        for <linux-media@vger.kernel.org>; Sun, 24 Oct 2010 13:14:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010242150.55591.laurent.pinchart@ideasonboard.com>
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
	<4CC229BC.90000@redhat.com>
	<AANLkTin_puofnGcxyLbcLCqE8TbX0CUbtHRd-o+CBQt2@mail.gmail.com>
	<201010242150.55591.laurent.pinchart@ideasonboard.com>
Date: Sun, 24 Oct 2010 16:14:56 -0400
Message-ID: <AANLkTimgLwYh5k9RJN_nsqMptWeBw95zOisOUzKkJHvt@mail.gmail.com>
Subject: Re: [PATCH 7/8] v4l: Add EBUSY error description for VIDIOC_STREAMON
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Oct 24, 2010 at 3:50 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> I think the patch makes sense. As you mention many drivers already implement
> this behaviour, so this mostly clarifies the API. Calling VIDIOC_STREAMON on
> an already streaming file handle isn't something applications should do in the
> first place anyway.

I don't disagree with this behavior in principle, but Pawel should
really try this out with some of the common applications to ensure it
doesn't cause breakage (e.g. tvtime, xawtv, mythtv).

Despite the fact that some drivers already do this, that doesn't mean
that those drivers are necessarily the ones commonly used with these
applications.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
