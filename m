Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8Q21AFK009746
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 22:01:33 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8Q1bxD4026253
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 21:38:47 -0400
Received: by fg-out-1718.google.com with SMTP id e21so504423fga.7
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 18:37:59 -0700 (PDT)
Message-ID: <d9def9db0809251837k126b6b83n2803e56a00a7f961@mail.gmail.com>
Date: Fri, 26 Sep 2008 03:37:58 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Eduardo Fontes" <eduardo.fontes@gmail.com>
In-Reply-To: <7b6d682a0809251804j1277af44i80c53529a3c33d62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b6d682a0809251804j1277af44i80c53529a3c33d62@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle PCTV HD Pro Stick
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

Hi Eduardo,

On Fri, Sep 26, 2008 at 3:04 AM, Eduardo Fontes
<eduardo.fontes@gmail.com> wrote:
> Hello fellows,
>
> I use Ubuntu Hardy (8.04), kernel 2.6.24-19, and I try to install a Pinnacle
> PCTV HD Pro Stick USB2.0 device without success.
> I download the v4l newer source drivers from Mercurial and compile it. When
> module is loaded, it detects the USB device (em28xx #0: Found Pinnacle PCTV
> HD Pro Stick), but sound (em28xx Doesn't have usb audio class).
> I download too the firmware (
> http://konstantin.filtschew.de/v4l-firmware/firmware_v4.tgz) and put it on
> /lib/firmware.
> In V4L Wiki page, inform that EM2880 chips don't have de USB Audio Class,
> only a USB Vendor Class for digital audio, and here is the big question:
> where I find the em28xx-alsa module for the kernel version that I have and
> compatible with firmware and v4l drivers!?
>

You might try to install one of the following packages:
i386:
http://mcentral.de/empia/20080926/empia-2.6.24-19-generic-7_i386.deb
amd64:
http://mcentral.de/empia/20080926/empia-2.6.24-19-generic-8_amd64.deb

those packages contain all the necessary firmwares and the driver for
em28xx based devices.
As for userspace applications you will need tvtime from mcentral.de in
order to automatically
get some audio playback, there's also a debian package available but
for i386 only.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
