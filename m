Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA1EZQOJ014027
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 10:35:26 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA1EZEZB023996
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 10:35:14 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200811011505.51716.hverkuil@xs4all.nl>
References: <200811011505.51716.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 10:36:02 -0400
Message-Id: <1225550162.3129.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: em28xx <em28xx@mcentral.de>, linux-dvb@linuxtv.org,
	v4l <video4linux-list@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
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

On Sat, 2008-11-01 at 15:05 +0100, Hans Verkuil wrote:

> Hi Markus,
> 
> As promised I've done a review of your empia driver and looked at what 
> needs to be done to get it into the kernel.
> 
> First of all, I've no doubt that your empia driver is better and 
> supports more devices than the current em28xx driver. I also have no 
> problem adding your driver separate from the current driver. It's been 
> done before (certain networking drivers spring to mind) and while 
> obviously not ideal I expect that the older em28xx driver can probably 
> be removed after a year or something like that.

[snip]

> So my recommendation would be to:

[snip]

> 3) Switch to video_ioctl2 in the empia driver. You can do that, but we 
> can probably find a volunteer as well.
> 
> 4) Conform the code to the coding style. If several people can help with 
> this we can get it done pretty quickly.

I can support these two portions of the effort, if what Hans' proposes
is the agreed plan.

Point me to the target directories in the repo, and suggest desired
completion dates for whatever tasks.

Standing by...

Regards,
Andy


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
