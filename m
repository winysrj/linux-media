Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAUKVHC7031038
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 15:31:17 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com
	(mk-filter-4-a-1.mail.uk.tiscali.com [212.74.100.55])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAUKV3Da026364
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 15:31:04 -0500
From: "Chris Grove" <dj_gerbil@tiscali.co.uk>
To: <thierry.merle@free.fr>
References: <002901c95150$44c16b90$ce4442b0$@co.uk>
	<4931ADCD.2000407@free.fr>	<011901c952f4$a02d9710$e088c530$@co.uk>
	<4932ACE9.7030309@free.fr> <012301c95302$6eed5f60$4cc81e20$@co.uk>
In-Reply-To: <012301c95302$6eed5f60$4cc81e20$@co.uk>
Date: Sun, 30 Nov 2008 20:30:58 -0000
Message-ID: <013f01c9532a$8dcbdf10$a9639d30$@co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Language: en-gb
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: RE: Hauppauge WinTV USB Model 566 PAL-I
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

A further, slightly interesting development is that the s-video input works
fine with no interference at all, also the TV picture in fine in windows.
Just thought that might help with a solution.

-----Original Message-----
From: video4linux-list-bounces@redhat.com
[mailto:video4linux-list-bounces@redhat.com] On Behalf Of Chris Grove
Sent: 30 November 2008 15:44
To: 'Thierry Merle'
Cc: video4linux-list@redhat.com
Subject: RE: Hauppauge WinTV USB Model 566 PAL-I

Hi,
Yes I am using the external audio, mainly because I haven't got a clue how
to get the audio via USB to work. If you've got any pointers on that,
that'll be really cool I'm not bothered about the 16KHz sound. The white
lines on the picture are constant but move up and down the screen. It very
much reminds me of an old TV fault called sound on vision where the video
and audio carriers aren't separated properly. 

-----Original Message-----
From: Thierry Merle [mailto:thierry.merle@free.fr]
Sent: 30 November 2008 15:11
To: Chris Grove
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge WinTV USB Model 566 PAL-I

Chris Grove wrote:
> Hi,
> Ok I've tried it and it works, sort of. I've managed to get a picture 
> that works, the problem now is that the old bug of white lines on the 
> display and noise on the audio is back. Any ideas if there is a tweak 
> or something I can use to fix it please??
> 
Do you use external audio or the audio via usb?
Please use the external audio, much better sound quality (44KHz whereas
16KHz via USB).
What are the white lines on the display? Interferences, constant lines,
other?

> -----Original Message-----
> From: Thierry Merle [mailto:thierry.merle@free.fr]
> Sent: 29 November 2008 21:02
> To: Chris Grove
> Cc: video4linux-list@redhat.com
> Subject: Re: Hauppauge WinTV USB Model 566 PAL-I
> 
> Hi Chris,
> 
> Chris Grove wrote:
>> Hi there, I've got one of these cards but I'm having trouble getting 
>> it to work. The problem is that it loads ok, but when I try to use 
>> it, it turns out that the tuner module has loaded the wrong tuner type.
>> Instead of using tuner type 1, a PAL-I tuner which mine is, it 
>> selects a PAL-BG tuner. Now I've tried using type=1 in the modprobe 
>> line but it turns out that, that is no longer supported.
>>
>>  
>>
>> System Info.
>>
>> I'm using GeexBox which is built on linux-2.6.21.3 kernel.
>>
>>  
>>
>> The Init.d script is:
>>
>> #!/bin/sh
>>
>> #
>>
>> # setup tv cards
>>
>> #
>>
>> # runlevels: geexbox, debug, install
>>
>>  
>>
>> echo "### Setting up TV card ###"
>>
>> modprobe tuner pal=I
>>
>> modprobe tveeprom
>>
>> modprobe usbvision
>>
>> modprobe saa7115
>>
>>  
>>
>> echo -n "" > /var/tvcard
>>
>> exit 0
>>
>>  
>>
>> And the output from dmesg is:
>>
>> <6>usbvision_probe: Hauppauge WinTv-USB II (PAL) MODEL 566 found
>>
>> <6>USBVision[0]: registered USBVision Video device /dev/video0 [v4l2]
>>
>> <6>USBVision[0]: registered USBVision VBI device /dev/vbi0 [v4l2] 
>> (Not Working Yet!)
>>
>> <6>usbcore: registered new interface driver usbvision
>>
>> <6>USBVision USB Video Device Driver for Linux : 0.9.9
>>
>> <6>eth0: Media Link On 100mbps full-duplex
>>
>> <6>tuner 1-0042: chip found @ 0x84 (usbvision #0)
>>
>> <6>tda9887 1-0042: tda988[5/6/7] found @ 0x42 (tuner)
>>
>> <6>tuner 1-0061: chip found @ 0xc2 (usbvision #0)
>>
>> <6>tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216 and
>> compatibles))
>>
>> <6>tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216 and
>> compatibles))
>>
>> <6>saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (usbvision
>> #0)
>>
>> <6>tda9887 1-0042: i2c i/o error: rc == -121 (should be 4)
> please try a modprobe tda9887 debug=1 to see some debug messages where 
> it fails.
> Proceed like this:
> modprobe tda9887 debug=1
> modprobe saa7115
> modprobe usbvision
> Then, plug-in your device.
> Geeksbox is based on mplayer, I tested OK mplayer but with some tuning 
> like
> this:
> mplayer -tv
> driver=v4l2:width=320:height=240:norm=SECAM:outfmt=yuy2:channels=21-F2
> tv://
> 
> Cheers,
> Thierry
> 
> 


-- 
                   ,
                   }\      °
           _    .-`  `-.  o
           \`'./     (o)\
            ) >   )))    } O
           /_.'\     / \/
       jgs      `'---'=`     http://thierry.merle.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
