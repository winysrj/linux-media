Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAHKsYaT017761
	for <video4linux-list@redhat.com>; Mon, 17 Nov 2008 15:54:34 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAHKsO4I000838
	for <video4linux-list@redhat.com>; Mon, 17 Nov 2008 15:54:25 -0500
Received: by ey-out-2122.google.com with SMTP id 4so942665eyf.39
	for <video4linux-list@redhat.com>; Mon, 17 Nov 2008 12:54:24 -0800 (PST)
Message-ID: <412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
Date: Mon, 17 Nov 2008 15:54:24 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
In-Reply-To: <alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [video4linux] Attention em28xx users
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

On Mon, Nov 17, 2008 at 3:45 PM, Kiss Gabor (Bitman)
<kissg@ssg.ki.iif.hu> wrote:
> Dear Devin,
>
> I have the same device as it was mentioned in
> https://www.redhat.com/mailman/private/video4linux-list/2008-July/msg00383.html
> http://www.spinics.net/lists/vfl/msg37855.html
>
> With unpatched 2.6.27.6 kernel:
>
> [   76.909729] Linux video capture interface: v2.00
> [   76.918166] em28xx v4l2 driver version 0.1.0 loaded
> [   76.918203] em28xx new video device (eb1a:2821): interface 0, class 255
> [   76.918210] em28xx Has usb audio class
> [   76.918212] em28xx #0: Alternate settings: 8
> [   76.918215] em28xx #0: Alternate setting 0, max size= 0
> ...
> [   76.918234] em28xx #0: Alternate setting 7, max size= 3072
> [   76.919015] em28xx #0: em28xx chip ID = 18
> [   77.158764] em28xx #0: found i2c device @ 0x4a [saa7113h]
> [   77.161884] em28xx #0: found i2c device @ 0x60 [remote IR sensor]
> [   77.167637] em28xx #0: found i2c device @ 0x86 [tda9887]
> [   77.176886] em28xx #0: found i2c device @ 0xc6 [tuner (analog)]
> [   77.185386] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
> [   77.185392] em28xx #0: You may try to use card=<n> insmod option to workaround that.
> [   77.185396] em28xx #0: Please send an email with this log to:
> [   77.185398] em28xx #0:       V4L Mailing List <video4linux-list@redhat.com>
> [   77.185400] em28xx #0: Board eeprom hash is 0x00000000
> [   77.185404] em28xx #0: Board i2c devicelist hash is 0x8cad00a0
> [   77.185406] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
> [   77.185410] em28xx #0:     card=0 -> Unknown EM2800 video grabber
> [   77.185412] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
> ...
> [   77.185555] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
> [   77.185557] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
> [   77.742766] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> [   77.742773] em28xx #0: Found Unknown EM2750/28xx video grabber
> [   77.742796] em28xx audio device (eb1a:2821): interface 1, class 1
> [   77.742808] em28xx audio device (eb1a:2821): interface 2, class 1
> [   77.742836] usbcore: registered new interface driver em28xx
>
>
> I wonder what to with it?
> No TV software found a receiver to tune.
> Have you ever tested this device?
>
> Can you give me any hint? What to test?

Hello Gabor,

The action item for the thread you referenced was for the user to
capture a USB trace on a Windows system so we can compare the register
operations.  If you want to pick up where the original user left off,
please use SniffUSB to get a capture after plugging in the device and
starting a capture session.

http://www.pcausa.com/Utilities/UsbSnoop/default.htm

If you can provide a USB capture, I can fix the code so this device
starts working.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
