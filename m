Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9JIojcb002745
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 14:50:45 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9JIoVTw019199
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 14:50:32 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 64ECB11CF8B0
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 19:50:30 +0100 (BST)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7bXYiYCUiJU9 for <video4linux-list@redhat.com>;
	Sun, 19 Oct 2008 19:50:30 +0100 (BST)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 18BE6118C1C5
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 19:50:30 +0100 (BST)
Message-ID: <48FB8175.7070006@pickworth.me.uk>
Date: Sun, 19 Oct 2008 19:50:29 +0100
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <48FB6377.40707@pickworth.me.uk> <48FB73BA.1040608@hhs.nl>
In-Reply-To: <48FB73BA.1040608@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: gspca_spca561/gspca-main on 2.6.27-gentoo: webcam doesn't work,
 and udev attribute missing
Reply-To: ian@pickworth.me.uk
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

Hans de Goede wrote:
> Ian Pickworth wrote:
>> 
>> In the "old" driver in a kernel 2.6.26, there was an attribute that
>> showed this
>>     ATTR{model}=="Logitech QuickCam EC"
>> 
> There are 2 things here which you seem to be mixing:
> 1) the udev ATTR{model} is no longer getting set, which is interesting,
> do you
> know where udev gets this from / what udev expects from a driver to provide
> this?

I'm just a reasonably dumb user unfortunately. I see what udev produces
rather than knowing where it comes from. If I were to guess, I would say
its from the driver, but your next statement seems to say not...

> 
> 2) The string shown in the application to identify a Camera. Applications
> should show the string provided by the driver through the QUERYCAP
> ioctl, this string indeed has changed. We used to have a list of
> hardcoded strings matched to USB-ID's, this however was wrong as many
> webcam bridges have only one usb-id, yet get used in many different
> cams. So now we show the string provided by the cam itself over USB (see
> dmesg after plug in to see if your cam provides one). If the cam
> manufacturer has been cheap and didn't put an eeprom in the cam to
> provide an USB model string, then we use a generic string in the form
> of: "USB Camera (093a:2476)"

Don't see a "USB Camera (093a:2476)" anywhere in the applications
presenting choices - just "Camera", which is what the udev attribute says:
    ATTRS{manufacturer}=="        "
    ATTRS{product}=="Camera"

> 
>> Second problem is the biggy. The camera doesn't work :-(.
> 
> Which is to be expected, the gspca561 bridge delivers frames in a custom
> huffman compressed bayer format. The old gspca driver did format
> conversion inside the kernel. Which is a very bad thing to do and thus
> has been removed in the new version.
> 
> Gstreamer, or almost any other app / library for that matter does not
> know how to handle this format. For this I've written libv4l:
> http://hansdegoede.livejournal.com/3636.html
> 
> Get the latest version here:
> http://people.atrpms.net/~hdegoede/libv4l-0.5.1.tar.gz

Gentoo has an ebuild for this - media-libs/libv4l - neat.
I emerged it, and the Gentoo developer has put a nice comment in the ebuild:

 *
 * libv4l includes wrapper libraries for compatibility and pixel format
 * conversion, which are especially useful for users of the gspca usb
 * webcam driver in kernel 2.6.27 and higher.
 *
 * To add v4l2 compatibility to a v4l application 'myapp', launch it via
 * LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so myapp
 * To add automatic pixel format conversion to a v4l2 application, use
 * LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so myapp
 *

So, the gstreamer pipe now works:
	LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so gst-launch-0.10 v4lsrc
device="/dev/video_webcam" ! xvimagesink

mplayer, spcaview and skype all work with
	LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so

cheese works with
	LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so

So that's all my apps working again - thanks.

> 
> FOSS applications can be easily adapted to instead use the library
> directly, a coordinated cross distro effort is underway to make this
> happen (including pushing patches upstream), see:
> http://linuxtv.org/v4lwiki/index.php/Libv4l_Progress
> 
> You can find patches for quite a few applications here. Help in patching
> others is very much welcome! If you need some quick instructions what to
> change exactly let me know.

I am not a C/C++ coder unfortunately, although I will look at trying to
help if I can.

Regards
Ian

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
