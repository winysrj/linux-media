Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3UEDIPR022855
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 10:13:18 -0400
Received: from portal.bppiac.hu (portal.bppiac.hu [213.253.216.130])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3UEChtK027836
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 10:12:44 -0400
Message-ID: <48187E5A.6040008@bppiac.hu>
Date: Wed, 30 Apr 2008 16:12:42 +0200
From: Farkas Levente <lfarkas@bppiac.hu>
MIME-Version: 1.0
To: Farkas Levente <lfarkas@bppiac.hu>, video4linux-list@redhat.com
References: <48185C99.807@bppiac.hu> <20080430135414.GA1198@daniel.bse>
In-Reply-To: <20080430135414.GA1198@daniel.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: [Fwd: [gst-devel] RFC: multi channel frame grabber card support]
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

Daniel Glöckner wrote:
> On Wed, Apr 30, 2008 at 01:48:41PM +0200, Farkas Levente wrote:
>> we'd like to build in this case n pipeline for the n input channel. one
>> of the simple example IVC-100 card which has one bt878 chip and 4
>> composite input and one 4 channel multiplexer.
> 
> Are you familiar with the capabilities of the bt878?
> If not, here is the datasheet:
> http://conexant.com/servlets/DownloadServlet/DSH-200115-001.pdf?docid=116&revid=1

yes.

> You can only capture from one channel at a time.
> So you will get only 6.25 full size PAL frames per second on each
> channel if you use all four channels AND THE CHANNELS ARE SYNCHRONIZED.
> This synchronization can only be done with some cameras.
> If you can't synchronize your framerate will drop even more.
> I don't know if there are additional resynchronization delays if the
> bt878 doesn't detect vertical sync when it is expected.
> 
> The card's driver would have to change all parameters on IRQ.
> Can we guarantee that the interrupt is handled in Linux before the next
> frame starts?
> The "white crush" adaptive algorithm of the chip will result in bad
> pictures if the inputs have completely different white levels. It should
> be disabled.
> 
> If this is to be done, I propose that struct v4l2_buffer should be
> extended to point to the parameters that should be used for the picture.
> 
> How these parameters should be stored is another question..

the bt878 was just one example. but this is one of the basic (and 
cheapest) card. of course there are other card which has more "power" 
but the problem remain the same in all case.
- should we have to create such a kernel driver for _one_ card which has 
_more_ logical/user space device or as the current case _one_ user space 
device?
- if we've _one_ user space device with multiple (4, 8, 16, 24) input 
channel then we should have to create one gstreamer source element with 
multiple pads or one element with one pad, but we can create more such 
elements and they are somehow use the same hardware device?

-- 
   Levente                               "Si vis pacem para bellum!"

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
