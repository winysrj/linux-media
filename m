Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7JITqFu026246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Wed, 19 Aug 2009 14:29:52 -0400
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7JITaGD012811
	for <video4linux-list@redhat.com>; Wed, 19 Aug 2009 14:29:37 -0400
Received: from partygirl.tmr.com (partygirl.tmr.com [127.0.0.1])
	by partygirl.tmr.com (8.14.2/8.14.2) with ESMTP id n7JITZAS005485
	for <video4linux-list@redhat.com>; Wed, 19 Aug 2009 14:29:36 -0400
Message-ID: <4A8C448F.5020203@tmr.com>
Date: Wed, 19 Aug 2009 14:29:35 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: video4linux M/L <video4linux-list@redhat.com>
References: <4A7B2BDB.5000906@tmr.com>	<829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>	<4A7B37F9.8070905@tmr.com>	<829197380908061318x5ee6ccfbn5d8890e98b6f6325@mail.gmail.com>	<4A81AC59.5020306@tmr.com>
	<829197380908111051v3e446534k73ae23883c510e65@mail.gmail.com>
In-Reply-To: <829197380908111051v3e446534k73ae23883c510e65@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Devin Heitmueller wrote:
> On Tue, Aug 11, 2009 at 1:37 PM, Bill Davidsen<davidsen@tmr.com> wrote:
>> Since you quoted the HVR-950Q as working, I tried one of those. Someone else
>> said the ATI HDTV-Wonder works. Neither do. I tried all of the programs
>> people swore work with these cards: tvtime, xawtv, cheese, and vlc. Mythtv
>> appears to need the whole system tuned to be a pvr, not the intent here,
>> users want to monitor CNN, MSNBC, and similar news or financial channels in
>> a window without needing to get a TV for each seat.
> 
> Well since I did the support for the HVR-950Q, I'm pretty sure it
> works. :-)  With regards to the "ATI HDTV-Wonder" card you referred
> to, there are many cards with that name, so you would need to be more
> specific (providing a model number and bus type).  For example, I did
> the work for the "ATI TV Wonder HD 600 USB".  For analog support, both
> of the above cards work fine with tvtime.
> 
> If you have a specific case that is causing you problems, please
> provide details as to exactly which card you are trying to use, which
> distro and application you are using, and what errors you are seeing
> and we will see if we can help you debug your problem.  But saying
> vague things like "nothing works" isn't really a constructive way to
> improve your situation.
> 
No, it was actually a clue, but everyone assumed it was just a failure to give 
details. Today I found (looking for something else) that the issue seems to be 
with the recent Fedora PAE kernels, both F11 release and the F12 pre-release on 
rawhide. Using a non-PAE kernel causes the cards and dongles to suddenly show 
video instead of "no signal." Of course I lose most of my RAM with that setup, 
not a happy situation.

The ATI HDTV Wonder now gets signal for the NTSC channels, but no sound. I think 
I need to find an app which can use the digital sound, or populate the header 
for a cable similar to that used by a CD analog feed.

> You only need to tune to something specifying MHz if you are using the
> command line tools.  The GUI applications have built in mechanisms to
> change channels.
> 
Can you name "the GUI applications" since none of the ones I've found which even 
claim to work with digital has a functional tuner. Note, there is a bug in the 
Intel video driver, I can't use xine, if that's the only one, it kills X on 
start every time, although I'm assured it will be fixed.

> I agree that there is plenty of room for improvement in the
> application space.  Feel free to roll up your sleeves and help out
> (that's how I got involved in the project, after all).  Given the
> number of devices people are demanding support for, we are quite
> understaffed and could use all the help we could get.
> 
Rather than a new device (the HVR-2500 would have been nice) I'd like to find 
something which works now and is still made.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
