Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1MMV4c030705
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 17:22:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1MMJuj022483
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 17:22:19 -0500
Date: Mon, 1 Dec 2008 20:22:09 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Trilok Soni" <soni.trilok@gmail.com>
Message-ID: <20081201202209.5cea1f4b@pedra.chehab.org>
In-Reply-To: <5d5443650812011014q55a96540gc8a4b97be951f2fd@mail.gmail.com>
References: <200812011451.06156.hverkuil@xs4all.nl>
	<5d5443650812011014q55a96540gc8a4b97be951f2fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	v4l <video4linux-list@redhat.com>, Sakari Ailus <sakari.ailus@nokia.com>
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

On Mon, 1 Dec 2008 23:44:52 +0530
"Trilok Soni" <soni.trilok@gmail.com> wrote:

> Hi Hans,
> 
> On Mon, Dec 1, 2008 at 7:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Mauro,
> >
> > Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb for the
> > following:
> >
> 
> I don't understand "hg" version control tool, but commit shows your
> name as author of this patch, whereas the patch I had sent was having
> --author field as Sakari Ailus. Could you please check this? Thanks.
> 
> author	Hans Verkuil <hverkuil@xs4all.nl>

This is one of the lack of the features on mercurial. It doesn't have a meta
tag for committer. On mercurial, the -hg user and the author should be the same
person.

Since we want to identify the patch origin (e.g. whose v4l/dvb maintainer got
the patch), we use the internal "user" meta-tag as the committer, and an extra
tag, at the patch description for the author (From:).

When creating the -git patch, the "From:" tag is replaced, by script, for
"Author:", I add my SOB there, and, I add myself as the -git committer (on git
we have both meta-tags).




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
