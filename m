Return-path: <linux-media-owner@vger.kernel.org>
Received: from bbrack.org ([66.126.51.1]:34975 "EHLO bbrack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0BQQom (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 11:44:42 -0500
Received: from delightful.com.hk (localhost.localdomain [127.0.0.1])
	by bbrack.org (8.14.3/8.14.2) with ESMTP id o1HGbY1T015386
	for <linux-media@vger.kernel.org>; Wed, 17 Feb 2010 08:37:35 -0800
Message-ID: <1e11a4aae8eb2fdee838fe0991bb8d7c.squirrel@delightful.com.hk>
In-Reply-To: <hldtno$41u$1@ger.gmane.org>
References: <hldpqq$nfn$1@ger.gmane.org> <hldrkq$t7v$1@ger.gmane.org>
    <hldtno$41u$1@ger.gmane.org>
Date: Wed, 17 Feb 2010 08:37:35 -0800
Subject: Re: tw68: Congratulations :-) and possible vsync problem :-(
From: "William M. Brack" <wbrack@mmm.com.hk>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has not yet been submitted for review by members of the
linux-media list (although it most certainly will be in the future). I
greatly appreciate this report (and would also welcome any others),
but I don't want to spend much time here responding to it. Reports
sent to me by direct email are also welcome.

The problem is basically caused by an overload of your CPU - it
doesn't have enough power to handle the processing of the video stream
the application has asked for. I'm able to run all of your examples on
my development machine (an Intel i7a with 4gb) with no problems at
all. That said, it is also true that the driver should do a better job
of assuring the buffer stream being sent to the application is correct
and consistent. I can reproduce the problem on relatively slow systems
(an AMD Duron and a Pentium4, each with 256mb), and will try to
improve the driver's behaviour.

Thanks for the report!

Bill
TW68 developer

Michael wrote:
> Sorry for spamming this :-)
>
> The problem is not solved. Now that I tested all possible normid
> settings,
> it became clear that it only occurs if I have the correct cropping.
>
> With the PAL and SECAM settings, I get correct cropping, but the vsync
> problem in case of high cpu load. With NTSC settings I get wrong
> cropping
> (missing bottom lines), but no vsync problems.
>
> If I switch my video cam from PAL to NTSC output, I also get vsync
> problems
> with NTSC normids.
>
> It seems that the driver misses the vsync somehow if it went down
> correctly
> till the last horizontal line and if there is high CPU load.
>
> Michael
>
> Michael wrote:
>
>> Wow things are really moving fast here.
>>
>> This morning there was a commit in git, which actually eliminates
>> the
>> below mentioned problem.
>>
>> It, however, introduced another small problem. The pictures is
>> wrongly
>> cropped. There is the lower part missing (roughly 150-200 lines).
>>
>> With the last version, I had the same problem, but was able to get
>> the
>> full picture with the option "normid=3". This is no longer working.
>>
>> Otherwise, great work!
>>
>> Michael
>>
>>
>> Michael wrote:
>>
>>> Hello
>>>
>>> I have tested a TW6805 based mini-pci card with the new tw68-v2
>>> driver
>>> from git (22 January 2010).
>>>
>>> First of all: Congratulations! It is really working great.
>>>
>>> However, I noticed some frame errors here and then. It is not easy
>>> to
>>> identify what the reason is. It looks a bit like a buffer problem
>>> as it
>>> happens more often, if there is some load on the system.
>>>
>>> Here is a simple way how I can reproduce the frame errors:
>>>
>>> mplayer -framedrop -fs -vo x11 tv:// -tv
>>> device=/dev/video0:width=640:height=480:normid=3
>>>
>>> With this command, cpu load goes to 100% on my low powered geode
>>> system.
>>> The frame errors are very obvious. It looks like a vsync problem as
>>> the
>>> wrong frames always start somewhere in the middle. There is no
>>> horizontal
>>> shift visible.
>>>
>>> Reducing the image size:
>>>
>>> mplayer -framedrop -fs -vo x11 tv:// -tv
>>> device=/dev/video0:width=320:height=240:normid=3
>>>
>>> gives a drop in CPU load to 13%. No more frame errors.
>>>
>>> Also using hardware accelerated video playback (xv) reduces CPU
>>> load to
>>> some 20% and removes the frame errors:
>>>
>>> mplayer -framedrop -fs -vo xv tv:// -tv
>>> device=/dev/video0:width=640:height=480:normid=3
>>>
>>> Still, even here, occasionally there are some frame errors,
>>> depending on
>>> what happens on the system. These can be induced as follows. Using
>>> this
>>> program:
>>>
>>> mkfifo /tmp/mp
>>> mplayer -framedrop -fs -vf screenshot -vo xv tv:// -tv
>>> device=/dev/video0:normid=3 -slave -input file=/tmp/mp </dev/null
>>> >/dev/null
>>>
>>> When this test prog runs, you can issue commands to mplayer, e.g.
>>>
>>> echo pause > /tmp/mp
>>>
>>> This pauses mplayer. A second
>>>
>>> echo pause > /tmp/mp
>>>
>>> starts mplayer again. Here the first frame shows the error.
>>>
>>> The same happens if you issue:
>>>
>>> echo screenshot 0 > /tmp/mp
>>>
>>> This captures a screenshot and saves it into the current pwd.
>>> Again, when
>>> mplayer takes the shot, there comes one error frame (probably also
>>> wrong
>>> vsync).
>>>
>>>
>>> Btw. using instead a bttv based card all these tests run without
>>> frame
>>> errors.
>>>
>>> Does this information help to identify and remove the bug?
>>>
>>> Best regards
>>>
>>> Michael
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


