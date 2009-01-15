Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FNg9xe001976
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 18:42:09 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0FNevKs002013
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 18:40:58 -0500
Received: by bwz13 with SMTP id 13so3934895bwz.3
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 15:40:57 -0800 (PST)
Message-ID: <d9def9db0901151540y21f05a9ey5d937256f0fb80ae@mail.gmail.com>
Date: Fri, 16 Jan 2009 00:40:47 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Carsten Meier" <cm@trexity.de>
In-Reply-To: <20090115235511.1ea5fdd5@tuvok>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <20090115163348.5da9932a@tuvok>
	<09CD2F1A09A6ED498A24D850EB10120817E30B7506@Colmatec004.COLMATEC.INT>
	<20090115175121.25c4bdaa@tuvok> <496FB713.5020609@draigBrady.com>
	<20090115235511.1ea5fdd5@tuvok>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: How to identify USB-video-devices
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

On Thu, Jan 15, 2009 at 11:55 PM, Carsten Meier <cm@trexity.de> wrote:
> Am Thu, 15 Jan 2009 22:22:11 +0000
> schrieb Pádraig Brady <P@draigBrady.com>:
>
>> Carsten Meier wrote:
>> > Storing device-file-names is also not an option because they are
>> > created dynamicly.
>>
>> You use udev rules to give persistent names.
>>
>> Here is my /etc/udev/rules.d/video.rules file,
>> which creates /dev/webcam and /dev/tvtuner as appropriate.
>>
>> KERNEL=="video*" SYSFS{name}=="USB2.0 Camera", NAME="video%n",
>> SYMLINK+="webcam" KERNEL=="video*" SYSFS{name}=="em28xx*",
>> NAME="video%n", SYMLINK+="tvtuner"
>>
>> To find distinguishing attributes to match on use:
>>
>> echo /sys/class/video4linux/video* | xargs -n1 udevinfo -a -p
>>
>> cheers,
>> Pádraig.
>
> This already came up on the pvrusb2-list and someone told me (I don't
> know much about udev) that it might cause problems on disconnection of
> a device with a file-descriptor open which then gets reconnected
> and there are two device-files for it. I also don't like it,
> because an average user (including me) usually can't or don't want to
> write udev rules. Finally v4l2 already contains a very simple and
> reliable mechanism for doing this (bus_info-field) which simply isn't
> used correctly by the USB-drivers.
>

check the device serial for this one. I don't know if the pvrusb2
devices have it set up properly
I know some manufacturers don't do!
Be flexible with the node, but not with the serial.

cat /sys/class/video4linux/video0/device/serial
080702001788

you have the nodename in it, there are many ways to retrieve the nodename.

> My app should simply scan for /dev/video*-files, read out capabilities
> from them, present the user menus to select devices and edit device
> settings, save settings to a file and apply them on demand. This would
> work fine if bus_info was filled right, without root-privileges,
> without special udev rules or other sysfs-magic.
>
> Regards,
> Carsten
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
