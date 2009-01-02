Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n027tmVh011988
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 02:55:48 -0500
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n027suwg011612
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 02:54:57 -0500
Message-ID: <495DC87E.2030007@hhs.nl>
Date: Fri, 02 Jan 2009 08:55:42 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <200901010033.58093.linux@baker-net.org.uk>
	<495CB6D1.8040808@hhs.nl>
	<200901012119.27626.linux@baker-net.org.uk>
	<Pine.LNX.4.64.0901011539120.19217@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0901011539120.19217@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list <video4linux-list@redhat.com>,
	sqcam-devel@lists.sourceforge.net
Subject: Re: [sqcam-devel] [REVIEW] Driver for SQ-905 based cameras
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

kilgota@banach.math.auburn.edu wrote:
> 
> 
> On Thu, 1 Jan 2009, Adam Baker wrote:
> 
>> On Thursday 01 January 2009, Hans de Goede wrote:
> 
>>>
>>> "\x0" will point to const memory, this is not allowed as a buffer 
>>> passed to
>>> usb_control_msg, instead you should use a r/w buffer suitable for DMA.
>>> We've got gspca_dev->usb_buf for this.
> 
> Perhaps my ignorance is showing here. If one actually specifies a value 
> to put into that slot, then why does it "point to const memory" and if 
> so why is that a sin? Sorry if you think this is a dumb question, but I 
> am a bit new to doing this kind of device support at the kernel level. 
> In userspace stuff like libgphoto2 such things are obviously of much 
> less significance.
> 

Well for one const memory is read only and usb_control_msg might try to write 
to it. Another problem is that usb_control_msg() needs a dma-able buffer. In 
kernelspace not all memory is equal. In this case the memory needs to match 
certain alignment criteria and might need to be in a certain physical address 
range (ISA for example can not do dma to physical addresses above 16 megabyte, 
32 bit PCI devices cannot do dma above 4 Gigabyte, etc.).

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
