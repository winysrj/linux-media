Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:44956 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KTPxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Nov 2013 10:53:09 -0500
Received: by mail-we0-f182.google.com with SMTP id q59so7475556wes.27
        for <linux-media@vger.kernel.org>; Wed, 20 Nov 2013 07:53:07 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 20 Nov 2013 10:53:06 -0500
Message-ID: <CAGoCfixo8PmrDhXM=beGk1auPvCOT71h=U-Nt=F++KOen2293w@mail.gmail.com>
Subject: Dual licensing for v4l2-common.h userland headers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As a result of a code audit the VLC group is doing, they stumbled on
the fact that v4l2-common.h is not dual licensed (it's marked as GPL
only).  This obviously poses a problem especially since v4l2-common.h
is included by videodev2.h (which is the key header people include
when they want to use the V4L2 API from userland).

Would it be possible to get the header changed to reflect dual licensing?

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
