Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB2HQSse031864
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 12:26:28 -0500
Received: from smtp-vbr4.xs4all.nl (smtp-vbr4.xs4all.nl [194.109.24.24])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mB2HQCWr021925
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 12:26:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Tue, 2 Dec 2008 18:26:08 +0100
References: <200812011246.08885.hverkuil@xs4all.nl>
	<200812021758.35503.laurent.pinchart@skynet.be>
	<20081202152100.0a4dd2c1@pedra.chehab.org>
In-Reply-To: <20081202152100.0a4dd2c1@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021826.09133.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com,
	davinci-linux-open-source-bounces@linux.davincidsp.com,
	linux-kernel@vger.kernel.org,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
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

On Tuesday 02 December 2008 18:21:00 Mauro Carvalho Chehab wrote:
> On Tue, 2 Dec 2008 17:58:35 +0100
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > > Are you meaning marking this as experimental at Kconfig? This
> > > seems too complex, since we'll need to test for some var on every
> > > driver that were converted, providing two KABI options for each
> > > converted driver (the legacy and the v4l2_device way). This
> > > doesn't seem to be a good idea, since will add a lot of extra
> > > complexity to debug bugs.
> >
> > Not at the Kconfig level, just in the documentation (and possible
> > headers).
>
> Ah, ok. Good point.
>
> > This is a work in progress. Hans wants the changes to go mainline
> > to get broader testing, which is a valid reason, but I'd like to
> > make sure people understand that more changes are coming.
>
> Maybe instead we should have a TODO list somewhere with the
> programmed changes, especially at the subsystem core.

Sure, I can add some comments outlining future developments in 
v4l2-device.h and v4l2-subdev.h. The v4l2-framework document can point 
to those headers (headers are easier to keep in sync when new features 
arrive than documentation).

But I'll wait with this until I get Mauro's review back, just in case 
there are more changes for me to do.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
