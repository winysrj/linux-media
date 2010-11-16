Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62624 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab0KPVc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:32:59 -0500
Received: by gxk23 with SMTP id 23so724494gxk.19
        for <linux-media@vger.kernel.org>; Tue, 16 Nov 2010 13:32:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011162210.18000.hverkuil@xs4all.nl>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
	<1289937581.2104.29.camel@morgan.silverblock.net>
	<201011162129.11096.hverkuil@xs4all.nl>
	<201011162210.18000.hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 16:32:57 -0500
Message-ID: <AANLkTikXkEZELQSEa6eQLobK7gpDe=_7+AawuxT3tjd5@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans,

I've had some patches pending for a while now that affect the dsbr100
driver. The patches can be seen here:
http://desource.dyndns.org/~atog/gitweb/?p=linux-media.git in the
dsbr100 branch. The first patch in the series fixes locking issues
throughout the driver and converts it to use the unlocked ioctl. The
series is a bit old, so it doesn't make use of the v4l2 core assisted
locking; but that is trivial to implement after this patch.

Regards,

David Ellingsworth
