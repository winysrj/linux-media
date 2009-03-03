Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:38734 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbZCCWaD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2009 17:30:03 -0500
From: Janne Grunau <j@jannau.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Possible omission in v4l2-common.c?
Date: Tue, 3 Mar 2009 23:29:54 +0100
Cc: Brandon Jenkins <bcjenkins@tvwhere.com>,
	linux-media@vger.kernel.org
References: <de8cad4d0903030450qf4063f1r9e4e53f5f83f1763@mail.gmail.com> <200903032218.55382.hverkuil@xs4all.nl>
In-Reply-To: <200903032218.55382.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903032329.54167.j@jannau.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 March 2009 22:18:55 Hans Verkuil wrote:
> On Tuesday 03 March 2009 13:50:30 Brandon Jenkins wrote:
> > Hello all,
> >
> > I was upgrading drivers this morning to capture the latest changes
> > for the cx18 and I received a merge conflict in v4l2-common.c. In
> > my system, 1 HDPVR and 3 CX18s. The HDPVR sources are 5 weeks old
> > from their last sync up but contain:
> >
> > case V4L2_CID_SHARPNESS:
> >
> > The newer sources do not, but still have reference to sharpness at
> > line 420: case V4L2_CID_SHARPNESS:                return
> > "Sharpness";
> >
> > Because I don't know which way the code is going (is sharpness in
> > or out) I can't submit a patch, but thought I would raise here.
> > Diff below was pulled from clean clone of v4l-dvb tree.
>
> Sharpness is definitely in. This is a bug, please submit this patch
> with a Signed-off-by line and I'll get it merged.

It is and afaik was never handled in v4l2_ctrl_query_fill(), the hdpvr 
tree adds that. Since I intend request the merge of the driver in a 
couple of days a seperate patch shouldn't be needed.

janne
