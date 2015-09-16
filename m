Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:62890 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbbIPIkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 04:40:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 6/7] [RFC] [media]: v4l2: introduce v4l2_timeval
Date: Wed, 16 Sep 2015 10:40:26 +0200
Message-ID: <3059739.5oJNmvzYWC@wuerfel>
In-Reply-To: <55F92450.8010802@xs4all.nl>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de> <7758607.pJFdek7ljg@wuerfel> <55F92450.8010802@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 16 September 2015 10:12:00 Hans Verkuil wrote:
> 
> Are you also attending the ELCE in Dublin? We could have a quick talk there.
> I think the discussion whether to switch to a new v4l2_buffer struct isn't really
> dependent on anything y2038.

No, unfortunately I won't be there.

Concerning a v4l2_buffer, I agree we should treat that as a completely independent
topic. The problem at hand for y2038 is only about we expect to happen when someone
compiles source code that uses the existing v4l2_buffer (and v4l2_event) with a
y2038-aware libc.

	Arnd
