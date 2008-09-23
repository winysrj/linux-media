Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8N8jwRm004494
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 04:45:58 -0400
Received: from LGEMRELSE7Q.lge.com (LGEMRELSE7Q.lge.com [156.147.1.151])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8N8jfE2018171
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 04:45:42 -0400
From: "Madhusudhan P" <madhusudhan.p@lge.com>
To: <video4linux-list@redhat.com>
Date: Tue, 23 Sep 2008 14:15:37 +0530
MIME-Version: 1.0
In-Reply-To: <5a459d5e0809230125h3e876de2k51128e5a3724cd35@mail.gmail.com>
Message-Id: <20080923084538.69A27558013@LGEMRELSE7Q.lge.com>
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 'Prasanna R' <prasannabr@lge.com>
Subject: RE: [directfb-users] V4L2 driver support in DirectFB
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

Hi All,

 

I blocked in the same issue. I am planning to use basic V4L2 driver API's to
develop the GUI on DM6467 like putpixel, drawline, drawrectangle etc.,
however quality and performance will not good. This will be my last option.
Is there any GUI toolkit which support V4L2 driver?  

 

 

Regards

Madhu

 

  _____  

From: directfb-users-bounces@directfb.org
[mailto:directfb-users-bounces@directfb.org] On Behalf Of Harinandan S
Sent: Tuesday, September 23, 2008 1:56 PM
To: directfb-users@directfb.org
Subject: Re: [directfb-users] V4L2 driver support in DirectFB

 


Hi All,

 

I'm also looking for ways to get GUI on DM6467. Is there any possibility?
I've used DirectFB on DM6446 on OSD window but 6467 doesnt have an OSD
window so is there a way I can get both video and GUI on video window?

On Mon, Sep 8, 2008 at 6:37 PM, Jadav, Brijesh R <brijesh.j@ti.com> wrote:

Hi,

 

There is a file available for V4L2. It is idirectfbvideoprovider_v4l.c in
the directory interfaces/IDirectFBVideoProvider. 

 

Thanks,

Brijesh Jadav

  _____  

From: Madhusudhan P [mailto:madhusudhan.p@lge.com] 
Sent: Monday, September 08, 2008 1:39 PM 


To: Jadav, Brijesh R
Cc: directfb-users@directfb.org
Subject: RE: [directfb-users] V4L2 driver support in DirectFB

 

Hello,

 

I looked into the code and saw only reference to a V4L2 driver where actual
implementation of V4L2 driver is not there in DirectFB source code. :-(

 

Do you have any idea or approach to implement OSD features using V4L2
devices in dm6467 board?

 

Regards

Madhu

  

 

  _____  

From: Jadav, Brijesh R [mailto:brijesh.j@ti.com] 
Sent: Monday, September 08, 2008 1:22 PM
To: Madhusudhan P
Cc: directfb-users@directfb.org
Subject: RE: [directfb-users] V4L2 driver support in DirectFB

 

Hi,

 

This is true. But from the source code, it looks like this V4L2 option is
used for the capture not for the display. I am not able to find anything for
the V4L2 display. All the files contain reference to V4L2 Capture.

 

Thanks,

Brijesh Jadav

  _____  

From: Madhusudhan P [mailto:madhusudhan.p@lge.com] 
Sent: Monday, September 08, 2008 10:36 AM
To: Jadav, Brijesh R
Cc: directfb-users@directfb.org
Subject: RE: [directfb-users] V4L2 driver support in DirectFB

 

Hello Brijesh,

 

Thanks for the response.

 

When we look into DirectFB website they clearly specify that it support V4L2
driver. 

While running ./configure, we have got an option --enable-video4linux2.

 

I am really confused with it now.

 

Thanks and Regards

Madhu

 

 

  _____  

From: Jadav, Brijesh R [mailto:brijesh.j@ti.com] 
Sent: Monday, September 08, 2008 10:26 AM
To: Madhusudhan P
Cc: directfb-users@directfb.org
Subject: RE: [directfb-users] V4L2 driver support in DirectFB

 

Hi,

 

As far as I know, Support for directfb is not available on dm6467. Actually
directfb works on frame buffer driver, which is not available on dm6467.
dm6467 provides only V4L2 driver.

 

Thanks,

Brijesh Jadav

  _____  

From: directfb-users-bounces@directfb.org
[mailto:directfb-users-bounces@directfb.org] On Behalf Of Madhusudhan P
Sent: Monday, September 08, 2008 10:15 AM
To: directfb-users@directfb.org
Subject: [directfb-users] V4L2 driver support in DirectFB

 

Hello,

 

 

 

I am developing GUI on OSD DM6467 board. I am facing some issues regarding
the DirectFB using V4L2 driver. I ported the DirectFB on DM6467 Davinci
board and try to execute some test examples, where test program fails to
recognize the video device.

 

 

 

Does DirectFB have full support of V4L2 driver?

 

Is it possible to access V4L2 driver to display UI menu using DirectFB?

 

 

 

How to proceed with this? If anyone working on this, please help me.

 

 

 

Thanks and Regards

 

Madhu

 


_______________________________________________
directfb-users mailing list
directfb-users@directfb.org
http://mail.directfb.org/cgi-bin/mailman/listinfo/directfb-users




-- 
Regards,
Harinandan S

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
