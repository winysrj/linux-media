Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42213 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161383Ab2COUjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 16:39:17 -0400
Received: by vcqp1 with SMTP id p1so3563759vcq.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 13:39:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120315201446.17f21639@ws.the.cage>
References: <20120310142042.0f238d3a@ws.the.cage>
	<20120315201446.17f21639@ws.the.cage>
Date: Thu, 15 Mar 2012 21:39:16 +0100
Message-ID: <CAJ_iqtYvFLYvMe=C_H_MtFFQgEbpQDc3Bi6tOJ5R2DMQQyVcjw@mail.gmail.com>
Subject: Re: cxd2820r: i2c wr failed (PCTV Nanostick 290e)
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thu, Mar 15, 2012 at 9:14 PM, Keith Edmunds <kae@midnighthax.com> wrote:
> I posted the message below last week, but I've had no response.
>
> Is this the wrong list? Did I do something wrong in my posting?
>
> I would like fix this problem, and I have more information now, but I
> don't want to clutter this list if it's the wrong place.
>
> Guidance as to what I should do gratefully received: thanks.

FWIW,
I haven't tested my nanoStick T2 (model 290e) with anything else than
Kaffeine, but it has been running for many days, and I haven't seen
the problem you describe.
I'm using Xubuntu 11.10:
tingo@kg-f4:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 11.10
Release:	11.10
Codename:	oneiric
tingo@kg-f4:~$ uname -a
Linux kg-f4 3.0.0-15-generic #26-Ubuntu SMP Fri Jan 20 17:23:00 UTC
2012 x86_64 x86_64 x86_64 GNU/Linux

and media drivers (from http://git.linuxtv.org/media_build.git) built
on 2012-02-08.

HTH
>
>> Hi List
>>
>> I'm having lots of problems with my PCTV Nanostick 290e under MythTV. Is
>> this the best place to report these problems?
>>
>> I'm happy to provide whatever detail is needed, but in summary:
>>
>>  - every day or two, I get the error messages logged below. I need to
>>    reboot the back end to clear them.
>>
>>  - when the back end comes back up, 'lsusb' doesn't show the 290e. I have
>>    to unplug it, wait a few seconds, then plug it back in again
>>
>> This is extremely frustrating. When it works, it's great; when it
>> doesn't, recordings fail.
>>
>> The following errors are reported repeatedly:
>>
>> Mar  9 10:02:03 woodlands kernel: [ 6006.157991] cxd2820r: i2c wr failed
>> ret:-110 reg:85 len:1
>> Mar  9 10:02:05 woodlands kernel: [ 6008.511994] cxd2820r: i2c wr failed
>> ret:-110 reg:00 len:1
>> Mar  9 10:02:08 woodlands kernel: [ 6011.208909] cxd2820r: i2c wr failed
>> ret:-110 reg:85 len:1
>> Mar 9 10:02:10 woodlands kernel: [ 6013.566440] cxd2820r: i2c wr failed
>> ret:-110 reg:00 len:1
>>
>> MythTV backend details:
>>  - Debian v6.0.4 ("Squeeze")
>>  - Debian multimedia repository
>>  - Myth version 0.24.2-0.0squeeze1 (as packaged by repository)
>>  - Kernel: 2.6.32-5-686-bigmem (I've also tried 3.2.0-0.bpo.1-686-pae,
>>    both Debian-packaged)
>>  - Tuners: 2 x Hauppauge Nova-T Stick (USB) and 1 x PCTV Nanostick 290e
>>    (also USB)
>>  - no module load parameters specified
>>  - tuning delay 750mS for each tuner
>>  - drivers for the 290e built using the media_build scripts
>>    (http://git.linuxtv.org/media_build.git)
>>
>> Many thanks,
>> Keith
>
>
> --
> "You can have everything in life you want if you help enough other people
> get what they want" - Zig Ziglar.
>
> Who did you help today?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Torfinn Ingolfsen
