Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36753 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbcGOPgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:36:37 -0400
MIME-Version: 1.0
In-Reply-To: <20160715122845.7f357277@recife.lan>
References: <1468595816-31272-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468595816-31272-3-git-send-email-ricardo.ribalda@gmail.com> <20160715122845.7f357277@recife.lan>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 15 Jul 2016 17:36:15 +0200
Message-ID: <CAPybu_077ZkW3_SnPLqkMMgUUrrBDYH+8WzSEnSHAkyTkE525w@mail.gmail.com>
Subject: Re: [PATCH 2/6] [media] Documentation: Add HSV format
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Fri, Jul 15, 2016 at 5:28 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Hi Ricardo,
>
> I'm not seeing patch 1.

That is because you blacklisted me :P
https://lkml.org/lkml/2016/7/15/455

I resend it to you right away.


>
> Anyway, please send documentation patches against the rst files. They're
> at the "docs-next" branch and will be merged upstream on this merge window.
>

you are absolutely right, I read about it in lwn. Sorry about that.


How do you prefer it:
- 2 patchset : One on top of media/master with the code changes, and
one on top of docs-next with the doc changes.
or
-1 patchset on top of doc-next and we will figure out later if there
is a merge conflict with media

Thanks!
