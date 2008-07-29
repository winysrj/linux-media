Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TIBH0G010657
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 14:11:17 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TIB5lX013072
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 14:11:05 -0400
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by smtp8-g19.free.fr (Postfix) with ESMTP id B34CD32A836
	for <video4linux-list@redhat.com>;
	Tue, 29 Jul 2008 20:11:01 +0200 (CEST)
Received: from [192.168.0.13] (lns-bzn-45-82-65-147-136.adsl.proxad.net
	[82.65.147.136])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 70D8C32A7D7
	for <video4linux-list@redhat.com>;
	Tue, 29 Jul 2008 20:11:01 +0200 (CEST)
From: Jean-Francois Moine <moinejf@free.fr>
To: video4linux-list@redhat.com
In-Reply-To: <20092.62.70.2.252.1217333416.squirrel@webmail.xs4all.nl>
References: <20092.62.70.2.252.1217333416.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 29 Jul 2008 19:37:13 +0200
Message-Id: <1217353033.1692.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: CONFIG_VIDEO_ADV_DEBUG question
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

On Tue, 2008-07-29 at 14:10 +0200, Hans Verkuil wrote:
> Hans de Goede wrote:
> > CONFIG_VIDEO_ADV_DEBUG enables additional debugging output in the gscpa
> > driver, which then becomes "active" when a module option gets passed. So
> 	[snip]
> But the way gspca uses it is not correct. I would remove the test on
> CONFIG_VIDEO_ADV_DEBUG there altogether, or replace it with a test of a

Hello Hans and Hans,

OK. So I see 3 options:
1) add a new kernel config option, say CONFIG_GSPCA_DEBUG,
2) always set an internal compile option GSPCA_DEBUG,
3) have the option GSPCA_DEBUG, but unset by default.

Which is the best for you, Hans (de Goede)?

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
