Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5SMC1tw005160
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 18:12:01 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5SMBlwD017016
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 18:11:48 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080628083154.33d3a93d@gaivota>
References: <20080626231551.GA20012@kroah.com>
	<20080628083154.33d3a93d@gaivota>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 00:08:34 +0200
Message-Id: <1214690914.7722.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Greg KH <greg@kroah.com>,
	linux-usb@vger.kernel.org, dean@sensoray.com,
	linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] add Sensoray 2255 v4l driver
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


Am Samstag, den 28.06.2008, 08:31 -0300 schrieb Mauro Carvalho Chehab:
> On Thu, 26 Jun 2008 16:15:51 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > From: Dean Anderson <dean@sensoray.com>
> > 
> > This driver adds support for the Sensoray 2255 devices.
> > 
> > It was primarily developed by Dean Anderson with only a little bit of
> > guidance and cleanup by Greg.
> > 
> 
> Hmm... there are still a few minor CodingStyle errors:
> 
> ERROR: return is not a function, parentheses are not required
> #881: FILE: drivers/media/video/s2255drv.c:792:
> +       return (dev->resources[fh->channel]);
> 
> WARNING: line over 80 characters
> #898: FILE: drivers/media/video/s2255drv.c:809:
> +       strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));
> 
> ERROR: return is not a function, parentheses are not required
> #932: FILE: drivers/media/video/s2255drv.c:843:
> +       return (0);
> 
> ERROR: return is not a function, parentheses are not required
> #1053: FILE: drivers/media/video/s2255drv.c:964:
> +               return (ret);
> 
> ERROR: return is not a function, parentheses are not required
> #1428: FILE: drivers/media/video/s2255drv.c:1339:
> +       return (0);
> 
> ERROR: return is not a function, parentheses are not required
> #1452: FILE: drivers/media/video/s2255drv.c:1363:
> +                       return (0);
> 
> ERROR: return is not a function, parentheses are not required
> #1467: FILE: drivers/media/video/s2255drv.c:1378:
> +                       return (0);
> 
> ERROR: return is not a function, parentheses are not required
> #1487: FILE: drivers/media/video/s2255drv.c:1398:
> +                               return (-ERANGE);
> 
> total: 7 errors, 1 warnings, 2508 lines checked
> 
> I'm applying the patch right now on my tree.
> 
> Dean,
> 
> When you have some time, please send me a patch fixing those.
> 
> heers,
> Mauro
> 

On an attempt to get recent drivers on a FC8 x86_64 machine to watch
Glastonbury music festival on BBC HD DVB-S with the saa714 driver on an
recently updated 2.6.25 FC kernel it also fails to compile on some
strlcpy attempt. Same with a 2.6.24 on the mail machine here.

  CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/quickcam_messenger.o
  CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.o
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c: In function 'vidioc_querycap':
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: error: implicit declaration of function 'dev_name'
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: warning: passing argument 2 of 'strlcpy' makes pointer from integer without a cast
make[3]: *** [/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.o] Error 1
make[2]: *** [_module_/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.24.7-92.fc8-i686'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l'
make: *** [all] Fehler 2

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
