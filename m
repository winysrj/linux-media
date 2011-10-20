Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1JTLWf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 07:22:35 -0400
Message-ID: <4EA00477.9030503@redhat.com>
Date: Thu, 20 Oct 2011 09:22:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Dickey <pdickeybeta@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Staging questions: WAS Re: [PATCH 0/7] Staging submission: PCTV
 74e drivers and some cleanup
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E99F2F6.9000307@poczta.onet.pl> <20111017223136.GA20939@kroah.com> <4E9EC441.4090400@gmail.com> <CAGoCfizK7ZqrKuU+wO6UzsvGGO3w7LESGLpg9ijr1FUHgjr++w@mail.gmail.com> <4E9F991F.8070504@redhat.com> <4E9FFD92.902@gmail.com>
In-Reply-To: <4E9FFD92.902@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-10-2011 08:53, Patrick Dickey escreveu:
> Thank you for the suggestions (both of you).  I'll submit a pull request
> by this weekend (as I want to test it again in Ubuntu 11.10 just to make
> sure everything works).  And for Mauro, is there a direct link to the
> scripts? I looked for them after the last time I emailed, but couldn't
> find them (or I wasn't looking in the right place).

Yes, but it is not easy to navigate into it. They were added as comments
at the git history. You can easily get them by using this command:

$ git log drivers/media/dvb/frontends/drxk_hard.c

It basically shows all changes for drxk_hard. Several of the initial changesets
contain the scripts I used to produce the patches.

For example, at changeset ea90f011fdcc3d4fde78532eab8af09637176765 contains one:
	http://git.linuxtv.org/media_tree.git/commitdiff/ea90f011fdcc3d4fde78532eab8af09637176765

That script removes the ugly CHK_ERROR macro that can hide things, as the macro
contains a flow control change inside, and silently touches the status var. 
At the drx drivers I've cleaned up, they used to do something like:

#define CHK_ERROR(s) if ((status = s) < 0) break
...
	int status = 0;
	do {

		CHK_ERROR(Write16_0(state, SIO_CC_PWD_MODE__A,
                                   SIO_CC_PWD_MODE_LEVEL_NONE));
...
	} while (0);

And, inside CHK_ERROR, there was a break if error. 

It is worthy to comment that checkpatch did a very well job pointing this problem:
this only works well if there aren't any loop inside the do. However, I got several 
cases where the above weren't work as expected, as there was an extra loop inside
the do/while.

So, after appling the above change, I had to manually write a patch replacing the
do/while logic with a goto error approach:
	http://git.linuxtv.org/media_tree.git/commitdiff/be44eb283b97c29b06a125cb5527b299d84315f4


So, the above were rewritten as:

	int status = 0;
	status = Write16_0(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_NONE);
	if (status < 0)
		goto error;
...
error:
	return status;


The end result is cleaner, easier to review, and won't contain hidden troubles
due to assumption that all calls to CHK_ERROR macro would happen from a do/while
logic with no extra loop inside.

It should be noticed that I wrote the scripts specifically to replace the bad things
I found at the drx-k driver. They are similar to the ones I wrote for drx-d, but I
had to change some things, as the logic was not identical (and/or because I've improved
the scripts I used for drx-d). In other words, you'll need to verify if they apply for
your drx driver or not, and review the diff patch, to be sure that the patch won't
break anything.

At the end, you'll need to re-test the driver, as you might have added some bad things
at the conversion.

I hope that helps.
> 
> Have a great day:)
> Patrick.
> 
> On 10/19/2011 10:44 PM, Mauro Carvalho Chehab wrote:
>> Em 19-10-2011 11:57, Devin Heitmueller escreveu:
>>> Hi Patrick,
>>>
>>> On Wed, Oct 19, 2011 at 8:36 AM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
>>>> I'm posting this question under this thread because the subject pertains
>>>> to the question (in that I'm asking about staging and about the PCTV 80e
>>>> drivers).
>>>
>>> You should definitely be looking at the "as102" thread that is
>>> currently going on this mailing list.  Piotr is actually going through
>>> the same process as you are (he is working on upstreaming the as102
>>> driver from a kernellabs.com tree).  He made some pretty common
>>> mistakes (all perfectly understandable), and your reading the thread
>>> might help you avoid them (and having to redo your patch series).
>>>
>>>> I started cleaning up the drx39xx* drivers for the PCTV-80e and have
>>>> them in a github repository. Ultimately I want to send a pull request,
>>>> so other people can finish the cleaning (as I'm not comfortable with
>>>> pulling out the #ifdef statements myself).
>>>
>>> You should definitely ask Mauro how he expects to do a staging driver
>>> for a demodulator before you do any further work.  The staging tree
>>> works well for bridge drivers, but demod drivers such as the drx
>>> require code in the bridge driver (the em28xx in this case), so it's
>>> not clear how you would do staging for a product where the bridge
>>> driver isn't in staging as well.  The answer to that question will
>>> likely guide you in how to get the driver into staging.
>>
>> Ah yes, good point. Well, just submit it as if it should be added at
>> the right place, but putting the Kconfig changes in separate. If this
>> driver is not that different than the other drx drivers, I may try to
>> find some time to fix it on the same way.
>>
>> You may also take a look at the history for the drx-k merging patches.
>> I basically wrote a few small perl scripts to correct coding style, and
>> a few manual work.
>>
>>>
>>> If you have specific questions regarding anything you see in the
>>> driver, let me know.  I don't have much time nowadays but will find
>>> the time if you ask concise questions.
>>>
>>> Good luck.  It will be great to finally see this merged upstream.
>>>
>>> Devin
>>>
>>
> 

