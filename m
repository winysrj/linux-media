Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n88ISgU9001192
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 14:28:42 -0400
Received: from vms173013pub.verizon.net (vms173013pub.verizon.net
	[206.46.173.13])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n88ISTxf024684
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 14:28:29 -0400
Received: from coyote.coyote.den ([141.153.113.94]) by vms173013.mailsrvcs.net
	(Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008;
	32bit)) with ESMTPA id <0KPO003B60MUJD10@vms173013.mailsrvcs.net> for
	video4linux-list@redhat.com; Tue, 08 Sep 2009 13:28:06 -0500 (CDT)
From: Gene Heskett <gene.heskett@verizon.net>
To: video4linux-list@redhat.com
Date: Tue, 08 Sep 2009 14:28:05 -0400
References: <alpine.LRH.2.00.0909081237170.4833@rray2>
In-reply-to: <alpine.LRH.2.00.0909081237170.4833@rray2>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Message-id: <200909081428.05635.gene.heskett@verizon.net>
Subject: Re: NTSC/ATSC device recommendation
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

On Tuesday 08 September 2009, rray_1@comcast.net wrote:
>I would like to purchase a NTSC/ATSC device that is functional under Linux
>MY only requirement is receiving FTA broadcast
>Would y'all recommend a USB device or better to stick with a pci device
>I have followed this list and have only become more confused

I have been using a 'pcHDTV-3000' card for 3 or so years, works most of the 
time here, and I'm definitely 'fringe' area for some of the stations I get. 
One (PBS, my fav) is nearly 70 air miles.

This has been replaced by the 'pcHDTV-5500' card I believe, google for it.  
Mine is regular pci, the newer one may be pci-e.
Mine also doesn't recognize the broadcast flag, I can't say for the newer 
one.

Software in linux to support tv in general sucks.  You must build the latest 
kaffeine to get it to sort of work with digital.  Because I have more than 
one sound system here, mythtv has great video but no sound, and as near as I 
can tell, no facility to make sure its using the right mixer.

tvtime, for NTSC, Just Works(TM) but the author has not to my knowledge, made 
any motions toward ATSC support.  Unforch, here in the states, NTSC is 
deprecated by FCC edict.

If you get the card, be sure and get the firmware that goes with it, 
available freely on their site.

>Thanks
>Richard
>
>--
>video4linux-list mailing list
>Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>https://www.redhat.com/mailman/listinfo/video4linux-list


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

The more laws and order are made prominent, the more thieves and
robbers there will be.
		-- Lao Tsu

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
