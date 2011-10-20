Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35096 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab1JTKxM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 06:53:12 -0400
Received: by iaek3 with SMTP id k3so3280876iae.19
        for <linux-media@vger.kernel.org>; Thu, 20 Oct 2011 03:53:12 -0700 (PDT)
Message-ID: <4E9FFD92.902@gmail.com>
Date: Thu, 20 Oct 2011 05:53:06 -0500
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Staging questions: WAS Re: [PATCH 0/7] Staging submission: PCTV
 74e drivers and some cleanup
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E99F2F6.9000307@poczta.onet.pl> <20111017223136.GA20939@kroah.com> <4E9EC441.4090400@gmail.com> <CAGoCfizK7ZqrKuU+wO6UzsvGGO3w7LESGLpg9ijr1FUHgjr++w@mail.gmail.com> <4E9F991F.8070504@redhat.com>
In-Reply-To: <4E9F991F.8070504@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for the suggestions (both of you).  I'll submit a pull request
by this weekend (as I want to test it again in Ubuntu 11.10 just to make
sure everything works).  And for Mauro, is there a direct link to the
scripts? I looked for them after the last time I emailed, but couldn't
find them (or I wasn't looking in the right place).

Have a great day:)
Patrick.

On 10/19/2011 10:44 PM, Mauro Carvalho Chehab wrote:
> Em 19-10-2011 11:57, Devin Heitmueller escreveu:
>> Hi Patrick,
>>
>> On Wed, Oct 19, 2011 at 8:36 AM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
>>> I'm posting this question under this thread because the subject pertains
>>> to the question (in that I'm asking about staging and about the PCTV 80e
>>> drivers).
>>
>> You should definitely be looking at the "as102" thread that is
>> currently going on this mailing list.  Piotr is actually going through
>> the same process as you are (he is working on upstreaming the as102
>> driver from a kernellabs.com tree).  He made some pretty common
>> mistakes (all perfectly understandable), and your reading the thread
>> might help you avoid them (and having to redo your patch series).
>>
>>> I started cleaning up the drx39xx* drivers for the PCTV-80e and have
>>> them in a github repository. Ultimately I want to send a pull request,
>>> so other people can finish the cleaning (as I'm not comfortable with
>>> pulling out the #ifdef statements myself).
>>
>> You should definitely ask Mauro how he expects to do a staging driver
>> for a demodulator before you do any further work.  The staging tree
>> works well for bridge drivers, but demod drivers such as the drx
>> require code in the bridge driver (the em28xx in this case), so it's
>> not clear how you would do staging for a product where the bridge
>> driver isn't in staging as well.  The answer to that question will
>> likely guide you in how to get the driver into staging.
> 
> Ah yes, good point. Well, just submit it as if it should be added at
> the right place, but putting the Kconfig changes in separate. If this
> driver is not that different than the other drx drivers, I may try to
> find some time to fix it on the same way.
> 
> You may also take a look at the history for the drx-k merging patches.
> I basically wrote a few small perl scripts to correct coding style, and
> a few manual work.
> 
>>
>> If you have specific questions regarding anything you see in the
>> driver, let me know.  I don't have much time nowadays but will find
>> the time if you ask concise questions.
>>
>> Good luck.  It will be great to finally see this merged upstream.
>>
>> Devin
>>
> 

