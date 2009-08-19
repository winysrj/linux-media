Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7JJ0b0Y014189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Wed, 19 Aug 2009 15:00:37 -0400
Received: from mail-yx0-f202.google.com (mail-yx0-f202.google.com
	[209.85.210.202])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7JJ0NK7028861
	for <video4linux-list@redhat.com>; Wed, 19 Aug 2009 15:00:23 -0400
Received: by yxe40 with SMTP id 40so6069161yxe.23
	for <video4linux-list@redhat.com>; Wed, 19 Aug 2009 12:00:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8C448F.5020203@tmr.com>
References: <4A7B2BDB.5000906@tmr.com>
	<829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>
	<4A7B37F9.8070905@tmr.com>
	<829197380908061318x5ee6ccfbn5d8890e98b6f6325@mail.gmail.com>
	<4A81AC59.5020306@tmr.com>
	<829197380908111051v3e446534k73ae23883c510e65@mail.gmail.com>
	<4A8C448F.5020203@tmr.com>
Date: Wed, 19 Aug 2009 15:00:22 -0400
Message-ID: <829197380908191200u147b4c39r281e642e3ca05a7c@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bill Davidsen <davidsen@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux M/L <video4linux-list@redhat.com>
Subject: Re: Is there any working video capture card which works and is
	still made?
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

On Wed, Aug 19, 2009 at 2:29 PM, Bill Davidsen<davidsen@tmr.com> wrote:
> No, it was actually a clue, but everyone assumed it was just a failure to
> give details. Today I found (looking for something else) that the issue
> seems to be with the recent Fedora PAE kernels, both F11 release and the F12
> pre-release on rawhide. Using a non-PAE kernel causes the cards and dongles
> to suddenly show video instead of "no signal." Of course I lose most of my
> RAM with that setup, not a happy situation.

Interesting.  I am not sure how much testing is done with PAE kernels.
 Can you elaborate as to which cards started working as a result of
switching to the non-PAE kernel, as this might help us narrow down
whether the problem is with a specific driver or with the v4l2
framework code shared by all the drivers?

> The ATI HDTV Wonder now gets signal for the NTSC channels, but no sound. I
> think I need to find an app which can use the digital sound, or populate the
> header for a cable similar to that used by a CD analog feed.

See the previous email I sent in regards to this.   The apps typically
don't know how to find the audio device on raw video capture products.

>> You only need to tune to something specifying MHz if you are using the
>> command line tools.  The GUI applications have built in mechanisms to
>> change channels.
>>
> Can you name "the GUI applications" since none of the ones I've found which
> even claim to work with digital has a functional tuner. Note, there is a bug
> in the Intel video driver, I can't use xine, if that's the only one, it
> kills X on start every time, although I'm assured it will be fixed.

This depends on what you mean by "digital".  If when you say
"digital", you mean ATSC/QAM, then I can tell you that most of the
apps out there are designed for either analog or digital but not both.
 Mplayer and MythTV do support both ATSC/QAM as well as analog.  Apps
like tvtime only support analog.

>> I agree that there is plenty of room for improvement in the
>> application space.  Feel free to roll up your sleeves and help out
>> (that's how I got involved in the project, after all).  Given the
>> number of devices people are demanding support for, we are quite
>> understaffed and could use all the help we could get.
>>
> Rather than a new device (the HVR-2500 would have been nice) I'd like to
> find something which works now and is still made.

I was referring to the state of the various analog applications as
opposed to the device driver support.  Most of the drivers themselves
are fine but the usability of the applications makes it a rather high
barrier to entry for inexperienced users.  I certainly had similar
frustrations when I was tried to watch TV with my first tuner.

I assumed you were referring to the HVR-2250 when you said "HVR-2500".
 Note that the 2250 does not have any analog support at all in the
Linux driver (in case you felt inclined to pick one up and were
expecting it to work).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
