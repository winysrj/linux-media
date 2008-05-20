Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4K5JxYw001517
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 01:19:59 -0400
Received: from cnc.isely.net (cnc.isely.net [64.81.146.143])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4K5JlYo019236
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 01:19:48 -0400
Date: Tue, 20 May 2008 00:19:40 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Adrian Bunk <bunk@kernel.org>
In-Reply-To: <20080519215744.GQ17716@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0805200012490.20553@cnc.isely.net>
References: <20080519215744.GQ17716@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Video4Linux list <video4linux-list@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [2.6 patch] drivers/media/: remove CVS keywords
Reply-To: Mike Isely <isely@pobox.com>
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

On Tue, 20 May 2008, Adrian Bunk wrote:

> This patch removes CVS keywords that weren't updated for a long time 
> from comments.
> 
> The pvrusb2 ones were unusual since they weren't expanded at all.

They weren't expanded in the pvrusb2 case because when the driver 
sources move from my standalone / dev area into the v4l-dvb repository, 
I process them with a script which does various manipulations to make 
the sources suitable for the v4l-dvb repository.  Among these 
manipulations include unexpanding any expanded CVS (actually Subversion 
in this case) keywords.  So the keywords actually are used and are 
accurate in the standalone context, but the processed result leaves them 
unexpanded since that would otherwise be a source for constant merge 
thrashing and misleading version info in other environments (e.g. in 
v4l-dvb or the kernel).

I had originally left the $id$ keyword there (unexpanded) thinking it 
might possibly have application in other contexts.  But I will adjust my 
processing script to ensure that the keyword is removed entirely.

  -Mike


> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  Documentation/video4linux/README.cpia2               |    2 --
>  Documentation/video4linux/README.pvrusb2             |    2 --
>  drivers/media/video/dabusb.c                         |    5 -----
>  drivers/media/video/planb.c                          |    2 --
>  drivers/media/video/planb.h                          |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-audio.c          |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-audio.h          |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-context.c        |    1 -
>  drivers/media/video/pvrusb2/pvrusb2-context.h        |    1 -
>  drivers/media/video/pvrusb2/pvrusb2-ctrl.c           |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-ctrl.h           |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c    |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.h    |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-debug.h          |    1 -
>  drivers/media/video/pvrusb2/pvrusb2-debugifc.c       |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-debugifc.h       |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-devattr.c        |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-devattr.h        |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-eeprom.c         |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-eeprom.h         |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-encoder.c        |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-encoder.h        |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h        |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h   |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-hdw.c            |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-hdw.h            |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c   |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h   |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-i2c-core.c       |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-i2c-core.h       |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-io.c             |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-io.h             |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-ioread.c         |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-ioread.h         |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-main.c           |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-std.c            |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-std.h            |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-sysfs.c          |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-sysfs.h          |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-tuner.c          |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-tuner.h          |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-util.h           |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-v4l2.c           |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-v4l2.h           |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-video-v4l.c      |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-video-v4l.h      |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-wm8775.c         |    2 --
>  drivers/media/video/pvrusb2/pvrusb2-wm8775.h         |    2 --
>  drivers/media/video/pvrusb2/pvrusb2.h                |    2 --
>  drivers/media/video/saa5249.c                        |    2 --
>  drivers/media/video/saa7196.h                        |    2 --
>  drivers/media/video/videocodec.c                     |    2 --
>  drivers/media/video/videocodec.h                     |    2 --
>  drivers/media/video/zr36016.c                        |    2 --
>  drivers/media/video/zr36016.h                        |    2 --
>  drivers/media/video/zr36050.c                        |    2 --
>  drivers/media/video/zr36050.h                        |    2 --
>  drivers/media/video/zr36060.c                        |    2 --
>  drivers/media/video/zr36060.h                        |    2 --
>  60 files changed, 120 deletions(-)
> 
> 58b60bf25cb6143266922771f0953a5a5f109c84 diff --git a/Documentation/video4linux/README.cpia2 b/Documentation/video4linux/README.cpia2
> index ce8213d..26159e1 100644
> --- a/Documentation/video4linux/README.cpia2
> +++ b/Documentation/video4linux/README.cpia2
> @@ -1,5 +1,3 @@
> -$Id: README,v 1.7 2005/08/29 23:39:57 sbertin Exp $
> -
>  1. Introduction
>  
>  	This is a driver for STMicroelectronics's CPiA2 (second generation
> diff --git a/Documentation/video4linux/README.pvrusb2 b/Documentation/video4linux/README.pvrusb2
> index a747200..e3d0bbe 100644
> --- a/Documentation/video4linux/README.pvrusb2
> +++ b/Documentation/video4linux/README.pvrusb2
> @@ -1,5 +1,3 @@
> -
> -$Id$
>  Mike Isely <isely@pobox.com>
>  
>  			    pvrusb2 driver
> diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
> index 8d1f8ee..4a44608 100644
> --- a/drivers/media/video/dabusb.c
> +++ b/drivers/media/video/dabusb.c
> @@ -18,11 +18,6 @@
>   *      You should have received a copy of the GNU General Public License
>   *      along with this program; if not, write to the Free Software
>   *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> - *
> - *
> - *
> - *  $Id: dabusb.c,v 1.54 2000/07/24 21:39:39 deti Exp $
> - *
>   */
>  
>  /*****************************************************************************/
> diff --git a/drivers/media/video/planb.c b/drivers/media/video/planb.c
> index 36047d4..5c8fa68 100644
> --- a/drivers/media/video/planb.c
> +++ b/drivers/media/video/planb.c
> @@ -25,8 +25,6 @@
>      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  */
>  
> -/* $Id: planb.c,v 1.18 1999/05/02 17:36:34 mlan Exp $ */
> -
>  #include <linux/init.h>
>  #include <linux/errno.h>
>  #include <linux/module.h>
> diff --git a/drivers/media/video/planb.h b/drivers/media/video/planb.h
> index e21b573..79713a3 100644
> --- a/drivers/media/video/planb.h
> +++ b/drivers/media/video/planb.h
> @@ -26,8 +26,6 @@
>      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  */
>  
> -/* $Id: planb.h,v 1.13 1999/05/03 19:28:56 mlan Exp $ */
> -
>  #ifndef _PLANB_H_
>  #define _PLANB_H_
>  
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-audio.c b/drivers/media/video/pvrusb2/pvrusb2-audio.c
> index 8d859cc..2e93834 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-audio.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-audio.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-audio.h b/drivers/media/video/pvrusb2/pvrusb2-audio.h
> index 536339b..b1ba39f 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-audio.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-audio.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-context.c b/drivers/media/video/pvrusb2/pvrusb2-context.c
> index 73dcb1c..7c19ff7 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-context.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-context.c
> @@ -1,5 +1,4 @@
>  /*
> - *  $Id$
>   *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-context.h b/drivers/media/video/pvrusb2/pvrusb2-context.h
> index 745e270..6180129 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-context.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-context.h
> @@ -1,5 +1,4 @@
>  /*
> - *  $Id$
>   *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
> index 91a42f2..9a8ce4e 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-ctrl.h b/drivers/media/video/pvrusb2/pvrusb2-ctrl.h
> index c168005..c1d7c20 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-ctrl.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-ctrl.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c b/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
> index 29d5059..d5c5318 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.h b/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.h
> index 54b2844..abe885b 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-debug.h b/drivers/media/video/pvrusb2/pvrusb2-debug.h
> index 707d2d9..be79249 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-debug.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-debug.h
> @@ -1,5 +1,4 @@
>  /*
> - *  $Id$
>   *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-debugifc.c b/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
> index b53121c..53737dc 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-debugifc.h b/drivers/media/video/pvrusb2/pvrusb2-debugifc.h
> index 990b02d..f683f11 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-debugifc.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-debugifc.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.c b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
> index 5bf6d8f..a5f358d 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-devattr.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2007 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.h b/drivers/media/video/pvrusb2/pvrusb2-devattr.h
> index d016f8b..47e68e5 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-devattr.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-eeprom.c b/drivers/media/video/pvrusb2/pvrusb2-eeprom.c
> index 5ef0059..c5fb7f4 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-eeprom.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-eeprom.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-eeprom.h b/drivers/media/video/pvrusb2/pvrusb2-eeprom.h
> index 8424297..a6d2ec2 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-eeprom.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-eeprom.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-encoder.c b/drivers/media/video/pvrusb2/pvrusb2-encoder.c
> index c46d367..9c7b990 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-encoder.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-encoder.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-encoder.h b/drivers/media/video/pvrusb2/pvrusb2-encoder.h
> index 54caf2e..8bdb75e 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-encoder.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-encoder.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h b/drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h
> index abaada3..a3a1619 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2007 Michael Krufky <mkrufky@linuxtv.org>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
> index a3fe251..484fac6 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> index 0a86888..0721d75 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.h b/drivers/media/video/pvrusb2/pvrusb2-hdw.h
> index 20295e0..7f7d625 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c
> index 4977376..9f4fcb1 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c
> index c650e02..4bfc388 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h b/drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h
> index c838df6..6b65bd7 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> index 793c89a..0e59ffb 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.h b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.h
> index bd0807b..f935a17 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-io.c b/drivers/media/video/pvrusb2/pvrusb2-io.c
> index 7aff8b7..3b5104b 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-io.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-io.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-io.h b/drivers/media/video/pvrusb2/pvrusb2-io.h
> index 42fcf82..b3c560e 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-io.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-io.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-ioread.c b/drivers/media/video/pvrusb2/pvrusb2-ioread.c
> index c572212..66d6d5f 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-ioread.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-ioread.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-ioread.h b/drivers/media/video/pvrusb2/pvrusb2-ioread.h
> index 1d362f8..09b4b86 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-ioread.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-ioread.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-main.c b/drivers/media/video/pvrusb2/pvrusb2-main.c
> index 332aced..dc98268 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-main.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-main.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c b/drivers/media/video/pvrusb2/pvrusb2-std.c
> index fdc5a2b..d3d9122 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-std.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.h b/drivers/media/video/pvrusb2/pvrusb2-std.h
> index 07c3993..a235e17 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-std.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-std.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
> index 0ff7a83..0af86bb 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.h b/drivers/media/video/pvrusb2/pvrusb2-sysfs.h
> index ff9373b..8de9769 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-tuner.c b/drivers/media/video/pvrusb2/pvrusb2-tuner.c
> index 05e65ce..73a58d8 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-tuner.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-tuner.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-tuner.h b/drivers/media/video/pvrusb2/pvrusb2-tuner.h
> index 556f12a..97bfc4c 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-tuner.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-tuner.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-util.h b/drivers/media/video/pvrusb2/pvrusb2-util.h
> index e53aee4..ee23128 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-util.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-util.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> index e9b5d4e..3ae6a02 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.h b/drivers/media/video/pvrusb2/pvrusb2-v4l2.h
> index 9a995e2..8266f9d 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c b/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c
> index 2433a31..ebe08c5 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-video-v4l.h b/drivers/media/video/pvrusb2/pvrusb2-video-v4l.h
> index 2b917fd..358b474 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-video-v4l.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-video-v4l.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-wm8775.c b/drivers/media/video/pvrusb2/pvrusb2-wm8775.c
> index 66b4d36..0134e00 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-wm8775.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-wm8775.c
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-wm8775.h b/drivers/media/video/pvrusb2/pvrusb2-wm8775.h
> index 8aaeff4..05c4bc1 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-wm8775.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-wm8775.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/pvrusb2/pvrusb2.h b/drivers/media/video/pvrusb2/pvrusb2.h
> index 1a9a4ba..b8a8caf 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2.h
> @@ -1,7 +1,5 @@
>  /*
>   *
> - *  $Id$
> - *
>   *  Copyright (C) 2005 Mike Isely <isely@pobox.com>
>   *  Copyright (C) 2004 Aurelien Alleaume <slts@free.fr>
>   *
> diff --git a/drivers/media/video/saa5249.c b/drivers/media/video/saa5249.c
> index ec8c65d..2205142 100644
> --- a/drivers/media/video/saa5249.c
> +++ b/drivers/media/video/saa5249.c
> @@ -15,8 +15,6 @@
>   *
>   *	Copyright (c) 1998 Richard Guenther <richard.guenther@student.uni-tuebingen.de>
>   *
> - * $Id: saa5249.c,v 1.1 1998/03/30 22:23:23 alan Exp $
> - *
>   *	Derived From
>   *
>   * vtx.c:
> diff --git a/drivers/media/video/saa7196.h b/drivers/media/video/saa7196.h
> index cd4b635..59338ea 100644
> --- a/drivers/media/video/saa7196.h
> +++ b/drivers/media/video/saa7196.h
> @@ -15,8 +15,6 @@
>      The default values used for PlanB are my mistakes.
>  */
>  
> -/* $Id: saa7196.h,v 1.5 1999/03/26 23:28:47 mlan Exp $ */
> -
>  #ifndef _SAA7196_H_
>  #define _SAA7196_H_
>  
> diff --git a/drivers/media/video/videocodec.c b/drivers/media/video/videocodec.c
> index cf24956..9a778e2 100644
> --- a/drivers/media/video/videocodec.c
> +++ b/drivers/media/video/videocodec.c
> @@ -6,8 +6,6 @@
>   *
>   * (c) 2002 Wolfgang Scherr <scherr@net4you.at>
>   *
> - * $Id: videocodec.c,v 1.1.2.8 2003/03/29 07:16:04 rbultje Exp $
> - *
>   * ------------------------------------------------------------------------
>   *
>   * This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/videocodec.h b/drivers/media/video/videocodec.h
> index 97a3bbe..77f72cd 100644
> --- a/drivers/media/video/videocodec.h
> +++ b/drivers/media/video/videocodec.h
> @@ -6,8 +6,6 @@
>   *
>   * (c) 2002 Wolfgang Scherr <scherr@net4you.at>
>   *
> - * $Id: videocodec.h,v 1.1.2.4 2003/01/14 21:15:03 rbultje Exp $
> - *
>   * ------------------------------------------------------------------------
>   *
>   * This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/zr36016.c b/drivers/media/video/zr36016.c
> index 00d132b..4ca27db 100644
> --- a/drivers/media/video/zr36016.c
> +++ b/drivers/media/video/zr36016.c
> @@ -3,8 +3,6 @@
>   *
>   * Copyright (C) 2001 Wolfgang Scherr <scherr@net4you.at>
>   *
> - * $Id: zr36016.c,v 1.1.2.14 2003/08/20 19:46:55 rbultje Exp $
> - *
>   * ------------------------------------------------------------------------
>   *
>   * This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/zr36016.h b/drivers/media/video/zr36016.h
> index 8c79229..03d0684 100644
> --- a/drivers/media/video/zr36016.h
> +++ b/drivers/media/video/zr36016.h
> @@ -3,8 +3,6 @@
>   *
>   * Copyright (C) 2001 Wolfgang Scherr <scherr@net4you.at>
>   *
> - * $Id: zr36016.h,v 1.1.2.3 2003/01/14 21:18:07 rbultje Exp $
> - *
>   * ------------------------------------------------------------------------
>   *
>   * This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/zr36050.c b/drivers/media/video/zr36050.c
> index cf8b271..5b6981e 100644
> --- a/drivers/media/video/zr36050.c
> +++ b/drivers/media/video/zr36050.c
> @@ -3,8 +3,6 @@
>   *
>   * Copyright (C) 2001 Wolfgang Scherr <scherr@net4you.at>
>   *
> - * $Id: zr36050.c,v 1.1.2.11 2003/08/03 14:54:53 rbultje Exp $
> - *
>   * ------------------------------------------------------------------------
>   *
>   * This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/zr36050.h b/drivers/media/video/zr36050.h
> index 9f52f0c..9453640 100644
> --- a/drivers/media/video/zr36050.h
> +++ b/drivers/media/video/zr36050.h
> @@ -3,8 +3,6 @@
>   *
>   * Copyright (C) 2001 Wolfgang Scherr <scherr@net4you.at>
>   *
> - * $Id: zr36050.h,v 1.1.2.2 2003/01/14 21:18:22 rbultje Exp $
> - *
>   * ------------------------------------------------------------------------
>   *
>   * This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/zr36060.c b/drivers/media/video/zr36060.c
> index 8e74054..19fed7d 100644
> --- a/drivers/media/video/zr36060.c
> +++ b/drivers/media/video/zr36060.c
> @@ -3,8 +3,6 @@
>   *
>   * Copyright (C) 2002 Laurent Pinchart <laurent.pinchart@skynet.be>
>   *
> - * $Id: zr36060.c,v 1.1.2.22 2003/05/06 09:35:36 rbultje Exp $
> - *
>   * ------------------------------------------------------------------------
>   *
>   * This program is free software; you can redistribute it and/or modify
> diff --git a/drivers/media/video/zr36060.h b/drivers/media/video/zr36060.h
> index 914ffa4..16be7b4 100644
> --- a/drivers/media/video/zr36060.h
> +++ b/drivers/media/video/zr36060.h
> @@ -3,8 +3,6 @@
>   *
>   * Copyright (C) 2002 Laurent Pinchart <laurent.pinchart@skynet.be>
>   *
> - * $Id: zr36060.h,v 1.1.1.1.2.3 2003/01/14 21:18:47 rbultje Exp $
> - *
>   * ------------------------------------------------------------------------
>   *
>   * This program is free software; you can redistribute it and/or modify
> 
> 

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
