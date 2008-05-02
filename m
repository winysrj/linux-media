Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42F1K5Z015385
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 11:01:20 -0400
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42F0pwr030737
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 11:00:51 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K0800CH9XP2VZ90@mta5.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Fri, 02 May 2008 11:00:41 -0400 (EDT)
Date: Fri, 02 May 2008 11:00:38 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <481B1027.1040002@linuxtv.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-id: <481B2C96.2050109@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <481B1027.1040002@linuxtv.org>
Cc: Steven Toth <stoth@hauppauge.com>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: cx18-0: ioremap failed, perhaps increasing __VMALLOC_RESERVE in
 page.h
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
> I had this issue before dtv support was properly added to the cx18 driver.

The DTV disabling is a red herring.

> 
> With digital working fine, the issue had disappeared.
> 
> Now, using cx18 in the master branch, whose dtv side is crippled due to
> lack of the mxl driver, the error is back.

Try the hg/~stoth/merge tree, with the feature re-enabled and the newer 
mxl5005 driver. Does this help?

> 
> The cx18 driver can be loaded on my system once.  If I unload it, then I
> get this every time I try to modprobe it again.

I can't repro the issue, but the unwind code (at least at first glance) 
looked OK to me.

Hans or Andy should comment on this, it's really their code.

...

Regards,

Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
