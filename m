Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15E2QMx018738
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 09:02:26 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m15E1xWC017169
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 09:01:59 -0500
Date: Tue, 5 Feb 2008 12:01:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080205120102.76ccd526@gaivota>
In-Reply-To: <47A86350.9090205@linuxtv.org>
References: <20080205012451.GA31004@plankton.ifup.org>
	<47A86350.9090205@linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: NACK NACK!  [PATCH] Add two new fourcc codes for 16bpp formats
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

On Tue, 05 Feb 2008 08:23:28 -0500
Michael Krufky <mkrufky@linuxtv.org> wrote:

> Brandon Philips wrote:
> > - mailimport changes in this commit too!  Why is mailimport running
> >   sudo!?! 
> 
> I understand that unrelated changes were accidentally merged with a single commit, but why would we want this script to call sudo in the first place?
> 
> I think it's bad practice, for such a script to execute commands as root -- 
> 
> Can you explain, Mauro?

The script itself doesn't open any new vulnerabilities. Sudo only works if 
configured at /etc/sudoers.

This is needed for the script to work on certain configurations. 
Some emailers marks mailboxes and messages with "og-rw" permissions.
This means that other users can't access. If someone uses a different user
account for V4L/DVB development/testing, permissions should be changed, when
applying a patch series received by email.

Of course, this will only work if:

1) the user of the second account has sudo rights;

2) the user of the second account types his password (or, otherwise, sudo is
configured to not ask for passwords - on very weak environments).

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
