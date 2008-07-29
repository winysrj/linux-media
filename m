Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TCASWN004837
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 08:10:28 -0400
Received: from smtp-vbr6.xs4all.nl (smtp-vbr6.xs4all.nl [194.109.24.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TCAGHc028106
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 08:10:17 -0400
Received: from webmail.xs4all.nl (dovemail6.xs4all.nl [194.109.26.8])
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id m6TCAG0q028706
	for <video4linux-list@redhat.com>;
	Tue, 29 Jul 2008 14:10:16 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-ID: <20092.62.70.2.252.1217333416.squirrel@webmail.xs4all.nl>
Date: Tue, 29 Jul 2008 14:10:16 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
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

> Hi All,
>
> CONFIG_VIDEO_ADV_DEBUG enables additional debugging output in the gscpa
> driver, which then becomes "active" when a module option gets passed. So
> in the gspca case it normally only results in a larger driver without
> causing additional debug unless module option is passed.
>
> I've been asking the Fedora kernel maintainers to enable this option by
> default for the Fedora development version atleast, and thus I wonder
> how this option affects other drivers, are there other drivers which
> become very chatty with this option, or do they all need a module option
> to truely enable all the debug spew like gspca?

The verbosity level is done through some sort of debug module option. This
CONFIG is only used AFAIK to enable the VIDIOC_DBG_G/S_REGISTER ioctls
which allows you to program the video device(s) directly by
setting/getting registers.

I see that a few drivers use it to expose extra information through sysfs.

But the way gspca uses it is not correct. I would remove the test on
CONFIG_VIDEO_ADV_DEBUG there altogether, or replace it with a test of a
new gspca-specific config option. The ADV_DEBUG option is really about
allowing the root user access to low-level driver registers through the
v4l2-dbg utility. It's not about enabling additional debugging output.

This is also the reason by it is disabled by most (?) distros: it's a bit
dangerous to allow the user to mess with that. But it is ideal to test
different register values on the fly.

Regards,

         Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
