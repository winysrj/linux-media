Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5UG5GZe001427
	for <video4linux-list@redhat.com>; Tue, 30 Jun 2009 12:05:16 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n5UG53g0012601
	for <video4linux-list@redhat.com>; Tue, 30 Jun 2009 12:05:03 -0400
Received: by rv-out-0506.google.com with SMTP id b25so86943rvf.51
	for <video4linux-list@redhat.com>; Tue, 30 Jun 2009 09:05:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b24e53350906290842g788a4cau8e8f19bcf318188a@mail.gmail.com>
References: <b24e53350906290842g788a4cau8e8f19bcf318188a@mail.gmail.com>
Date: Tue, 30 Jun 2009 12:05:03 -0400
Message-ID: <b24e53350906300905k3d3d2141geb247736402dba10@mail.gmail.com>
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: V4L <video4linux-list@redhat.com>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: v4l2-ctl problem attempting to turn of auto exposure control on
	Creative Optia AF
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

On Mon, Jun 29, 2009 at 11:42 AM, Robert
Krakora<rob.krakora@messagenetsystems.com> wrote:
> All:
>
> I am using the tip V4L code with a Captiva Optia AF webcam and I am
> trying to turn off auto exposure via v4l2-ctl.  However, v4l2-ctl is
> indicating an I/O error (see below).  I notice that the control is
> listed as 'menu' and not 'int' or 'bool' as the other controls.  What
> am I doing wrong?
>
> [root@vizioconfrm104 ivtv-utils-1.3.0]# v4l2-ctl --list-ctrls
>                     brightness (int)  : min=-64 max=64 step=1 default=0 value=0
>                       contrast (int)  : min=0 max=64 step=1 default=32 value=32
>                     saturation (int)  : min=0 max=128 step=1
> default=64 value=64
>                            hue (int)  : min=-40 max=40 step=1 default=0 value=0
>  white_balance_temperature_auto (bool) : default=1 value=1
>                          gamma (int)  : min=72 max=500 step=1
> default=110 value=110
>                           gain (int)  : min=0 max=100 step=1 default=0 value=0
>           power_line_frequency (menu) : min=0 max=2 default=2 value=2
>      white_balance_temperature (int)  : min=2800 max=6500 step=1
> default=6500 value=6500
>                      sharpness (int)  : min=0 max=6 step=1 default=3 value=3
>         backlight_compensation (int)  : min=0 max=2 step=1 default=1 value=1
>                  exposure_auto (menu) : min=0 max=3 default=3 value=3
>              exposure_absolute (int)  : min=1 max=5000 step=1
> default=300 value=300
>         exposure_auto_priority (bool) : default=0 value=0
>                 focus_absolute (int)  : min=1 max=20 step=1 default=1 value=1
>                     focus_auto (bool) : default=1 value=1
>                  zoom_absolute (int)  : min=0 max=3 step=1 default=0 value=0
> [root@vizioconfrm104 ivtv-utils-1.3.0]# v4l2-ctl --verbose
> --set-ctrl=exposure_auto=0
> VIDIOC_QUERYCAP: ok
> VIDIOC_S_CTRL: failed: Input/output error
> exposure_auto: Input/output error
> [root@vizioconfrm104 ivtv-utils-1.3.0]#
>
> Best Regards,
>
> --
> Rob Krakora
> Senior Software Engineer
> MessageNet Systems
> 101 East Carmel Dr. Suite 105
> Carmel, IN 46032
> (317)566-1677 Ext. 206
> (317)663-0808 Fax
>

Hello All,

Please disregard the previous e-mail that I sent.  I was able to set
the 'exposure_auto' control to '1' (manual) successfully.  I was
mistakenly trying to set it to '0' (automatic) which seems to be
prohibited.

Best Regards,

-- 
Rob Krakora
Senior Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
