Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15NpZLR030869
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 18:51:35 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.184])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m15NosSJ004716
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 18:50:56 -0500
Received: by rv-out-0910.google.com with SMTP id k15so1945215rvb.51
	for <video4linux-list@redhat.com>; Tue, 05 Feb 2008 15:50:53 -0800 (PST)
Date: Tue, 5 Feb 2008 15:15:06 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080205231506.GD10319@plankton.ifup.org>
References: <20080205012451.GA31004@plankton.ifup.org>
	<47A86350.9090205@linuxtv.org> <20080205120102.76ccd526@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205120102.76ccd526@gaivota>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	video4linux-list@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
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

On 12:01 Tue 05 Feb 2008, Mauro Carvalho Chehab wrote:
> On Tue, 05 Feb 2008 08:23:28 -0500
> Michael Krufky <mkrufky@linuxtv.org> wrote:
> 
> > Brandon Philips wrote:
> > > - mailimport changes in this commit too!  Why is mailimport running
> > >   sudo!?! 
> > 
> > I understand that unrelated changes were accidentally merged with a single commit, but why would we want this script to call sudo in the first place?
> > 
> > I think it's bad practice, for such a script to execute commands as root -- 
> > 
> > Can you explain, Mauro?
> 
> The script itself doesn't open any new vulnerabilities. Sudo only works if 
> configured at /etc/sudoers.

I don't use the script but I would certainly remove the sudo calls in my
local version if I started to.  A patch tool really shouldn't need sudo.
If the perms are wrong the user can write a wrapper script to fix them.

> 2) the user of the second account types his password (or, otherwise, sudo is
> configured to not ask for passwords - on very weak environments).

sudo defaults to a 15 grace period where it doesn't ask for a password
again.

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
