Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SEHBS7025146
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 10:17:11 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SEGxmL003759
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 10:16:59 -0400
Received: by wr-out-0506.google.com with SMTP id c57so177856wra.9
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 07:16:58 -0700 (PDT)
Message-ID: <d9def9db0803280716j1971fb49ge58e825a8ab6229a@mail.gmail.com>
Date: Fri, 28 Mar 2008 15:16:57 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: Mat <heavensdoor78@gmail.com>
In-Reply-To: <47ECFBFC.4070708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47ECFBFC.4070708@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Empia em28xx based USB video device...
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

On 3/28/08, Mat <heavensdoor78@gmail.com> wrote:
>
> Hi all.
> I have an em2821 device ( brand Digitus ) and some problems with it.
> + lsusb:
> Bus 001 Device 004: ID eb1a:2821 eMPIA Technology, Inc.
>
> I have 2 situations:
> + machine1: standard PC - kernel 2.6.24.3 - CPU AMD - 512 Mb RAM - last
> snapshot of v4l-dvb ( 2 days ago )
> if I load the module ( em28xx ) with card=0 ( Unknown EM2800 video
> grabber ) it doesn't work ( tested with xawtv )
> if I load the module ( em28xx ) with card=1 ( Unknown EM2750/28xx
> video grabber ) it doesn't work ( tested with xawtv )
> if I load the module ( em28xx ) with card=9 ( Pinnacle Dazzle DVC
> 90/DVC 100 ) it works ok...
> + machine2: SBC - kernel 2.6.24.3 - CPU x86 ( like a 586 ) - 64 Mb RAM -
> last snapshot of v4l-dvb ( 2 days ago )
> if I load the module ( em28xx ) with card=0 ( Unknown EM2800 video
> grabber ) it doesn't work ( tested with xawtv )
> if I load the module ( em28xx ) with card=1 ( Unknown EM2750/28xx
> video grabber ) it doesn't work ( tested with xawtv )
> if I load the module ( em28xx ) with card=9 ( Pinnacle Dazzle DVC
> 90/DVC 100 ) it works badly... I get something like an image compressed
> in the firt rows... ( image here:
> http://www.flickr.com/photos/17101105@N00/2368937536/ )
>
> Same module parameters, same kernel config (changed only the CPU), same
> distro (Debian Etch).
> Any ideas...?
>
> dmesg for these machines ( card=9 ):
> + machine1:
> [ 198.848725] Linux video capture interface: v2.00
> [ 198.872627] em28xx v4l2 driver version 0.1.0 loaded
> [ 198.872680] em28xx new video device (eb1a:2821): interface 0, class 255
> [ 198.872690] em28xx Has usb audio class
> [ 198.872693] em28xx #0: Alternate settings: 8
> [ 198.872696] em28xx #0: Alternate setting 0, max size= 0
> [ 198.872699] em28xx #0: Alternate setting 1, max size= 1024
> [ 198.872702] em28xx #0: Alternate setting 2, max size= 1448
> [ 198.872705] em28xx #0: Alternate setting 3, max size= 2048
> [ 198.872708] em28xx #0: Alternate setting 4, max size= 2304
> [ 198.872711] em28xx #0: Alternate setting 5, max size= 2580
> [ 198.872714] em28xx #0: Alternate setting 6, max size= 2892
> [ 198.872717] em28xx #0: Alternate setting 7, max size= 3072
> [ 198.873529] em28xx #0: em28xx chip ID = 18
> [ 199.894188] saa7115' 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a
> (em28xx #0)
> [ 202.023636] em28xx #0: V4L2 device registered as /dev/video0 and
> /dev/vbi0
> [ 202.023647] em28xx #0: Found Pinnacle Dazzle DVC 90/DVC 100
> [ 202.023678] em28xx audio device (eb1a:2821): interface 1, class 1
> [ 202.023696] em28xx audio device (eb1a:2821): interface 2, class 1
> [ 202.023723] usbcore: registered new interface driver em28xx

This one is connected to usb 2.0, so in that case it seems like a
misconfigured videodecoder.

> + machine2:
> [ 4097.440853] Linux video capture interface: v2.00
> [ 4097.523858] em28xx v4l2 driver version 0.1.0 loaded
> [ 4097.527087] em28xx new video device (eb1a:2821): interface 0, class 255
> [ 4097.529568] em28xx Has usb audio class
> [ 4097.532138] em28xx #0: Alternate settings: 8
> [ 4097.535497] em28xx #0: Alternate setting 0, max size= 0
> [ 4097.537769] em28xx #0: Alternate setting 1, max size= 512
> [ 4097.540333] em28xx #0: Alternate setting 2, max size= 640
> [ 4097.542892] em28xx #0: Alternate setting 3, max size= 768
> [ 4097.550248] em28xx #0: Alternate setting 4, max size= 832
> [ 4097.552683] em28xx #0: Alternate setting 5, max size= 896
> [ 4097.554952] em28xx #0: Alternate setting 6, max size= 960
> [ 4097.558217] em28xx #0: Alternate setting 7, max size= 1020
> [ 4097.563767] em28xx #0: em28xx chip ID = 18

this one is connected to a usb 1.1 port .. the driver doesn't work
with usb 1.1 (at least not yet).

Is there any productlink available?

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
