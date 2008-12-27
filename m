Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBRG9VCi013208
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 11:09:31 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBRG9CAp006237
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 11:09:13 -0500
Received: by bwz13 with SMTP id 13so12071642bwz.3
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 08:09:12 -0800 (PST)
Message-ID: <412bdbff0812270809k3994e34fw15b4ba61907edc2b@mail.gmail.com>
Date: Sat, 27 Dec 2008 11:09:12 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Rick Bilonick" <rab@nauticom.net>
In-Reply-To: <1230370785.3450.91.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230233794.3450.33.camel@localhost.localdomain>
	<20081226010307.2c7e3b55@gmail.com>
	<1230269443.3450.48.camel@localhost.localdomain>
	<20081226174129.7c752fc6@gmail.com>
	<1230353764.3450.79.camel@localhost.localdomain>
	<1230359011.3450.88.camel@localhost.localdomain>
	<1230370785.3450.91.camel@localhost.localdomain>
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: Compiling v4l-dvb-kernel for Ubuntu and for F8
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

On Sat, Dec 27, 2008 at 4:39 AM, Rick Bilonick <rab@nauticom.net> wrote:
>
> On Sat, 2008-12-27 at 01:23 -0500, Rick Bilonick wrote:
>> On Fri, 2008-12-26 at 23:56 -0500, Rick Bilonick wrote:
>> >
>> > So far, I haven't been able to find dvb-fe-xc5000-1.1.fw. (I had
>> > previously installed a firmware file (version 4), but apparently the
>> > needed firmware is not in the tar file.
>> >
>> > Thanks for the help. I'm going to continue looking for the firmware.
>> >
>> > I'm not sure if this firmware is absolutely necessary given it appears
>> > to be the IR receiver. I am trying to use xine (I have a channel.conf
>> > file that I created for a different tuner in another computer) but so
>> > far have not gotten xine to display the digital signal.
>> >
>> > Rick B.
>> >
>>
>> OK, I found the firmware on-line via MythTV
>> ( http://www.mythtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_(800i)#Firmware ) at http://www.steventoth.net/linux/xc5000 . (I guess I could have taken this from the CD that came with the tuner.) This contains the the windows drivers with a shell script to extract the firmware (both for the tuner and the ir receiver - the device apparently won't work without both pieces of firmware). So the device now works on the HP2133 mini-notebook running Ubuntu 8.10. Now onto getting this to run on Fedora 8 and 10. Douglas, thanks for your help.
>>
>> Rick B.
>
>
> v4l-dvb compiled and installed perfectly on Fedora 8. (For Ubuntu 8.10,
> there were a few warning messages but it still worked fine. There were
> no warning messages for Fedora 8.) Xine works fine for Fedora 8.
>
> Unfortunately, there are some errors for Fedora 10. I will post them as
> soon as possible.
>
> Rick B.
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

Hello Rick,

Yeah, as you eventually discovered (and is documented in the wiki),
you need both firmware files (one is for the USB bridge chip and the
other is required for the xc5000 tuner chip).  If you find any
problems with the Wiki documentation for the product (I did the driver
support for that device), feel free to email me.

Also note, you mentioned the Wiki page for the 800i, whereas you have
the 801e, which is documented here:

http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_%28801e%29#Making_it_Work

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
