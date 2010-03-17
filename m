Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49054 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab0CQOeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:34:21 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <p.osciak@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Date: Wed, 17 Mar 2010 09:34:17 -0500
Subject: RE: [PATCH v2] v4l: videobuf: code cleanup.
Message-ID: <A24693684029E5489D1D202277BE8944541370F8@dlee02.ent.ti.com>
References: <1268831061-307-1-git-send-email-p.osciak@samsung.com>
    <1268831061-307-2-git-send-email-p.osciak@samsung.com>
    <A24693684029E5489D1D202277BE894454137086@dlee02.ent.ti.com>
    <001001cac5dc$4407f690$cc17e3b0$%osciak@samsung.com>
 <03b82834cbbe28326f10899d781d2701.squirrel@webmail.xs4all.nl>
In-Reply-To: <03b82834cbbe28326f10899d781d2701.squirrel@webmail.xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Wednesday, March 17, 2010 9:29 AM
> To: Pawel Osciak
> Cc: Aguirre, Sergio; linux-media@vger.kernel.org; Marek Szyprowski;
> kyungmin.park@samsung.com
> Subject: RE: [PATCH v2] v4l: videobuf: code cleanup.
> 
> 
> >> Aguirre, Sergio wrote:
> >>> Make videobuf pass checkpatch; minor code cleanups.
> >>
> >>I thought this kind patches were frowned upon..
> >>
> >>http://www.mjmwired.net/kernel/Documentation/development-
> process/4.Coding#41
> >>
> >>But maybe it's acceptable in this case... I'm not an expert on community
> >> policies :)
> >
> > Hm, right...
> > I'm not an expert either, but it does seem reasonable. It was just a
> part
> > of the
> > roadmap we agreed on in Norway, so I simply went ahead with it. Merging
> > with other
> > patches would pollute them so I just posted it separately. I will leave
> > the
> > decision up to Mauro then. I have some more "normal" patches lined up,
> > so please let me know. I'm guessing we are cancelling the clean-up then
> > though.

It wasn't my intention to cancel your effort :) Please don't give up because of my comment.

> 
> As I said, you give up way too easily. There are good reasons for doing a
> simple straightforward cleanup patch first before tackling all the more
> complex issues. Let's get this in first, then the future patches will only
> do the actual functional changes instead of them having to do codingstyle
> cleanups at the same time. I want to avoid that.

Sounds reasonable.

I wont say naything more about the topic. I think you guys have cleared it enough for me :)

Regards,
Sergio

> 
> Regards,
> 
>         Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

