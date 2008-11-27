Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAR9ZOd6029688
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 04:35:24 -0500
Received: from mgw-mx03.nokia.com (smtp.nokia.com [192.100.122.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAR9ZCGE007807
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 04:35:13 -0500
Message-ID: <492E69C9.9080904@nokia.com>
Date: Thu, 27 Nov 2008 11:35:05 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: ext Trilok Soni <soni.trilok@gmail.com>
References: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>	
	<200811262116.42364.hverkuil@xs4all.nl>
	<5d5443650811262323l759d8c02s835c9a7454508b85@mail.gmail.com>
In-Reply-To: <5d5443650811262323l759d8c02s835c9a7454508b85@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Add OMAP2 camera driver
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

ext Trilok Soni wrote:
> Hi Hans,

Hello, Hans and Soni!

>> 2) The Kconfig is probably missing a ARCH_OMAP dependency (sounds
>> reasonable, at least), so now it also compiles for the i686 but that
>> architecture doesn't have a clk_get function.

It *might* be possible that the same camera block would be used in 
non-OMAP CPUs as well but I guess it is safe to assume that it depends 
on ARCH_OMAP now.

>> 4) I get a bunch of compile warnings (admittedly when compiling for
>> i686) that you might want to look at. Compiled against the 2.6.27
>> kernel with gcc-4.3.1. It might be bogus since I didn't compile for the
>> omap architecture.
> 
> I will update my toolchain to gcc-4.3.x for ARM and see if it
> generates the warnings like below. But I think we are fine once we add
> ARCH_OMAP dependency to this driver.
> 
> Thanks for the review comments. I will resubmit the patch.

Is this exactly the same code that was removed from linux-omap a while ago?

---
commit ebdae9abf598ae8a3ee1c8c477138f82b40e7809
Author: Tony Lindgren <tony@atomide.com>
Date:   Mon Oct 27 13:33:13 2008 -0700

     REMOVE OMAP LEGACY CODE: Delete all old omap specific v4l drivers

     All v4l development must be done on the v4l mailing list with 
linux-omap
     list cc'd.

     Signed-off-by: Tony Lindgren <tony@atomide.com>

---

Although I haven't had time to discuss this anywhere, I though a 
possible reason of for the removal was that some parts of the code are 
not that pretty (e.g. DMA) and those parts should be rewritten.

But yes, the OMAP 2 camera driver does actually work and I would suppose 
it has users, too (think N800/N810).

I'm in if the aim is to get this back to linux-omap. :-) (Waiting for 
the next patch from Trilok.)

Cheers,

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
