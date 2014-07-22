Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:59194 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaGVQcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 12:32:22 -0400
Received: by mail-oa0-f48.google.com with SMTP id m1so9991711oag.35
        for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 09:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5099401.EbLZaQU31t@avalon>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<CA+2YH7urbO6C-a6UMB+1JKN2z7F0CDmqh0184cCzXHbW1ADfXA@mail.gmail.com>
	<CA+2YH7t0rzko=Ssg7Qe8oC_qXUTr=uFzDqBqmPtAAbQ2dAntNA@mail.gmail.com>
	<5099401.EbLZaQU31t@avalon>
Date: Tue, 22 Jul 2014 18:26:52 +0200
Message-ID: <CA+2YH7vNd4kC3=82M=UhHmNcXFGxBaiLUVbSkoXRvT8tfZkfcA@mail.gmail.com>
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
From: Enrico <ebutera@users.sourceforge.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>,
	stefan@herbrechtsmeier.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 22, 2014 at 6:04 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Enrico,
>
> You will need to upgrade media-ctl and yavta to versions that support
> interlaced formats. media-ctl has been moved to v4l-utils
> (http://git.linuxtv.org/cgit.cgi/v4l-utils.git/) and yavta is hosted at
> git://git.ideasonboard.org/yavta.git. You want to use the master branch for
> both trees.

It seems that in v4l-utils there is no field support in media-ctl, am i wrong?

I forgot to add that i'm using yavta master and media-ctl "field"
branch (from ideasonboard).

Enrico
