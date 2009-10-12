Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:53663 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252AbZJLViC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 17:38:02 -0400
Received: by bwz6 with SMTP id 6so3456941bwz.37
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 14:37:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20091012T223603-551@post.gmane.org>
References: <loom.20091011T180513-771@post.gmane.org>
	 <829197380910111218q5739eb5ex9a87f19899a13e98@mail.gmail.com>
	 <loom.20091012T223603-551@post.gmane.org>
Date: Mon, 12 Oct 2009 17:37:23 -0400
Message-ID: <829197380910121437m4f1fb7cld8d7dc351f468671@mail.gmail.com>
Subject: Re: Dazzle TV Hybrid USB and em28xx
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Giuseppe Borzi <gborzi@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 4:49 PM, Giuseppe Borzi <gborzi@gmail.com> wrote:
> Thanks for your prompt reply. I've downloaded v4l-dvb-5578cc977a13.tar.bz2, but
> it fails to compile when it reaches firedtv-1394.c. The first part of the error
> message is
>
> /home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:21:17: error: dma.h: No
> such file or directory
> /home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:22:21: error: csr1212.h:
> No such file or directory
> /home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:23:23: error: highlevel.h:
> No such file or directory
> /home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:24:19: error: hosts.h: No
> such file or directory
> /home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:25:22: error: ieee1394.h:
> No such file or directory
> /home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:26:17: error: iso.h: No
> such file or directory
> /home/gborzi/v4l-dvb-5578cc977a13/v4l/firedtv-1394.c:27:21: error: nodemgr.h:
> No such file or directory

Yeah, that happens with Ubuntu Karmic.  The v4l-dvb firedtv driver
depends on headers that are private to ieee1394 and not in their
kernel headers package.

To workaround the issue, open v4l/.config and set the firedtv driver
from "=m" to "=n"

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
