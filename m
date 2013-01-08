Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:43091 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3AHGfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 01:35:48 -0500
Received: by mail-we0-f177.google.com with SMTP id x48so40575wey.8
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 22:35:47 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Jan 2013 12:05:47 +0530
Message-ID: <CAGzWAsgZGu8_JTrE1GvnpbR+W92fvRycfFhAX2NbZ9VZqorJ6w@mail.gmail.com>
Subject: global mutex in dvb_usercopy (dvbdev.c)
From: Soby Mathew <soby.linuxtv@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Everyone,
    I have a doubt regarding about the global mutex lock in
dvb_usercopy(drivers/media/dvb-core/dvbdev.c, line 382) .


/* call driver */
mutex_lock(&dvbdev_mutex);
if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
err = -EINVAL;
mutex_unlock(&dvbdev_mutex);


Why is this mutex needed? When I check similar functions like
video_usercopy, this kind of global locking is not present when func()
is called.

This global lock will prevent any other ioctl call from being executed
unless the previous blocking ioctl call has returned. If we need to
have a lock why not make it file handle specific ?


Thanks for your help.

Best Regards
Soby Mathew

Best Regards
