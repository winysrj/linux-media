Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7VMaulw001771
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 18:36:57 -0400
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.231])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7VMafqX025085
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 18:36:41 -0400
Received: by wx-out-0506.google.com with SMTP id i27so477619wxd.6
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 15:36:41 -0700 (PDT)
Message-ID: <d9def9db0808311536l3d35f6a4y677d535536e4cf97@mail.gmail.com>
Date: Mon, 1 Sep 2008 00:36:40 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1220221611.2669.55.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BAY126-W51445FEADC96EC0484E7ABE35D0@phx.gbl>
	<d9def9db0808311511p51df8befm2cbd641fc4d0a88f@mail.gmail.com>
	<1220221611.2669.55.camel@pc10.localdom.local>
Cc: video4linux-list@redhat.com, alkureishi.lee@gmail.com,
	Lee Alkureishi <lee_alkureishi@hotmail.com>
Subject: Re: em2820, Tena TNF-9533 and V4L
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

On Mon, Sep 1, 2008 at 12:26 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> Markus,
>
> Am Montag, den 01.09.2008, 00:11 +0200 schrieb Markus Rechberger:
>> On Sun, Aug 31, 2008 at 8:26 PM, Lee Alkureishi
>> <lee_alkureishi@hotmail.com> wrote:
>> >
>> > Hi all,
>> >
>> > Hoping someone on this list can help me with this frustrating problem:
>> >
>> > I'm running Mythbuntu 8.04, fully updated. I'm trying to set up a USB TV tuner box, and have made progress but haven't quite got it working.
>> >
>> > The USB box is a Kworld PVR TV 2800 RF. It uses a Empia em2820 chipset, and a Tena TNF-9533-D/IF tuner. Other chips I found under the casing are:
>> > RM-KUB03 04AEAAC6, HEF4052BT, TEA5767, SAA7113H.
>> >
>> > The PCB has the following printed on it: EM2800TV_KW Ver:F
>> >
>> > I followed the instructions to install v4l using mercurial, and have got it to the point where dmesg shows that the card is recognised and initialised:
>> > ------
>> > dmesg:
>> > [ 1844.847318] usb 5-1: new high speed USB device using ehci_hcd and address 3
>> > [ 1844.979744] usb 5-1: configuration #1 chosen from 1 choice
>> > [ 1844.980718] em28xx new video device (eb1a:2820): interface 0, class 255
>> > [ 1844.980727] em28xx: device is attached to a USB 2.0 bus
>> > [ 1844.980730] em28xx: you're using the experimental/unstable tree from mcentral.de
>> > [ 1844.980732] em28xx: there's also a stable tree available but which is limited to
>> > [ 1844.980734] em28xx: linux <=2.6.19.2
>> > [ 1844.980736] em28xx: it's fine to use this driver but keep in mind that it will move
>> > [ 1844.980738] em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon as it's
>> > [ 1844.980740] em28xx: proved to be stable
>> > [ 1844.980743] em28xx #0: Alternate settings: 8
>> > [ 1844.980746] em28xx #0: Alternate setting 0, max size= 0
>> > [ 1844.980748] em28xx #0: Alternate setting 1, max size= 1024
>> > [ 1844.980750] em28xx #0: Alternate setting 2, max size= 1448
>> > [ 1844.980752] em28xx #0: Alternate setting 3, max size= 2048
>> > [ 1844.980754] em28xx #0: Alternate setting 4, max size= 2304
>> > [ 1844.980756] em28xx #0: Alternate setting 5, max size= 2580
>> > [ 1844.980758] em28xx #0: Alternate setting 6, max size= 2892
>> > [ 1844.980760] em28xx #0: Alternate setting 7, max size= 3072
>> > [ 1845.271190] tuner 1-0060: TEA5767 detected.
>> > [ 1845.271199] tuner 1-0060: chip found @ 0xc0 (em28xx #0)
>> > [ 1845.271254] attach inform (default): detected I2C address c0
>> > [ 1845.271260] tuner 0x60: Configuration acknowledged
>> > [ 1845.271266] tuner 1-0060: type set to 61 (Tena TNF9533-D/IF/TNF9533-B/DF)
>> > [ 1845.272189] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
>> > [ 1845.272215] attach inform (default): detected I2C address c2
>> > [ 1845.272219] tuner 0x61: Configuration acknowledged
>> > [ 1845.272223] tuner 1-0061: type set to 61 (Tena TNF9533-D/IF/TNF9533-B/DF)
>> > [ 1845.302962] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
>> > [ 1845.332719] attach_inform: saa7113 detected.
>> > [ 1845.346159] em28xx #0: V4L2 device registered as /dev/video0
>> > [ 1845.346173] em28xx #0: Found Kworld PVR TV 2800 RF
>> > ----------
>> >
>>
>> please don't use that driver, it'S not maintained anymore either.
>>
>> can you run:
>>
>> $ apt-get install --reinstall linux-image-`uname -r`-generic
>>
>> for restoring your kernel?
>>
>> You should safely be able to compile the latest em28xx driver or grab
>> debian packages for it (what does uname -r show up?)
>>
>> $ hg clone http://mcentral.de/hg/~mrec/em28xx-new
>> $ cd em28xx-new
>> $ ./build.sh build
>> $ ./build.sh install
>>
>> there's also em28xx at mcentral.de available which has alot
>> subscribers who have em28xx based devices, it only deals about Empia
>> based devices and appilcations + support for those devices only.
>>
>> Markus
>
> that tuner won't work for NTSC.
>
> Did you notice my previous reply?
>

sure although I wonder KWorld mostly sells NTSC based hardware as far as I know.

http://www.kworldcomputer.com/product/analog/003/pvr-tv2800u.htm

Lee, can you check if it's about exactly that device?

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
