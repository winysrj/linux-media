Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n95IDs6F025239
	for <video4linux-list@redhat.com>; Mon, 5 Oct 2009 14:13:54 -0400
Received: from mail-fx0-f205.google.com (mail-fx0-f205.google.com
	[209.85.220.205])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n95IDb5c013041
	for <video4linux-list@redhat.com>; Mon, 5 Oct 2009 14:13:37 -0400
Received: by fxm1 with SMTP id 1so2972452fxm.7
	for <video4linux-list@redhat.com>; Mon, 05 Oct 2009 11:13:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254766059415-3770513.post@n2.nabble.com>
References: <e48b28270812041409t31139b4v1ca6c8ab1578b4e9@mail.gmail.com>
	<412bdbff0812041415t431d6c4ao6c053c49f7f7f03e@mail.gmail.com>
	<1254766059415-3770513.post@n2.nabble.com>
Date: Mon, 5 Oct 2009 14:13:35 -0400
Message-ID: <829197380910051113v6f5574e8xa0dac8689a51e5c4@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: razvanz <viperzden2003@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: WinFast PalmTop DTV200H USB TvTuner
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

On Mon, Oct 5, 2009 at 2:07 PM, razvanz <viperzden2003@yahoo.com> wrote:
> Devin Heitmueller wrote:
>>
>> As I told Gabor, this has been in my queue for a couple of weeks.  If
>> someone else wants to help out, the following needs to be done:
>>
>> 1.  An entry needs to be added to em28xx-cards.c for the device,
>> setting the decoder field for the CX25843.
>>
>> 2.  The windows trace he collected needs to be looked at and the GPIOs
>> need to be setup properly.
>>
>> 3.  The xc3028L tuner needs to be configured in em28xx-cards.c -
>> *note* that this is the low power device and using the regular xc3028
>> profile could burn out the tuner (just look at the entry for the AMD
>> TV Wonder 600).
>>
>> 4.  If you want to get digital support working, you need to adapt the
>> zarlink driver to work for the WJCE6353, and configure the entry in
>> the em28xx-dvb.c, providing the correct IF.
>>
>> None of this is rocket science...
>>
>> Devin
>>
>> On Thu, Dec 4, 2008 at 5:09 PM, Nagy Gabor <nagygabor.info@gmail.com>
>> wrote:
>>> I've got a Leadtek
>>> dtv200h<http://www.leadtek.com/eng/tv_tuner/overview.asp?lineid=6&pronameid=413>usb
>>> tv tuner, and it got 4 chips:
>>>
>>> EMPIA
>>> 2882<http://kepfeltoltes.hu/081204/EMPIA_2882_www.kepfeltoltes.hu_.jpg>
>>> WJCE6353
>>> <http://kepfeltoltes.hu/081204/WJCE6353_www.kepfeltoltes.hu_.jpg>
>>> CX25843-24Z<http://kepfeltoltes.hu/081204/CX25843-242_www.kepfeltoltes.hu_.jpg>
>>> XCEIVE
>>> XC3028LCQ<http://kepfeltoltes.hu/081204/XCEIVE_XC3028LCQ_www.kepfeltoltes.hu_.jpg>
>>> front<http://kepfeltoltes.hu/081204/258590942front_www.kepfeltoltes.hu_.jpg>
>>> back
>>> <http://kepfeltoltes.hu/081204/22578894back_www.kepfeltoltes.hu_.jpg>
>>>
>>> distro: I use Debian Lenny
>>> 2.6.26-1-amd64<http://cdimage.debian.org/cdimage/lenny_di_rc1/amd64/bt-cd/debian-testing-amd64-kde-CD-1.iso.torrent>-
>>> "or anything you want" :D
>>>
>>> lsusb:
>>> Bus 007 Device 005: ID 0413:6f02 Leadtek Research, Inc.
>>>
>>> dmesg:
>>> [    2.787953] usb 7-1: new high speed USB device using ehci_hcd and
>>> address
>>> 2
>>> [    2.928702] usb 7-1: configuration #1 chosen from 1 choice
>>> [    2.928702] usb 7-1: New USB device found, idVendor=0413,
>>> idProduct=6f02
>>> [    2.928702] usb 7-1: New USB device strings: Mfr=0, Product=1,
>>> SerialNumber=2
>>> [    2.928702] usb 7-1: Product: WinFast PalmTop DTV200 H
>>> [    2.928702] usb 7-1: SerialNumber: 2222
>>>
>>> tvtime-scanner:
>>> videoinput: Cannot open capture device /dev/video0: No such file or
>>> directory
>>>
>>> Does someone know, how to get it work under Linux?
>>> Thank you!
>>>
>>> --
>>> Nagy Gabor
>>> http://szabadlinuxot.blogspot.com/
>>> --
>>> video4linux-list mailing list
>>> Unsubscribe
>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>
>>
>>
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>>
>
> Hi,
>    I was wandering if there si a way to make the leadtek dtv 200h tv tuner
> work under linux.
> Thanks!

Well, I outlined the development work items required in the email you
referenced.  Unless you're willing and able to roll up your sleeves
and do some development, then at this point I wouldn't expect to see
this device working any time soon.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
