Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA51FlkL024540
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 20:15:47 -0500
Received: from QMTA08.emeryville.ca.mail.comcast.net
	(qmta08.emeryville.ca.mail.comcast.net [76.96.30.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA51FQw4001609
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 20:15:28 -0500
Message-ID: <4910F39E.9060604@personnelware.com>
Date: Tue, 04 Nov 2008 19:15:10 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com
References: <47C90994.8040304@personnelware.com>	<20080304113834.0140884d@gaivota>
	<490E468A.6090200@personnelware.com>	<1225675203.3116.12.camel@palomino.walls.org>	<490E6EC3.7030408@personnelware.com>
	<1225762470.3198.23.camel@palomino.walls.org>
In-Reply-To: <1225762470.3198.23.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: v4l2 api compliance test
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

>>>> details: http://linuxtv.org/v4lwiki/index.php/Test_Suite#Bugs_in_Examples
>>> I'm not sure why a memory leak on abnormal termination is worrisome for
>>> you.  It looks like init_userp() allocated a bunch of "buffers", which
>>> has to happen for a program to use user pointer mode of v4l2.  The
>>> function errno_exit() doesn't bother to clean up when the VIDIOC_QBUF
>>> ioctl() call fails.  free() is only called by uninit_device().  Since
>>> the alternate flow of the program through errno_exit() to termination
>>> doesn't call free() on "buffers", you should have a process heap memory
>>> leak on error exit.
>>>
>>> Since this is userspace, a memory leak from the process heap doesn't
>>> hang around when the process terminates - no big deal.
>> Are you sure about that?
> 
> About the process heap, yes.
> 
>> if I run
>> ./capture --userp -d /dev/video1
>> VIDIOC_QBUF error 22, Invalid argument
>>
>> enough I can't run the valid modes:
>>
>> juser@dhcp186:~/vga2usb/v4l.org/examples$ ./capture --read -d /dev/video1
>> read error 12, Cannot allocate memory
> 
> The capture app would output "Out of memory" if the calloc() call for
> the --read option buffers failed.  This is some global/kernel resource
> that has been exhausted.


> 
> 
>> juser@dhcp186:~/vga2usb/v4l.org/examples$ ./capture --mmap -d /dev/video1
>> mmap error 12, Cannot allocate memory
> 
> Ditto for this.  This message can only happen at the end of init_mmap()
> when the mmap call fails.  Thus an allocation of some sort of kernel
> global resource/space failed.


so more likely a driver problem?

> 
> 
> I don't know what could be exhausting those kernel resources when using
> the userp option.  The failed ioctl()'s calls to the vivi driver would
> be a place to start looking.
> 
> 
>> although free still shows lots:
>>
>> juser@dhcp186:~/vga2usb/v4l.org/examples$ free
>>              total       used       free     shared    buffers     cached
>> Mem:       1033388     282340     751048          0      31012      98208
>> -/+ buffers/cache:     153120     880268
>> Swap:       859436          0     859436
>>
> 
> Perhaps you could look at /proc/meminfo between runs and see if
> something is gradually being exhausted.  Vmalloc address space
> exhaustion is what I'd look for.
> 

I ran this script:

http://linuxtv.org/v4lwiki/index.php/Test_Suite#memory_leak_2

and put all the meminfo's into a spreadsheet:

http://spreadsheets.google.com/ccc?key=pIfz0wOzPtW1-oZkXXbvcLA&hl=en

I don't see any columns growing or shrinking, so not sure what to make of it.

> 
> 
>>> You could
>>> equally gripe that the program didn't close it's file descriptors with
>>> the driver on errno_exit() - but process termination cleans those up
>>> too.
>> I am personally interested in anything that makes it harder for me to determine
>> if a driver is misbehaving.
> 
> Ah, eliminating unknowns.  OK.
> 

bingo.

> 
>> In addition, I would think that the API's example code should be a squeaky clean
>> example of how real code should be written, given it is often used as a starting
>> point.  If problems are identified, they should at least be noted, better yet
>> removed.
> 
> I can't say I disagree. 
> 

so assuming the problem is with capture.c, who do I tell?  (i know where to send
anything else it might be: v4l list.

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
