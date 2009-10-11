Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59930 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZJKPpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 11:45:21 -0400
Received: by fxm27 with SMTP id 27so8198828fxm.17
        for <linux-media@vger.kernel.org>; Sun, 11 Oct 2009 08:44:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <156a113e0910110639u52ca17a8ha48830fa1784e010@mail.gmail.com>
References: <156a113e0910110639u52ca17a8ha48830fa1784e010@mail.gmail.com>
Date: Sun, 11 Oct 2009 11:44:44 -0400
Message-ID: <829197380910110844r1fd62edfw24d5808b65f727a0@mail.gmail.com>
Subject: Re: No sound in television with Leadtek Winfast USB II Deluxe
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Magnus Alm <magnus.alm@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/10/11 Magnus Alm <magnus.alm@gmail.com>:
> Hi!
>
> I've been pooking around to get my "Leadtek Winfast USB II Deluxe"
> working in Ubuntu 9.10 (kernel 2.6.31-12-generic).
>
> The code for the drivers is collected with:
>
> hg clone http://linuxtv.org/hg/v4l-dvb
>
>
> So far, in television mode, I can tune channels and get picture. But I
> have no sound.
> In Composite mode I have picture and sound, altho it's just black and
> white. (Might depend on my source tho, I haven't put that much time
> into it.)
> In Svideo mode I have sound and color picture, so thats OK.
> To get any sound in tvtime or Xawttv, I have to run "sox -r 48000 -c 2
> -t ossdsp /dev/dsp1 -t ossdsp /dev/dsp" in a terminal. Only works with
> Composite/Svideo.
>
>
> The changes I've made to make it work so far is the following:
>
> em28xx-cards.c
>
>    { USB_DEVICE(0x0413, 0x6023),
>            .driver_info = EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE },
>
> Just for my own convenience, otherwise it finds the
> LEADTEK_WINFAST_USBII device instead, I got bored with doing "modprobe
> em28xx card=28" ;-p.
>
>
> [EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE] = {
>        .name         = "Leadtek Winfast USB II Deluxe",
>        .valid        = EM28XX_BOARD_NOT_VALIDATED,
>        .tuner_type   = TUNER_PHILIPS_FM1216ME_MK3,
>        .tda9887_conf = TDA9887_PRESENT,
>        .decoder      = EM28XX_SAA711X,
>        .input        = { {
>            .type     = EM28XX_VMUX_TELEVISION,
>            .vmux     = SAA7115_COMPOSITE4,
>                             */ Was SAA7115_COMPOSITE2 originally */
>            .amux     = EM28XX_AMUX_VIDEO,
>        }, {
>            .type     = EM28XX_VMUX_COMPOSITE1,
>            .vmux     = SAA7115_COMPOSITE5,
>                             */ Was SAA7115_COMPOSITE0 originally */
>            .amux     = EM28XX_AMUX_LINE_IN,
>        }, {
>            .type     = EM28XX_VMUX_SVIDEO,
>            .vmux     = SAA7115_SVIDEO3,
>                                  */ Was SAA7115_COMPOSITE0 originally
>  */
>            .amux     = EM28XX_AMUX_LINE_IN,
>        } },
>
>
>
> saa7115.c
>
> R_08_SYNC_CNTL, 0x28,            /* 0xBO: auto detection, 0x68 = NTSC */
>
> Changed it from 0x68, so I don't have to switch back to PAL after
> switching input mode. Just for my own convenience.
>
>
>
> When I was searching the internet for information about getting my usb
> tv tuner working, I came across this thread.
>
> http://thread.gmane.org/gmane.linux.drivers.em28xx/97/focus=124
>
> (Cut  from the post where the poster got working picture and audio.
> After snooping the device in Windows and parsing the output with
> parser.pl, then playing around with Usbreplay (a tool I don't have
> access to tho, and he was using a em28xx-new build.))
>
> "This line made the video appear:
> 000385:  OUT: 000001 ms 005258 ms 40 02 00 00 42 00 02 00 >>>  02 c4
>
> And this worked for audio:
> 000895:  OUT: 000000 ms 006684 ms 40 00 00 00 42 00 01 00 >>>  16
>
>
> This line made both usb audio and jack audio output of the device work :)"
>
>
> The video output I fixed with ".vmux     = SAA7115_COMPOSITE4, ".
>
> After snooping my device in windows, just swapping between
> television/Composite/Svideo, I didn't get any line with:
>
> 40 00 00 00 42 00 01 00 >>>  16
>
> The only comparable output I found from my snooping is:
>
> 40 00 00 00 42 00 01 00 >>>  02
>
> (Might be because we didn't use the same drivers in Windows, default
> the installation program installs the drivers for "Winfast TV USB II",
> doh!.)
>
> When loading em28xx with reg_debug=1 and doing the same swapping
> between input modes, as I did in windows, with tvtime or xawtv.
> I got the following lines in syslog containing "40 00 00 00 42 00 01
> 00" after every input mode switch.
>
> [ 2548.560012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 02
> [ 2548.584049] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 04
> [ 2548.608014] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 06
> [ 2548.632012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 36
> [ 2548.656012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 38
> [ 2548.732012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 14
> [ 2548.756012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 10
> [ 2548.780012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 0c
> [ 2548.804013] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 0e
> [ 2548.828012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 12
> [ 2548.852013] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 16
> [ 2548.876012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 18
> [ 2548.900012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 26
> [ 2548.924009] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 2a
> [ 2548.948012] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 32
> [ 2548.972013] (pipe 0x80000600): OUT: 40 00 00 00 42 00 01 00 >>> 02
>
> This might not be the source of my problem, since it both starts and
> ends with ">>> 02", but the em28xx driver seems to be unnecessarily
> chatty to me.
> There is much more difference's between the logs than that tho, added
> examples from each log as attachments, for those that would care to
> look at it :-).
>
> One funny detail in those logs:
> "40 02 00 00 42 00 02 00 >>> 02 c5" Composite in windows is "40 02 00
> 00 42 00 02 00 >>> 02 85" in linux
> "40 02 00 00 42 00 02 00 >>> 02 c4" Television in windows is "40 02 00
> 00 42 00 02 00 >>> 02 84" in linux
> "40 02 00 00 42 00 02 00 >>> 02 c9" Svideo in windows is "40 02 00 00
> 42 00 02 00 >>> 02 89" in linux.
>
>
> Any hints on how I should proceed would be appreciated ;-).
>
>
> Regards
> Magnus Alm
>

Sound like you're not configuring the standard properly.  You cannot
just hack it into saa7115 because the xc3028 driver needs to know the
proper standard as well, or else you will get black/white picture and
no audio.

What standard are you trying to use?  And why are you not just
configuring it in tvtime?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
