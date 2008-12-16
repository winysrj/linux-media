Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGBAdem018618
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 06:10:39 -0500
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGBAN5h031446
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 06:10:23 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Lehel Kovach <lehelkovach@hotmail.com>
In-Reply-To: <BAY135-W47952C51F5ED0CAEE9809BFF50@phx.gbl>
References: <BAY135-W47952C51F5ED0CAEE9809BFF50@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 16 Dec 2008 11:06:37 +0100
Message-Id: <1229421997.1745.23.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: quickcam express
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

On Tue, 2008-12-16 at 02:41 -0800, Lehel Kovach wrote:
> does v4l have an issue with quickcam express?  i keep getting this unknown error 515 and dont know if its a v4l issue or an issue of my quickcam driver:
> 
> ### video4linux device info [/dev/video0] ###
> general info
>     VIDIOCGCAP
>     name                    : "Logitech QuickCam USB"
>     type                    : 0x0 []
>     channels                : 1
>     audios                  : 0
>     maxwidth                : 360
>     maxheight               : 296
>     minwidth                : 32
>     minheight               : 32
> 
> libv4l2: error getting capabilities: Unknown error 515
> ioctl: VIDIOC_QUERYCAP(driver="";card="";bus_info="";version=0.0.0;capabilities=0x0 []): Unknown error 515

May you give more information about your webcam?
- vend:prod
- used driver

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
