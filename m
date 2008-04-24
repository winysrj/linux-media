Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OF6hTm015372
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 11:06:43 -0400
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OF6TeV032544
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 11:06:29 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZU00FK94MNWB20@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Thu, 24 Apr 2008 11:06:24 -0400 (EDT)
Date: Thu, 24 Apr 2008 11:06:23 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <37219a840804240740n67e99cu8dd03062a4acd125@mail.gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-id: <4810A1EF.7030405@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <8CA703CA994FDB6-D6C-ADB@webmail-me16.sysops.aol.com>
	<20080422040728.GD24855@plankton.ifup.org>
	<8CA7307126F01E0-1644-3A1B@webmail-de04.sysops.aol.com>
	<20080423200134.GJ6703@plankton.ifup.org>
	<480FA22D.7010507@linuxtv.org>
	<8CA7429B5FF15EF-9C8-FC@mblk-d14.sysops.aol.com>
	<8CA742F34634D33-9C8-48F@mblk-d14.sysops.aol.com>
	<37219a840804240740n67e99cu8dd03062a4acd125@mail.gmail.com>
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

Michael Krufky wrote:
> On Thu, Apr 24, 2008 at 10:32 AM, Jon Lowe <jonlowe@aol.com> wrote:
>> While not exactly the same, this bug MAY be related to my hot swap poblem:
>>  https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/12519
> 
> No relation.  Also, we're in 2.6.26 development, most 2.6.15 bugs are
> entirely irrelevant.
> 
> The problem is PCIe hotplugging  -- it doesn't work in Linux, at
> least, not with Expresscards.  This issue is not specific to the
> HVR1500 -- you'll see it on other similar Expresscards as well.

Good, that's my suspicion hence I asked for the test without the driver 
present.

I have no ability to test that on my hardware.

> 
> I can only get the HVR1500 / HVR1500Q / HVR1400 to come up properly if
> it is installed in the system when I boot up the PC.  Inserting it
> after boot does absolutely nothing, and removing it after you booted
> the system with it installed will leave the system unstable.
> 
> I added cc to Greg KH -- maybe he can point us in a better direction about this.

Great, thanks.

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
