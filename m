Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4284 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZANSWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 13:22:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: Building v4l2spec docbook problems
Date: Wed, 14 Jan 2009 19:21:47 +0100
Cc: v4l <video4linux-list@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE8944164DFFD3@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944164DFFD3@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141921.47596.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 14 January 2009 19:11:31 Aguirre Rodriguez, Sergio Alberto 
wrote:
> > -----Original Message-----
> > From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> > bounces@redhat.com] On Behalf Of Hans Verkuil
> > Sent: Sunday, December 07, 2008 6:48 AM
> > To: v4l
> > Subject: Building v4l2spec docbook problems
> >
> > Hi all,
> >
> > I'm trying to build the v4l2spec:
> > http://v4l2spec.bytesex.org/v4l2spec-0.24.tar.bz2
> >
> > But I'm getting the following errors:
> >
> > ...
> > Using catalogs: /etc/sgml/catalog
> > Using stylesheet: /home/hans/work/src/v4l2spec-0.24/custom.dsl#html
> > Working on: /home/hans/work/src/v4l2spec-0.24/v4l2.sgml
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:357:5:W: cannot
> > generate system identifier for general entity "sub-common"
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:357:5:E: general
> > entity "sub-common" not defined and no default entity
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:357:15:E:
> > reference to entity "sub-common" for which no system identifier
> > could be generated
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:357:4: entity was
> > defined here
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:358:11:E: end tag
> > for "CHAPTER" which is not finished
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:361:5:W: cannot
> > generate system identifier for general entity "sub-pixfmt"
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:361:5:E: general
> > entity "sub-pixfmt" not defined and no default entity
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:361:15:E:
> > reference to entity "sub-pixfmt" for which no system identifier
> > could be generated
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:361:4: entity was
> > defined here
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:362:11:E: end tag
> > for "CHAPTER" which is not finished
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:365:5:W: cannot
> > generate system identifier for general entity "sub-io"
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:365:5:E: general
> > entity "sub-io" not defined and no default entity
> > jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:365:11:E:
> > reference to entity "sub-io" for which no system identifier could
> > be generated
> >
> > And this continues for a long list of 'sub-something' entities.
> >
> > Me no speak sgml, so I hope someone more familiar with this can
> > help me.
>
> Hi Hans,
>
> I'm having the same problems than you. Any update on this?
>
> I don't speak sgml either :(.

You have to 'touch' the Makefile first. There are some weird 
dependencies in the Makefile that cause these problems. Nothing to do 
with sgml, just broken Makefile rules.

Regards,

	Hans

>
> Regards,
> Sergio
>
> > Thanks,
> >
> > 	Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe
> > mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
