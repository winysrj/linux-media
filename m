Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9L8xrHO011045
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 04:59:53 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9L8xeZR007771
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 04:59:41 -0400
Message-ID: <48FD9ABA.70804@hhs.nl>
Date: Tue, 21 Oct 2008 11:02:50 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: ian@pickworth.me.uk
References: <48FD07FA.9090402@pickworth.me.uk>
In-Reply-To: <48FD07FA.9090402@pickworth.me.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: gspca V2 vs V1: webcam picture very dark
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

Ian Pickworth wrote:
> Running my Logitec cheapo webcam on gspca V2, the result is not as good
> as when I previously used gspca V1 freestanding (20071224).
> 
> Specifically, under V2:
> 	The picture is very, very dark - can hardly make it out.
> 	The webcam light switches off after first use, and stays off.
> 
> The second may or may not be a problem, but I'm assuming that the light
> is signaling something useful, thus its state seems important.
> 
> To test the webcam, I'm using spcaview.
> 
> Using the freestanding (V1) gspca module on kernel 2.6.26, I see output
> below (gspca V1 run). The webcam light switches on when the gspca module
> loads, stays on throughout, and after the application finishes as well.
> The brightness is normal, ie I can see myself clearly.
> 
> Using the new gspca_main/gspca_spca561 modules on kernel 2.6.27 I see
> output below (gspca_main/gspca_spca561 run). The webcam light switches
> on when the modules are loaded, stays on until spcaview exits, at which
> point it switches off. It then stays off until the modules are reloaded.
> The brightness is very low indeed - I can hardly make myself out.

Hi Ian,

Thanks for including so much details in you report, this certainly makes things 
much easier for us!

> ----
> VIDIOCGPICT
> brightnes=16384 hue=0 color=0 contrast=8192 whiteness=0
> depth=12 palette=15
> 
> vs
> 
> VIDIOCGPICT
> brightnes=0 hue=0 color=0 contrast=0 whiteness=0
> depth=8 palette=15
> --------------------------------
> 
> brightness and contrast seem to be way off for the new modules.
> 

This is normal, you have a revison 12a spca561 (I can tell from your usb-id), 
this does not have brightness nor contrast controls, hence they show as 0. It 
does have exposure and gain controls which used to be mapped to contrast and 
brightness in gspcav1 as there was no way to express these controls in v4l1, 
the new gspcav2 exports these as exposure and gain, iow as what they are.

However since you're using a v4l1 application, you cannot control these now. 
You can use a separate v4l2 controlpanel application (google for, download, and 
install v4l2ucp) to control these settings. You can run this in parallel to 
spcaview. You will want to crank up exposure, I really need to add software 
autoexposure to libv4l for these cams to adjust this automatically to lighting 
conditions.

<snip>

Notice gspcav1:

> Used 19966ms for 244 images => 81ms/image 12fps.

Note an exposure time of 81 ms / frame.


> ----------------------------
> gspca_main/gspca_spca561 run
> ----------------------------
<snip>

> Used 2131ms for 63 images => 33ms/image 29fps.

Note an exposure time of 33 ms / frame, so thats 2.5 times as short an 
exposure, and thus 2.5 times as dark a picture.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
