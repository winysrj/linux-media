Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8Q2NEw4014738
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 22:23:14 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8Q2N2AG017552
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 22:23:02 -0400
Received: by rv-out-0506.google.com with SMTP id f6so721117rvb.51
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 19:23:01 -0700 (PDT)
Message-ID: <7b6d682a0809251923uaacc119u25cf5118625c03d0@mail.gmail.com>
Date: Thu, 25 Sep 2008 23:23:01 -0300
From: "Eduardo Fontes" <eduardo.fontes@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <d9def9db0809251837k126b6b83n2803e56a00a7f961@mail.gmail.com>
MIME-Version: 1.0
References: <7b6d682a0809251804j1277af44i80c53529a3c33d62@mail.gmail.com>
	<d9def9db0809251837k126b6b83n2803e56a00a7f961@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
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

Hi Markus,

Ok. The .deb package that you send to me + tvtime ".deb" package (
http://mcentral.de/tvtime/tvtime_1.0.2-1_i386.deb) my Pinnacle PCTV works
with sound, but only in b/w NTSC. Brazil is PAL-M color standard and when I
put in this TV Standard I get only noises and a disfigured green image. In
NTSC the image is clear but only in grey scale and sound is fine. Some patch
for this?

Thanks again.

-----
Eduardo M. Fontes
A simple brazilian linux user.

On Thu, Sep 25, 2008 at 10:37 PM, Markus Rechberger
<mrechberger@gmail.com>wrote:

> Hi Eduardo,
>
> On Fri, Sep 26, 2008 at 3:04 AM, Eduardo Fontes
> <eduardo.fontes@gmail.com> wrote:
> > Hello fellows,
> >
> > I use Ubuntu Hardy (8.04), kernel 2.6.24-19, and I try to install a
> Pinnacle
> > PCTV HD Pro Stick USB2.0 device without success.
> > I download the v4l newer source drivers from Mercurial and compile it.
> When
> > module is loaded, it detects the USB device (em28xx #0: Found Pinnacle
> PCTV
> > HD Pro Stick), but sound (em28xx Doesn't have usb audio class).
> > I download too the firmware (
> > http://konstantin.filtschew.de/v4l-firmware/firmware_v4.tgz) and put it
> on
> > /lib/firmware.
> > In V4L Wiki page, inform that EM2880 chips don't have de USB Audio Class,
> > only a USB Vendor Class for digital audio, and here is the big question:
> > where I find the em28xx-alsa module for the kernel version that I have
> and
> > compatible with firmware and v4l drivers!?
> >
>
> You might try to install one of the following packages:
> i386:
> http://mcentral.de/empia/20080926/empia-2.6.24-19-generic-7_i386.deb
> amd64<http://mcentral.de/empia/20080926/empia-2.6.24-19-generic-7_i386.debamd64>
> :
> http://mcentral.de/empia/20080926/empia-2.6.24-19-generic-8_amd64.deb
>
> those packages contain all the necessary firmwares and the driver for
> em28xx based devices.
> As for userspace applications you will need tvtime from mcentral.de in
> order to automatically
> get some audio playback, there's also a debian package available but
> for i386 only.
>
> Markus
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
