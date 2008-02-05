Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15DNrFr018042
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 08:23:53 -0500
Received: from host06.hostingexpert.com (host06.hostingexpert.com
	[216.80.70.60])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m15DNWuq026725
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 08:23:32 -0500
Message-ID: <47A86350.9090205@linuxtv.org>
Date: Tue, 05 Feb 2008 08:23:28 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Brandon Philips <brandon@ifup.org>
References: <20080205012451.GA31004@plankton.ifup.org>
In-Reply-To: <20080205012451.GA31004@plankton.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

Brandon Philips wrote:
> - mailimport changes in this commit too!  Why is mailimport running
>   sudo!?! 

I understand that unrelated changes were accidentally merged with a single commit, but why would we want this script to call sudo in the first place?

I think it's bad practice, for such a script to execute commands as root -- 

Can you explain, Mauro?

Regards,

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
