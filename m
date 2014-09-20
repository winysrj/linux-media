Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36911 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbaITKOj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 06:14:39 -0400
Date: Sat, 20 Sep 2014 07:14:34 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: James Harper <james@ejbdigital.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] vb2: fix VBI/poll regression
Message-ID: <20140920071434.33736eee@recife.lan>
In-Reply-To: <20140920070808.7409440e@recife.lan>
References: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
	<1411203375-15310-2-git-send-email-hverkuil@xs4all.nl>
	<fc1bd2008429476abaf3e3fab719fe52@SIXPR04MB304.apcprd04.prod.outlook.com>
	<541D4568.2020605@xs4all.nl>
	<20140920070808.7409440e@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 20 Sep 2014 07:08:08 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Sat, 20 Sep 2014 11:14:16 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On 09/20/2014 11:08 AM, James Harper wrote:
> > >>
> > >> The recent conversion of saa7134 to vb2 unconvered a poll() bug that
> > >> broke the teletext applications alevt and mtt. These applications
> > >> expect that calling poll() without having called VIDIOC_STREAMON will
> > >> cause poll() to return POLLERR. That did not happen in vb2.
> > >>
> > >> This patch fixes that behavior. It also fixes what should happen when
> > >> poll() is called when STREAMON is called but no buffers have been
> > >> queued. In that case poll() will also return POLLERR, but only for
> > >> capture queues since output queues will always return POLLOUT
> > >> anyway in that situation.
> > >>
> > >> This brings the vb2 behavior in line with the old videobuf behavior.
> > >>
> > > 
> > > What (mis)behaviour would this cause in userspace application?
> > 
> > If an app would rely on poll to return POLLERR to do the initial STREAMON
> > (seen in e.g. alevt) or to do the initial QBUF (I'm not aware of any apps
> > that do that, but they may exist), then that will currently fail with vb2
> > because poll() will just wait indefinitely in those cases.
> 
> You forgot to mention (also at the patch series) that the removal of
> list_empty() check solves the buffer underrun condition.

Actually, no need to comment it there, as I'll be removing the revert
patch from topic/devel.

If James is using master (likely the case), then the list_empty issue is not
affecting him, as the revert is just at topic/devel.

> 
> With this fix, if a multi-threaded application goes into an underrun
> condition (e. g. if it de-queues faster than queues), a POLLERR would be
> received. The poll fixup patch series also fixes it.
> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
