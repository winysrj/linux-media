Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5SBWImb017357
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 07:32:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5SBW3KN006724
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 07:32:03 -0400
Date: Sat, 28 Jun 2008 08:31:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Greg KH <greg@kroah.com>
Message-ID: <20080628083154.33d3a93d@gaivota>
In-Reply-To: <20080626231551.GA20012@kroah.com>
References: <20080626231551.GA20012@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, linux-usb@vger.kernel.org,
	dean@sensoray.com, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add Sensoray 2255 v4l driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, 26 Jun 2008 16:15:51 -0700
Greg KH <greg@kroah.com> wrote:

> From: Dean Anderson <dean@sensoray.com>
> 
> This driver adds support for the Sensoray 2255 devices.
> 
> It was primarily developed by Dean Anderson with only a little bit of
> guidance and cleanup by Greg.
> 

Hmm... there are still a few minor CodingStyle errors:

ERROR: return is not a function, parentheses are not required
#881: FILE: drivers/media/video/s2255drv.c:792:
+       return (dev->resources[fh->channel]);

WARNING: line over 80 characters
#898: FILE: drivers/media/video/s2255drv.c:809:
+       strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));

ERROR: return is not a function, parentheses are not required
#932: FILE: drivers/media/video/s2255drv.c:843:
+       return (0);

ERROR: return is not a function, parentheses are not required
#1053: FILE: drivers/media/video/s2255drv.c:964:
+               return (ret);

ERROR: return is not a function, parentheses are not required
#1428: FILE: drivers/media/video/s2255drv.c:1339:
+       return (0);

ERROR: return is not a function, parentheses are not required
#1452: FILE: drivers/media/video/s2255drv.c:1363:
+                       return (0);

ERROR: return is not a function, parentheses are not required
#1467: FILE: drivers/media/video/s2255drv.c:1378:
+                       return (0);

ERROR: return is not a function, parentheses are not required
#1487: FILE: drivers/media/video/s2255drv.c:1398:
+                               return (-ERANGE);

total: 7 errors, 1 warnings, 2508 lines checked

I'm applying the patch right now on my tree.

Dean,

When you have some time, please send me a patch fixing those.

heers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
