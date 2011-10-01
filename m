Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3140 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab1JAJJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2011 05:09:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/5] doc: v4l: add binary images for selection API
Date: Sat, 1 Oct 2011 11:09:26 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi
References: <1317306161-23696-1-git-send-email-t.stanislaws@samsung.com> <1317306161-23696-3-git-send-email-t.stanislaws@samsung.com> <4E85F429.9060306@redhat.com>
In-Reply-To: <4E85F429.9060306@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110011109.26323.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, September 30, 2011 18:54:01 Mauro Carvalho Chehab wrote:
> Em 29-09-2011 11:22, Tomasz Stanislawski escreveu:
> > This patch adds images in binary format for the V4L2 selection API.
> 
> Please, just fold with the docbook patch on a next submission. Also, please
> put the docbook patch at the beginning of the series, since this is the most
> important patch on this series, as the other ones can only be understandable
> after reading the docbook.

Mauro, I much prefer these binary patches in a separate patch when it comes
to reviewing. I find it quite annoying having to delete 3000-odd lines of b64
nonsense just to get to the actual xml patches. And you might even miss an
important patch if it is in between two binary patches.

For a git pull request I don't care, but for inline patches it makes my life
easier.

Tomasz split it up on my suggestion, actually.

Regards,

	Hans

> 
> Thanks!
> Mauro
> > 
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/DocBook/media/constraints.png.b64 |  134 +
> >  Documentation/DocBook/media/selection.png.b64   | 2937 +++++++++++++++++++++++
> >  2 files changed, 3071 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/DocBook/media/constraints.png.b64
> >  create mode 100644 Documentation/DocBook/media/selection.png.b64
> > 
> 
> 
