Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n92IGA2q014589
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 14:16:10 -0400
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n92IFr6J028518
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 14:15:56 -0400
Received: from partygirl.tmr.com (partygirl.tmr.com [127.0.0.1])
	by partygirl.tmr.com (8.14.2/8.14.2) with ESMTP id n92IFq4Q024651
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 14:15:53 -0400
Message-ID: <4AC64358.3010200@tmr.com>
Date: Fri, 02 Oct 2009 14:15:52 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: video4linux M/L <video4linux-list@redhat.com>
References: <4AC5FA6E.2000201@tmr.com>
	<829197380910020940o599f5678t60abb2b2da6f8d46@mail.gmail.com>
In-Reply-To: <829197380910020940o599f5678t60abb2b2da6f8d46@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Upgrading from FC4 to current Linux
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
> On Fri, Oct 2, 2009 at 9:04 AM, Bill Davidsen <davidsen@tmr.com> wrote:
>> I am looking for a video solution which works on recent Linux, like
>> Fedora-11. Video used to be easy, plug in the capture device, install xawtv
>> via rpm, and use. However, recent versions of Fedora simply don't work, even
>> on the same hardware, due to /dev/dsp no longer being created and the
>> applications like xawtv or tvtime still looking for it.
>>
>> The people who will be using this are looking for hardware which is still
>> made and sold new, and software which can be installed by a support person
>> who can plug in cards (PCI preferred) or USB devices, and install rpms. I
>> maintain the servers on Linux there, desktop support is unpaid (meaning I
>> want a solution they can use themselves).
>>
>> We looked at vlc, which seems to want channel frequencies in kHz rather than
>> channels, mythtv, which requires a database their tech isn't able (or
>> willing) to support, etc.
>>
>> It seems that video has gone from "easy as Windows" 3-4 years ago to
>> "insanely complex" according to to one person in that group who wanted an
>> upgrade on his laptop. There is some pressure from Windows users to mandate
>> Win7 as the desktop, which Linux users are rejecting.
>>
>> The local cable is a mix of analog channels (for old TVs) and clear qam. The
>> capture feeds from the monitor system are either S-video or three wire
>> composite plus L-R audio. Any reasonable combination of cards (PCI best,
>> PCIe acceptable), USB device, and application which can monitor/record would
>> be fine, but the users are not going to type in kHz values, create channel
>> tables, etc. They want something as easy to use as five years ago.
>>
>> Any thoughts?
>>
>> --
>> Bill Davidsen <davidsen@tmr.com>
>>  "We have more to fear from the bungling of the incompetent than from
>> the machinations of the wicked."  - from Slashdot
> 
> I took a few minutes and put together a response to your email,
> outlining the issues.  Feel free to check it out here:
> 
> http://www.kernellabs.com/blog/
> 
I fear you are concentrating on the analog which is only a discussion of where 
things were when there was support. But since you didn't offer any suggestions 
for some user-friendly app I could give users, and I haven't found any, I have 
to assume that the tools which I did find, all requiring a significant user 
expertise to install, configure, and use, are all that's available any more. 
Perhaps the days of the Linux desktop are over, at least for people who want to 
install and have it work.

I guess staying with FC4 or going Windows are the only options for users who 
want something easy to use, thanks for assuring me that I didn't miss something.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
