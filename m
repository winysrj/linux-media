Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55065 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab1JSMgV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 08:36:21 -0400
Received: by iaek3 with SMTP id k3so2058219iae.19
        for <linux-media@vger.kernel.org>; Wed, 19 Oct 2011 05:36:19 -0700 (PDT)
Message-ID: <4E9EC441.4090400@gmail.com>
Date: Wed, 19 Oct 2011 07:36:17 -0500
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Staging questions: WAS Re: [PATCH 0/7] Staging submission: PCTV 74e
 drivers and some cleanup
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E99F2F6.9000307@poczta.onet.pl> <20111017223136.GA20939@kroah.com>
In-Reply-To: <20111017223136.GA20939@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm posting this question under this thread because the subject pertains
to the question (in that I'm asking about staging and about the PCTV 80e
drivers).

I started cleaning up the drx39xx* drivers for the PCTV-80e and have
them in a github repository. Ultimately I want to send a pull request,
so other people can finish the cleaning (as I'm not comfortable with
pulling out the #ifdef statements myself).

So my questions are these:

1.  If I move the drx39xx* and associated files into the staging
directory (staging/media/dvb/frontends to be exact), do I simply need to
point to staging/filename for any #include statements (specifically in
the em28xx-dvb.c and em28xx-cards.c files), or do I need to do something
else?

2.  In the Makefile for the frontends, I have the commands to make the
drivers for the drx39xx* files. Do I need to point those to the staging/
directory as well, or do I need to create Makefiles in that directory
for these files?  I ask this because on my system, I wasn't able to
"make" the files when they were in a subdirectory of frontends. I
actually had to move them to the frontends directory and transfer the
commands from the Makefile in the subdirectory to the frontends Makefile.

3.  If I submit a pull request as is right now (where these files will
go into the linux/drivers/media/dvb/frontends directory and the em28xx-*
files will point to those files), will they be pulled in, and someone
will help me to get them in the right places? Or do I need to move them
to staging, reconfigure everything, and then submit the pull request?

Thank you for any help and information, and have a great day:)
Patrick.


On 10/17/2011 05:31 PM, Greg KH wrote:
> On Sat, Oct 15, 2011 at 10:54:14PM +0200, Piotr Chmura wrote:
>> [PATCH 1/7] pull as102 driver fromhttp://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
>> with the only change needed to compile it in git tree[1]: usb_buffer_alloc()
>> to usb_alloc_coherent() and usb_buffer_free() to usb_free_coherent()
>>
>> [PATCH 2/7] as102: add new device nBox DVB-T Dongle
>> adds new device working on this driver
>>
>>
>> Next patches i made basing on Mauro Carvalho Chehab comments from previous pull try [2].
>>
>> [PATCH 3/7] as102: cleanup - get rid off typedefs
>> [PATCH 4/7] as102: cleanup - formatting code
>> [PATCH 5/7] as102: cleanup - set __attribute__(packed) instead of pragma(pack)
>> [PATCH 6/7] as102: cleanup - delete vim comments
>> [PATCH 7/7] as102: cleanup - get rid of unnecessary defines (WIN32, LINUX)
> 
> Mauro, care to take these and move them under your newly-created
> drivers/staging/media/ directory?
> 
> thanks,
> 
> greg k-h

