Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA30Wa1b011392
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 19:32:36 -0500
Received: from QMTA09.westchester.pa.mail.comcast.net
	(qmta09.westchester.pa.mail.comcast.net [76.96.62.96])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA30WMIG011778
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 19:32:22 -0500
Message-ID: <490E468A.6090200@personnelware.com>
Date: Sun, 02 Nov 2008 18:32:10 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <47C90994.8040304@personnelware.com>
	<20080304113834.0140884d@gaivota>
In-Reply-To: <20080304113834.0140884d@gaivota>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
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

Mauro Carvalho Chehab wrote:
> On Sat, 01 Mar 2008 01:45:24 -0600
> Carl Karsten <carl@personnelware.com> wrote:
> 
>> Here is what I found from the various apps int he test dir:
>>
>> driver-test doesn't do much.  I am hoping to replace it.
> 
> The idea of this is to check if a driver is compliant with V4L2 specs.
> For example, several webcam drivers returns wrong buffer sizes to userspace.
> This testing program should do some basic configuration of the board and start
> capture, warning about non-compliance.
> 
> This program already warns about some issues, but I didn't have time to finish
> it.
> 
> Ideally, it should implement all ioctls from the API, and test the possible 
> different configuration, helping to stress a driver.
> 
> Some options may be added to it, to select a fast test or a more detailed and
> longer one.
> 
>> ioctl-test looks pretty good for what it is, but could use a little work on 
>> making the results easier to understand.
> 
> This is my first trial on writing a testing code. It just dumbly runs the V4L
> ioctls. Since it doesn't do anything coherent, this may produce weird results
> on real drivers. The debug printk's at the driver may help to see if everything
> is ok.
> 
>> In documenting the tests, something just caused my test box to go to sleep.
>> [ 2067.460263] vivi/0: [d6cb2180/4] timeout
>> [ 2067.460267] vivi/0: [d6cb2480/5] timeout
>> [ 2215.838800] vivi: open called (minor=0)
>> [ 2388.964289] vivi: open called (minor=0)
>> [ 2477.927340] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
>> [ 2480.753620] Syncing filesystems ... done.
>> [ 2480.753887] PM: Preparing system for mem sleep
>> [ 2480.754414] Freezing user space processes ... (elapsed 0.03 seconds) done.
>> [ 2480.792622] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
>> [ 2480.792745] PM: Entering mem sleep
>> [ 2480.792750] Suspending console(s)
>>
>> That was freaky.  Hopefully I'll figure out how that happened and report it.
> 
> This is really weird. vivi doesn't implement any suspend code.
>> v4l-info
>> ...
>>          fmt.pix.colorspace      : unknown
>>
>> Which may explain why ./pixfmt-test doesn't find any supported formats.
> 
> v4l-info uses the old V4L1 API (and V4L2). Maybe, some format were not correctly
> translated by v4l1-compat.
>> ./vbi-test
>> V4L2 call: ret=-1: sampling_rate=0, samples_per_line=0, sample_format=0, 
>> offset=0, start=0/0, count=0/0
>> good?
> 
> vivi doesn't implement vbi. Returning an error seems OK.
> 
>> lib$ vim v4l2_driver.c
>> This seems to have 1/2 the code I need.  a main with some command line parameter 
>> support, spin though the cap.capabilities, make sure the ones that are supported 
>>   don't error, and maybe make sure the ones that aren't do.
>>
>> So, before I go any further,  comments?
> 
> Please, feel free to improve the tools. Unfortunately, nobody yet had time to
> dedicate on improving the testing tools.

These 2 issues are thwarting my efforts to write my tester:

1. memory leak:
valgrind ./capture --userp -d /dev/video1
==17153== malloc/free: in use at exit: 2,457,632 bytes in 5 blocks.

2. capabilities mismatch:
./capture --userp -d /dev/video1
VIDIOC_QBUF error 22, Invalid argument

details: http://linuxtv.org/v4lwiki/index.php/Test_Suite#Bugs_in_Examples

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
