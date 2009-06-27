Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:51279 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZF0V5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 17:57:01 -0400
Received: by gxk26 with SMTP id 26so2364532gxk.13
        for <linux-media@vger.kernel.org>; Sat, 27 Jun 2009 14:57:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL103-W513258452EA45C7700193888320@phx.gbl>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <COL103-W513258452EA45C7700193888320@phx.gbl>
Date: Sat, 27 Jun 2009 17:57:03 -0400
Message-ID: <b24e53350906271457r594decccg397537db0d324754@mail.gmail.com>
Subject: Re: Bah! How do I change channels?
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: George Adams <g_adams27@hotmail.com>
Cc: dheitmueller@kernellabs.com, awalls@radix.net,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 27, 2009 at 12:25 AM, George Adams<g_adams27@hotmail.com> wrote:
>
> Thanks again to both of you for your help.  I gave the no_poweroff flag a try, but didn't see any difference.  I also tried a "setchannel 3" during the middle of the encoding session, and also saw no change.
>
> But I think I've found the problem:
>
>> v4lctl setnorm NTSC; v4lctl setfreqtab us-bcast; v4lctl -v 1 setchannel 3
> vid-open: trying: v4l2-old...
> vid-open: failed: v4l2-old
> vid-open: trying: v4l2...
> v4l2: open
> v4l2: device info:
>  em28xx 0.1.1 / Pinnacle PCTV HD Pro Stick @ usb-0000:00:1a.7-1
> vid-open: ok: v4l2
> freq: reading /usr/share/xawtv/Index.map
> v4l2:   tuner cap:
> v4l2:   tuner rxs:
> v4l2:   tuner cur: MONO
> cmd: "setchannel" "3"
> v4l2: freq: 0.000
> v4l2: close
>
>
> What?  freq: 0.000 ?  After finding the ivtv package and compiling its utils, I confirm it with this:
>
>> v4l2-ctl -F
> Frequency: 0 (0.000000 MHz)
>
>> ivtv-tune -c 3
> /dev/video0: 61.250 MHz
>
>> v4l2-ctl -F
> Frequency: 980 (61.250000 MHz)
>
>> v4lctl setchannel 3
>
>> v4l2-ctl -F
> Frequency: 0 (0.000000 MHz)
>
>
> So mysteriously, it seems like v4lctl is just plain not working.  And ivtv-tune, on the other hand, is working just fine.  After I do that and start Helix Producer, I see channel 3 just like I had hoped.
>
> (strangely, v4lctl can do other things fine, like change the norm from NTSC to PAL.  It just can't change the channel.)
>
> So, sorry that it went off in rabbit trails of the device powering down and so forth.  I wonder what happened to my v4lctl program, though?  xawtv itself (running in X) seems to work fine when I tell it to change the channel...
>
>
>
>
>
>
>> Date: Fri, 26 Jun 2009 09:42:06 -0400
>> Subject: Re: Bah! How do I change channels?
>> From: dheitmueller@kernellabs.com
>> To: awalls@radix.net
>> CC: g_adams27@hotmail.com; video4linux-list@redhat.com; linux-media@vger.kernel.org
>>
>> On Fri, Jun 26, 2009 at 7:50 AM, Andy Walls wrote:
>>> I use either v4l2-ctl or ivtv-tune
>>>
>>> $ ivtv-tune -d /dev/video0 -t us-bcast -c 3
>>> /dev/video0: 61.250 MHz
>>>
>>> $ v4l2-ctl -d /dev/video0 -f 61.250
>>> Frequency set to 980 (61.250000 MHz)
>>>
>>>
>>> Regards,
>>> Andy
>>
>> Hello Andy,
>>
>> I had sent George some email off-list with basically the same
>> commands. I think what might be happening here is the tuner gets
>> powered down when not in use, so I think it might be powered down
>> between the v4l-ctl command and the running of the other application.
>>
>> I have sent him a series of commands to try where he modprobes the
>> xc3028 driver with "no_poweroff=1", and we will see if that starts
>> working.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
> _________________________________________________________________
> Lauren found her dream laptop. Find the PC that’s right for you.
> http://www.microsoft.com/windows/choosepc/?ocid=ftp_val_wl_290
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>

George:

Try 'v4l2-ctl -d /dev/video0 -f 61.250' to tune to broadcast channel 3
per one of Devin's e-mails to you.  I do not know why setchannel is
not working for you.  I use both ivtv-tune v4l2-ctl and both do work
and v4l2-ctl should work in this instance for you.  I always open my
USB TV device via mplayer not specifiying a channel and then use
ivtv-tune executed by a script that is run by an application to tune
channels.  I happened to notice that if I closed mplayer and used
ivtv-tune to tune to another channel and then open my USB TV device,
it would be tuned to that channel.

Andy:

I too care about the environment.  I am trying to find some extra time
to figure out if my KWorld 330U USB TV devices are actually going into
low power mode or not.  I would say not as they get really hot, so I
unplug them when I am not using them.  I told Devin I would work on
this and I have an accurate analog amp meter, but I got very busy at
work and at home with the kids.  However, I don't believe that the
answer is to disable power management as some of these parts get so
hot that leaving them in a powered state and tuned to a channel will
probably damage the device.  Remember, these are silicon tuners, not
the old discrete tuners that have way more surface area to dissipate
heat.

Devin:

Great job answering questions as usual.  ;-)

Best Regards,

-- 
Rob Krakora
Senior Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax
