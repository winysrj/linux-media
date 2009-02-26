Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1QNQ3kH011150
	for <video4linux-list@redhat.com>; Thu, 26 Feb 2009 18:26:03 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1QNPjQ9024859
	for <video4linux-list@redhat.com>; Thu, 26 Feb 2009 18:25:45 -0500
Received: by yx-out-2324.google.com with SMTP id 8so541790yxm.81
	for <video4linux-list@redhat.com>; Thu, 26 Feb 2009 15:25:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b24e53350902261307x7ea7e172na47dc479ac9d25cf@mail.gmail.com>
References: <b24e53350902261307x7ea7e172na47dc479ac9d25cf@mail.gmail.com>
Date: Thu, 26 Feb 2009 18:25:45 -0500
Message-ID: <b24e53350902261525j5e7cd63dkdba6163f6ca56cae@mail.gmail.com>
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: V4L <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jerry Geis <geisj@messagenetsystems.com>,
	Kevin Brown <kbrown@messagenetsystems.com>
Subject: Re: v4l2: ioctl queue buffer failed: No space left on device
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

On Thu, Feb 26, 2009 at 4:07 PM, Robert Krakora
<rob.krakora@messagenetsystems.com> wrote:
> All:
>
> I have vlc running a v4l2 supported web cam (runs great for both audio
> and video).  However, when I start up my em28xx based device in analog
> mode via mplayer I see this message:
>
> v4l2: ioctl queue buffer failed: No space left on device
>
> I have to take down vlc to start up my em28xx based device in analog
> mode via mplayer.  I assume there is probably no kmalloc memory
> available, but I am not for sure as I have not looked at the source
> yet.
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

All:

It appears as though Markus identified this problem three years ago as
possibly a bug in the USB stack (see below).  The other device that
shares the USB bus with the KWorld 330U em28xx device is a VF0560
Live! Cam Optia AF webcam.  Any suggestions or comments are welcome.
;-)

http://lkml.org/lkml/2006/2/3/5

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
