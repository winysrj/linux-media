Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m217jwMc003949
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 02:45:58 -0500
Received: from QMTA03.emeryville.ca.mail.comcast.net
	(qmta03.emeryville.ca.mail.comcast.net [76.96.30.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m217jO8L030306
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 02:45:24 -0500
Message-ID: <47C90994.8040304@personnelware.com>
Date: Sat, 01 Mar 2008 01:45:24 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: v4l2 api compliance test
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

I am using my current problem as a reason to improve the overall v4l2 
development process.  So if it seems overkill for my problem, it might be.  But 
before I go putting effort into fixing what is there, I better make sure it 
doesn't already exist somewhere else.

Background on my problem:

I am helping debug a v4l2 driver, which really means report bugs about it.  My 
ultimate goal is to use it with transcode's import_v4l2 module, but that needs 
some work too.

Reporting bugs on the driver is a bit frustrating because we don't have a stable 
test platform.  I thought had found here:
http://www.video4linux.org/browser/v4l2-apps/test/
But after spending the day with those apps, I am not sure how to apply them to 
testing the driver and get useful tests.

I think a README should be in this dir, and mention vivi, the test driver.  it 
is the obvious counterpart for developing tests.  So that is my current focus: 
get a test app that will run against vivi and give expected results.

Here is what I found from the various apps int he test dir:

driver-test doesn't do much.  I am hoping to replace it.

ioctl-test looks pretty good for what it is, but could use a little work on 
making the results easier to understand.

In documenting the tests, something just caused my test box to go to sleep.
[ 2067.460263] vivi/0: [d6cb2180/4] timeout
[ 2067.460267] vivi/0: [d6cb2480/5] timeout
[ 2215.838800] vivi: open called (minor=0)
[ 2388.964289] vivi: open called (minor=0)
[ 2477.927340] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
[ 2480.753620] Syncing filesystems ... done.
[ 2480.753887] PM: Preparing system for mem sleep
[ 2480.754414] Freezing user space processes ... (elapsed 0.03 seconds) done.
[ 2480.792622] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[ 2480.792745] PM: Entering mem sleep
[ 2480.792750] Suspending console(s)

That was freaky.  Hopefully I'll figure out how that happened and report it.

v4l-info
...
         fmt.pix.colorspace      : unknown

Which may explain why ./pixfmt-test doesn't find any supported formats.

./vbi-test
V4L2 call: ret=-1: sampling_rate=0, samples_per_line=0, sample_format=0, 
offset=0, start=0/0, count=0/0
good?

lib$ vim v4l2_driver.c
This seems to have 1/2 the code I need.  a main with some command line parameter 
support, spin though the cap.capabilities, make sure the ones that are supported 
  don't error, and maybe make sure the ones that aren't do.

So, before I go any further,  comments?

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
