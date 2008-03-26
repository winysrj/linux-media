Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QHqAbO025584
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 13:52:10 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2QHpr6t021824
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 13:51:53 -0400
Date: Wed, 26 Mar 2008 18:51:28 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Matthew Wang <wangsu820@163.com>
Message-ID: <20080326175127.GA226@daniel.bse>
References: <20080326103853.GA21053@stinkie>
	<3358587.1081301206517482981.JavaMail.coremail@bj163app87.163.com>
	<1373980.1212051206531393465.JavaMail.coremail@bj163app55.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373980.1212051206531393465.JavaMail.coremail@bj163app55.163.com>
Cc: video4linux-list@redhat.com
Subject: Re: ask about kernel video4linux module
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

On Wed, Mar 26, 2008 at 07:36:33PM +0800, Matthew Wang wrote:
>  thank u, Daniel
>  
> I have the kernel package which is 2.6.8.1 and I use Source Insight to read it.
>  
> Actually, I will do a IP Camera project based on ADSP-BF533(an ADI Blackfin chip), and I want to programme v4l by myself, and of course I have to learn something about v4l programming!
>  
> in the kernel package, which directory is the v4l core in? kernel/drivers/media? for example, some article only tell us how to use the VIDIOCGCAP ioctl ,but now I wannt to see the VIDIOCGCAP specific code, can I find it in the kernel package?
>  
> thanks again!
>  
> Matthew

There is no V4L core.
The file you are searching is kernel/drivers/media/video/blackfin/blackfin_cam.c
from the Blackfin Linux project.
It is not yet part of the mainline source tree.
It supports only the obsolete V4L1 API.

You can browse the sourcecode at
http://blackfin.uclinux.org/gf/project/linux-kernel/scmsvn/?action=browse&path=%2Ftrunk%2Fdrivers%2Fmedia%2Fvideo%2Fblackfin%2F

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
