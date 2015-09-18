Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:65415 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbbIRKOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 06:14:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 8/9] [media] handle 64-bit time_t in v4l2_buffer
Date: Fri, 18 Sep 2015 12:14:41 +0200
Message-ID: <1904442.5N0pINVFVn@wuerfel>
In-Reply-To: <55FBDE3E.4070608@xs4all.nl>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de> <2032750.MT8vj0PRkR@wuerfel> <55FBDE3E.4070608@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 18 September 2015 11:49:50 Hans Verkuil wrote:
> *If* the conversion takes place only in v4l2-ioctl.c, then it makes sense
> have these structs + ioctls moved to v4l2-ioctl.h.

Ok.
 
> I noticed that v4l2-compat-ioctl32.c wasn't changed. Is that right? I have
> unfortunately no time to double-check that, but it surprised me.

Yes, I pointed that out in the cover letter as something that is still
left to be done. If we end up taking the current approach (plus the
change to the location of the conversion), the compat code would
basically be duplicated.

Alternatively, the video_usercopy() function could just be changed
to handle both 32-bit formats directly (including conversion of the
multiplane array) and then we can remove that compat handler for
all eight ioctls.

	Arnd
