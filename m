Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3321 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2HFHgd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 03:36:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: Update VIP to videobuf2 and control framework
Date: Mon, 6 Aug 2012 09:36:29 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com> <201208060926.40164.hverkuil@xs4all.nl> <4296967.xtOULN4YkB@harkonnen>
In-Reply-To: <4296967.xtOULN4YkB@harkonnen>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208060936.29244.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon August 6 2012 09:38:10 Federico Vaga wrote:
> 
> > > I applied all your suggestions, and some extra simplification;
> > > [...]
> 
> > > ---------------
> > > - flags: optional. Set to V4L2_FL_USE_FH_PRIO if you want to let the
> > > framework handle the VIDIOC_G/S_PRIORITY ioctls. This requires that
> > > you use struct v4l2_fh.
> > 
> >   ^^^^^^^^^^^^^^^^^^
> > 
> > Are you using struct v4l2_fh? The version you posted didn't. You need
> > this anyway to implement control events.
> 
> Yes I'm using it now, it is part of the extra simplification that I did.

In that case I need to see your latest version of the source code to see
why it doesn't work.

Regards,

	Hans
