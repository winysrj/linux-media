Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbZHKFZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 01:25:41 -0400
Date: Mon, 10 Aug 2009 22:25:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-media@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, strakh@ispras.ru
Subject: Re: [Bugme-new] [Bug 13951] New: in function device_authorization
 mutex is not released on error path.
Message-Id: <20090810222517.aff70402.akpm@linux-foundation.org>
In-Reply-To: <bug-13951-10286@http.bugzilla.kernel.org/>
References: <bug-13951-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Mon, 10 Aug 2009 08:16:08 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13951
> 
>            Summary: in function device_authorization mutex is not released
>                     on  error  path.
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.30
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Video(Other)
>         AssignedTo: drivers_video-other@kernel-bugs.osdl.org
>         ReportedBy: strakh@ispras.ru
>         Regression: No
> 
> 
> In ./drivers/media/video/hdpvr/hdpvr-core.c in function 
> device authorization: 
>                 If after mutex lock (line 4) usb control msg returns ret!=46 we go to 
> label 
> error. In this case before exit from function mutex must be         unlocked.
> 
> 01) static int device authorization(struct hdpvr device *dev)
> 02) {
> 03) ............
> 04)             mutex lock(&dev->usbc mutex);                                                      
> 05)            ret = usb control msg(dev->udev,
> 06)                                              usb rcvctrlpipe(dev->udev, 0),
> 07)                                             rcv request, 0x80 | request type,
> 08)                                             0x0400, 0x0003,
> 09)                                             dev->usbc buf, 46,10000);
> 10)                      if (ret != 46) {
> 11)                     v4l2 err(&dev->v4l2 dev,
> 12)                                     "unexpected answer of status request, len %d\n", 
> ret);
> 13)                        goto error;
> 14)            }
> 15) .................
> 16) error:
> 17)
> 18)            return retval;
> 19) }
> 

Alexander, it would make life simpler if you were to just email patches
which fix things like this!

Thanks.

