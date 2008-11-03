Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA33OeFu028880
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 22:24:40 -0500
Received: from QMTA09.westchester.pa.mail.comcast.net
	(qmta09.westchester.pa.mail.comcast.net [76.96.62.96])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA33NlwD001653
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 22:23:47 -0500
Message-ID: <490E6EC3.7030408@personnelware.com>
Date: Sun, 02 Nov 2008 21:23:47 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <47C90994.8040304@personnelware.com>	<20080304113834.0140884d@gaivota>
	<490E468A.6090200@personnelware.com>
	<1225675203.3116.12.camel@palomino.walls.org>
In-Reply-To: <1225675203.3116.12.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
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

Andy Walls wrote:
> On Sun, 2008-11-02 at 18:32 -0600, Carl Karsten wrote:
>> Mauro Carvalho Chehab wrote:
>>> On Sat, 01 Mar 2008 01:45:24 -0600
>>> Carl Karsten <carl@personnelware.com> wrote:
>>>
>>>
>>> Please, feel free to improve the tools. Unfortunately, nobody yet had time to
>>> dedicate on improving the testing tools.
>> These 2 issues are thwarting my efforts to write my tester:
>>
>> 1. memory leak:
>> valgrind ./capture --userp -d /dev/video1
>> ==17153== malloc/free: in use at exit: 2,457,632 bytes in 5 blocks.
>>
>> 2. capabilities mismatch:
>> ./capture --userp -d /dev/video1
>> VIDIOC_QBUF error 22, Invalid argument
>>
>> details: http://linuxtv.org/v4lwiki/index.php/Test_Suite#Bugs_in_Examples
>
> I'm not sure why a memory leak on abnormal termination is worrisome for
> you.  It looks like init_userp() allocated a bunch of "buffers", which
> has to happen for a program to use user pointer mode of v4l2.  The
> function errno_exit() doesn't bother to clean up when the VIDIOC_QBUF
> ioctl() call fails.  free() is only called by uninit_device().  Since
> the alternate flow of the program through errno_exit() to termination
> doesn't call free() on "buffers", you should have a process heap memory
> leak on error exit.
>
> Since this is userspace, a memory leak from the process heap doesn't
> hang around when the process terminates - no big deal.

Are you sure about that?

if I run
./capture --userp -d /dev/video1
VIDIOC_QBUF error 22, Invalid argument

enough I can't run the valid modes:

juser@dhcp186:~/vga2usb/v4l.org/examples$ ./capture --read -d /dev/video1
read error 12, Cannot allocate memory

juser@dhcp186:~/vga2usb/v4l.org/examples$ ./capture --mmap -d /dev/video1
mmap error 12, Cannot allocate memory

although free still shows lots:

juser@dhcp186:~/vga2usb/v4l.org/examples$ free
             total       used       free     shared    buffers     cached
Mem:       1033388     282340     751048          0      31012      98208
-/+ buffers/cache:     153120     880268
Swap:       859436          0     859436


> You could
> equally gripe that the program didn't close it's file descriptors with
> the driver on errno_exit() - but process termination cleans those up
> too.

I am personally interested in anything that makes it harder for me to determine
if a driver is misbehaving.

In addition, I would think that the API's example code should be a squeaky clean
example of how real code should be written, given it is often used as a starting
point.  If problems are identified, they should at least be noted, better yet
removed.

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
