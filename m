Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o08KOwXS011287
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 15:24:58 -0500
Received: from mail.mnn.org (mail.mnn.org [216.164.83.163])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o08KOk7A018115
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 15:24:47 -0500
Received: from MoreVolts.local (unknown [192.168.2.132])
	by mail.mnn.org (Postfix) with ESMTP id 205BC9C2DE8
	for <video4linux-list@redhat.com>; Fri,  8 Jan 2010 15:24:22 -0500 (EST)
Message-ID: <4B47948E.1070408@mnn.org>
Date: Fri, 08 Jan 2010 15:24:46 -0500
From: Mars Forest <forest@mnn.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Blackmagic SDI card --> v4l2 ready ? 
References: <4B40B9CC.1040108@wp.pl>
	<1262979242.3246.10.camel@pc07.localdom.local>
In-Reply-To: <1262979242.3246.10.camel@pc07.localdom.local>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Just a quick question to see if Blackmagic's SDI card (I just have the 
basic one, not the studio or the extreme) is working under Video4Linux?

I have successfully tested this card using the bundled software (for 
Ubuntu) but I am getting this error when trying to capture from it with 
VLC:

    *[0x2a3e828] v2l2 demux warning: FIXME: v4l2.c ControlListPrint 2738*

cheers,

forest mars
-- 
mnn: you're what's on!
http://mnn.org



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
