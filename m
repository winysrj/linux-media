Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OEehQv023721
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:40:43 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OEeTw8009083
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:40:29 -0400
Received: by an-out-0708.google.com with SMTP id c31so930999ana.124
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 07:40:26 -0700 (PDT)
Message-ID: <37219a840804240740n67e99cu8dd03062a4acd125@mail.gmail.com>
Date: Thu, 24 Apr 2008 10:40:24 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Jon Lowe" <jonlowe@aol.com>
In-Reply-To: <8CA742F34634D33-9C8-48F@mblk-d14.sysops.aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8CA703CA994FDB6-D6C-ADB@webmail-me16.sysops.aol.com>
	<20080422040728.GD24855@plankton.ifup.org>
	<8CA7307126F01E0-1644-3A1B@webmail-de04.sysops.aol.com>
	<20080423200134.GJ6703@plankton.ifup.org>
	<480FA22D.7010507@linuxtv.org>
	<8CA7429B5FF15EF-9C8-FC@mblk-d14.sysops.aol.com>
	<8CA742F34634D33-9C8-48F@mblk-d14.sysops.aol.com>
Cc: Greg K-H <greg@kroah.com>, video4linux-list@redhat.com
Subject: Re: [BUG] HVR-1500 Hot swap causes lockup
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

On Thu, Apr 24, 2008 at 10:32 AM, Jon Lowe <jonlowe@aol.com> wrote:
> While not exactly the same, this bug MAY be related to my hot swap poblem:
>  https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/12519

No relation.  Also, we're in 2.6.26 development, most 2.6.15 bugs are
entirely irrelevant.

The problem is PCIe hotplugging  -- it doesn't work in Linux, at
least, not with Expresscards.  This issue is not specific to the
HVR1500 -- you'll see it on other similar Expresscards as well.

I can only get the HVR1500 / HVR1500Q / HVR1400 to come up properly if
it is installed in the system when I boot up the PC.  Inserting it
after boot does absolutely nothing, and removing it after you booted
the system with it installed will leave the system unstable.

I added cc to Greg KH -- maybe he can point us in a better direction about this.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
