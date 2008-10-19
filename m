Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9JHn86I018310
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 13:49:08 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9JHmrXb030113
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 13:48:53 -0400
Message-ID: <48FB73BA.1040608@hhs.nl>
Date: Sun, 19 Oct 2008 19:51:54 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: ian@pickworth.me.uk
References: <48FB6377.40707@pickworth.me.uk>
In-Reply-To: <48FB6377.40707@pickworth.me.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: gspca_spca561/gspca-main on 2.6.27-gentoo: webcam doesn't work,
 and udev attribute missing
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
> I'm having a go at the latest hg (pulled at 16:00 today - 19 October).
> This is because I previously used the gspcav1-20071224 drivers for my
> webcam, and these no longer compile under 2.6.27, so have to change.
> 
> The two modules that are relevant are gspca_main and gspca_spca561
> 
> Two problems. First is that my udev rule for the web cam no longer
> works. Checking the device attributes, it shows:
> 

<snip>

> In the "old" driver in a kernel 2.6.26, there was an attribute that
> showed this
> 	ATTR{model}=="Logitech QuickCam EC"
> which allowed various applications to display its full device name. Now
> they can just show "Camera" - which is sort of no good if you have more
> than one.

There are 2 things here which you seem to be mixing:
1) the udev ATTR{model} is no longer getting set, which is interesting, do you
know where udev gets this from / what udev expects from a driver to provide
this?

2) The string shown in the application to identify a Camera. Applications
should show the string provided by the driver through the QUERYCAP ioctl, this 
string indeed has changed. We used to have a list of hardcoded strings matched 
to USB-ID's, this however was wrong as many webcam bridges have only one 
usb-id, yet get used in many different cams. So now we show the string provided 
by the cam itself over USB (see dmesg after plug in to see if your cam provides 
one). If the cam manufacturer has been cheap and didn't put an eeprom in the 
cam to provide an USB model string, then we use a generic string in the form 
of: "USB Camera (093a:2476)"

> Second problem is the biggy. The camera doesn't work :-(.

Which is to be expected, the gspca561 bridge delivers frames in a custom 
huffman compressed bayer format. The old gspca driver did format conversion 
inside the kernel. Which is a very bad thing to do and thus has been removed in 
the new version.

Gstreamer, or almost any other app / library for that matter does not know how 
to handle this format. For this I've written libv4l:
http://hansdegoede.livejournal.com/3636.html

Get the latest version here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.1.tar.gz

Then read:
http://moinejf.free.fr/gspca_README.txt
or the included README for install instructions.

As described in the documents you can make existing applications use this lib 
with an LD_PRELOAD loadable wrapper.

FOSS applications can be easily adapted to instead use the library directly, a 
coordinated cross distro effort is underway to make this happen (including 
pushing patches upstream), see:
http://linuxtv.org/v4lwiki/index.php/Libv4l_Progress

You can find patches for quite a few applications here. Help in patching others 
is very much welcome! If you need some quick instructions what to change 
exactly let me know.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
