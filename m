Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35338 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab0JOQgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 12:36:49 -0400
Received: by gxk6 with SMTP id 6so440217gxk.19
        for <linux-media@vger.kernel.org>; Fri, 15 Oct 2010 09:36:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB3611F.1030108@infradead.org>
References: <201009261425.00146.hverkuil@xs4all.nl>
	<AANLkTimWCHHP5MOnXpXpoRyfxRd5jj6=0DHpj7uoVS2E@mail.gmail.com>
	<201010111740.14658.hverkuil@xs4all.nl>
	<AANLkTimA-JKRYAxin6cco2VD9-D7rJ+J_JrSEQhYZTb0@mail.gmail.com>
	<4CB3611F.1030108@infradead.org>
Date: Fri, 15 Oct 2010 12:36:46 -0400
Message-ID: <AANLkTikoO4GF2KgikbJ5Mwb2TKB-7zYTjJgiZpcx1moV@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Move V4L2 locking into the core framework
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans,

I noticed a couple more issues with this series. In your changes to
radio-mr800, you removed the lock from usb_amradio_suspend and
usb_amradio_resume without implementing resume/suspend support in the
v4l2 core. Without resume/suspend support in the v4l2 core, the
locking within usb_amradio_suspend and usb_amradio_resume must remain
to prevent races between other open/close/ioctl/read/mmap/etc and the
resume/suspend cycle. Please revert the changes you made to these two
functions.

Regards,

David Ellingsworth
