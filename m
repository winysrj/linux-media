Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DFujsn003082
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 11:56:46 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2DFu2kg015123
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 11:56:02 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: hermann pitton <hermann-pitton@arcor.de>
Date: Thu, 13 Mar 2008 16:55:45 +0100
References: <47C40563.5000702@claranet.fr> <200803111839.01690.zzam@gentoo.org>
	<1205281560.5927.119.camel@pc08.localdom.local>
In-Reply-To: <1205281560.5927.119.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200803131655.46384.zzam@gentoo.org>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, g.liakhovetski@pengutronix.de,
	Brandon Philips <bphilips@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: kernel oops since changeset e3b8fb8cc214
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

On Mittwoch, 12. März 2008, hermann pitton wrote:
>
> Hi Matthias,
>
> since I know you are active also on saa713x devices,
> have you seen it there, on 32 or 64bit ?
>
I do work on a driver for avermedia A700 based on saa7134 chip.
There I did not notice this oops on my 32bit system.

> It seems to be restricted to cx88 and risc memory there for now?

No idea about internals of cx88, sorry.

Regards
Matthias

-- 
Matthias Schwarzott (zzam)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
