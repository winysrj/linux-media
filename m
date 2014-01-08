Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4726 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaAHLNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 06:13:53 -0500
Message-ID: <52CD32E2.5030805@xs4all.nl>
Date: Wed, 08 Jan 2014 12:13:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
References: <20140108033307.C683A2A009A@tschai.lan>
In-Reply-To: <20140108033307.C683A2A009A@tschai.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The daily build fails when building v4l-utils:

apps: ERRORS
../../lib/include/descriptors/vct.h:28:37: fatal error: descriptors/atsc_header.h: No such file or directory
make[3]: *** [libdvbv5_la-dvb-file.lo] Error 1
make[2]: *** [all-recursive] Error 1
make[1]: *** [all-recursive] Error 1
make: *** [all] Error 2

Apparently you forgot to push a header...

Regards,

	Hans
