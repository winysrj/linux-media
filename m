Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1Iic6b015120
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 13:44:38 -0500
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1IiE4p011994
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 13:44:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Date: Mon, 1 Dec 2008 19:43:58 +0100
References: <200812011451.06156.hverkuil@xs4all.nl>
	<5d5443650812011014q55a96540gc8a4b97be951f2fd@mail.gmail.com>
In-Reply-To: <5d5443650812011014q55a96540gc8a4b97be951f2fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011943.58519.hverkuil@xs4all.nl>
Cc: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>, v4l <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
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

On Monday 01 December 2008 19:14:52 Trilok Soni wrote:
> Hi Hans,
>
> On Mon, Dec 1, 2008 at 7:21 PM, Hans Verkuil <hverkuil@xs4all.nl> 
wrote:
> > Hi Mauro,
> >
> > Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb for
> > the following:
>
> I don't understand "hg" version control tool, but commit shows your
> name as author of this patch, whereas the patch I had sent was having
> --author field as Sakari Ailus. Could you please check this? Thanks.
>
> author	Hans Verkuil <hverkuil@xs4all.nl>
> Mon Dec 01 14:49:58 2008 +0100 (4 hours ago)
> changeset 9768	2b81e03d16ed
> manifest	2b81e03d16ed
> parent 9767	7100e78482d7
> tag	tip

The hg author field is just whoever committed it into the mercurial 
repository, but what will show up when merged into the kernel are the 
From: and SoB fields. Actually, those were wrong as I had you as author 
(From:) instead of Sakari. I've changed that now.

It looks like this now:

 omap2: add OMAP2 camera driver.
 
 From: Sakari Ailus <sakari.ailus@nokia.com>
 
 Add a driver for the OMAP2 camera block. OMAP2 is used in e.g. Nokia
 N800/N810 internet tablet.
 
 This driver uses the V4L2 internal ioctl interface.
 
 Priority: normal
 
 Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
 Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
 Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Should be fine now, thanks for the heads up.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
