Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54343 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab0BPK62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 05:58:28 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1NhL8N-0008Km-1z
	for linux-media@vger.kernel.org; Tue, 16 Feb 2010 11:58:27 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 11:58:27 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 11:58:27 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Re: tw68: Congratulations :-) and possible vsync problem :-(
Date: Tue, 16 Feb 2010 11:58:01 +0100
Message-ID: <hldtno$41u$1@ger.gmane.org>
References: <hldpqq$nfn$1@ger.gmane.org> <hldrkq$t7v$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for spamming this :-)

The problem is not solved. Now that I tested all possible normid settings, 
it became clear that it only occurs if I have the correct cropping.

With the PAL and SECAM settings, I get correct cropping, but the vsync 
problem in case of high cpu load. With NTSC settings I get wrong cropping 
(missing bottom lines), but no vsync problems.

If I switch my video cam from PAL to NTSC output, I also get vsync problems 
with NTSC normids.

It seems that the driver misses the vsync somehow if it went down correctly 
till the last horizontal line and if there is high CPU load.

Michael

Michael wrote:

> Wow things are really moving fast here.
> 
> This morning there was a commit in git, which actually eliminates the
> below mentioned problem.
> 
> It, however, introduced another small problem. The pictures is wrongly
> cropped. There is the lower part missing (roughly 150-200 lines).
> 
> With the last version, I had the same problem, but was able to get the
> full picture with the option "normid=3". This is no longer working.
> 
> Otherwise, great work!
> 
> Michael
> 
> 
> Michael wrote:
> 
>> Hello
>> 
>> I have tested a TW6805 based mini-pci card with the new tw68-v2 driver
>> from git (22 January 2010).
>> 
>> First of all: Congratulations! It is really working great.
>> 
>> However, I noticed some frame errors here and then. It is not easy to
>> identify what the reason is. It looks a bit like a buffer problem as it
>> happens more often, if there is some load on the system.
>> 
>> Here is a simple way how I can reproduce the frame errors:
>> 
>> mplayer -framedrop -fs -vo x11 tv:// -tv
>> device=/dev/video0:width=640:height=480:normid=3
>> 
>> With this command, cpu load goes to 100% on my low powered geode system.
>> The frame errors are very obvious. It looks like a vsync problem as the
>> wrong frames always start somewhere in the middle. There is no horizontal
>> shift visible.
>> 
>> Reducing the image size:
>> 
>> mplayer -framedrop -fs -vo x11 tv:// -tv
>> device=/dev/video0:width=320:height=240:normid=3
>> 
>> gives a drop in CPU load to 13%. No more frame errors.
>> 
>> Also using hardware accelerated video playback (xv) reduces CPU load to
>> some 20% and removes the frame errors:
>> 
>> mplayer -framedrop -fs -vo xv tv:// -tv
>> device=/dev/video0:width=640:height=480:normid=3
>> 
>> Still, even here, occasionally there are some frame errors, depending on
>> what happens on the system. These can be induced as follows. Using this
>> program:
>> 
>> mkfifo /tmp/mp
>> mplayer -framedrop -fs -vf screenshot -vo xv tv:// -tv
>> device=/dev/video0:normid=3 -slave -input file=/tmp/mp </dev/null
>> >/dev/null
>> 
>> When this test prog runs, you can issue commands to mplayer, e.g.
>> 
>> echo pause > /tmp/mp
>> 
>> This pauses mplayer. A second
>> 
>> echo pause > /tmp/mp
>> 
>> starts mplayer again. Here the first frame shows the error.
>> 
>> The same happens if you issue:
>> 
>> echo screenshot 0 > /tmp/mp
>> 
>> This captures a screenshot and saves it into the current pwd. Again, when
>> mplayer takes the shot, there comes one error frame (probably also wrong
>> vsync).
>> 
>> 
>> Btw. using instead a bttv based card all these tests run without frame
>> errors.
>> 
>> Does this information help to identify and remove the bug?
>> 
>> Best regards
>> 
>> Michael


