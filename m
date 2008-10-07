Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m97GIj7Q023409
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 12:18:45 -0400
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m97GIYms021714
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 12:18:34 -0400
Message-ID: <48EB8BAC.90706@nokia.com>
Date: Tue, 07 Oct 2008 19:17:48 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: ext Hans Verkuil <hverkuil@xs4all.nl>
References: <48E9F178.50507@nokia.com>
	<12232912721943-git-send-email-sakari.ailus@nokia.com>
	<1223291272973-git-send-email-sakari.ailus@nokia.com>
	<200810061838.38551.hverkuil@xs4all.nl>
In-Reply-To: <200810061838.38551.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: vimarsh.zutshi@nokia.com, video4linux-list@redhat.com,
	tuukka.o.toivonen@nokia.com, hnagalla@ti.com
Subject: Re: [PATCH] V4L: Int if: Define new power state changes
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

ext Hans Verkuil wrote:
> Hi Sakari,
> 
> I'm OK with the other changes, but the V4L2_POWER_RESUME command in this 
> patch is still really very ugly. In my opinion you should either let 
> the slave store the old powerstate (this seems to be the more logical 
> approach), or let s_power pass the old powerstate as an extra argument 
> if you think it is really needed. But the RESUME command is just 
> unnecessary. Without the RESUME there is no more need to document 
> anything, since then it is suddenly self-documenting.

Yeah, I agree. I'll remove that and send a new patchset, this time with
git-format-patch -n. :-)

Ps. Last time the first patch got caught by a spam filter and my hunch 
is that it'll happen again.

Regards,

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
