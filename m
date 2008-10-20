Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KNtw77013543
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 19:55:58 -0400
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9KNtkLm032565
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 19:55:46 -0400
Date: Mon, 20 Oct 2008 16:55:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean-Francois Moine <moinejf@free.fr>, Mauro Carvalho Chehab
	<mchehab@infradead.org>
Message-Id: <20081020165537.9bb9ae8a.akpm@linux-foundation.org>
In-Reply-To: <bug-11776-10286@http.bugzilla.kernel.org/>
References: <bug-11776-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, bugme-daemon@bugzilla.kernel.org,
	linuxkernel@lanrules.de
Subject: Re: [Bugme-new] [Bug 11776] New: Regression: Hardware working with
 old stock gspca module fails with 2.6.27 module
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


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

gspca doesn't seem to have a MAINTAINERS record.  Or it is entered
under something unobvious so my search failed?


On Fri, 17 Oct 2008 17:48:54 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11776
> 
>            Summary: Regression: Hardware working with old stock gspca module
>                     fails with 2.6.27 module
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.27
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: linuxkernel@lanrules.de
> 
> 
> Latest working kernel version: 2.6.26.5
> Earliest failing kernel version: 2.6.27
> Distribution: ArchLinux
> Hardware Environment: i686 Lenovo T16P laptop, Lenovo USB 2.0 Webcam (40Y8519)
> Problem Description:
> I used gspca-1.0 from mxhaard.free.fr as a driver for my webcam. The driver
> worked. gspca is now included in the mainline kernel. The driver doesn't work
> anymore. The camera is detected, but the image is not shown. Instead, colorful
> noise is shown.
> 
> This is the information about the webcam given by the old gspca module, still
> working with 2.6.26:
> Camera found: lenovo MI1310_SOC
> Bridge found: VC0323
> StreamId: JPEG Camera
> quality 7 autoexpo 1 Timeframe 0 lightfreq 50
> Available Resolutions width 640  heigth 480 native
> Available Resolutions width 352  heigth 288 native
> Available Resolutions width 320  heigth 240 native *
> Available Resolutions width 176  heigth 144 native
> Available Resolutions width 160  heigth 120 native
> unable to probe size !! 
> 
> I don't see any significant difference in the output of the module included in
> 2.6.27. Tell me how I can provide more useful information.
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
