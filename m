Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:25253 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab3GYNZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:25:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [GIT PULL FOR v3.11]
Date: Thu, 25 Jul 2013 15:25:01 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <201306270855.49444.hverkuil@xs4all.nl> <CA+V-a8sYvBWGJGBF6JWwjKHwW_4Ew8wp6yBQnCrpeebAkJ4EmA@mail.gmail.com>
In-Reply-To: <CA+V-a8sYvBWGJGBF6JWwjKHwW_4Ew8wp6yBQnCrpeebAkJ4EmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307251525.01108.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Thu 11 July 2013 19:25:15 Prabhakar Lad wrote:
> Hi Hans,
> 
> On Thu, Jun 27, 2013 at 12:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > (Same as my previous git pull message, but with more cleanup patches and
> [snip]
> > Lad, Prabhakar (9):
> >       media: i2c: ths8200: support asynchronous probing
> >       media: i2c: ths8200: add OF support
> >       media: i2c: adv7343: add support for asynchronous probing
> >       media: i2c: tvp7002: add support for asynchronous probing
> >       media: i2c: tvp7002: remove manual setting of subdev name
> >       media: i2c: tvp514x: remove manual setting of subdev name
> >       media: i2c: tvp514x: add support for asynchronous probing
> >       media: davinci: vpif: capture: add V4L2-async support
> >       media: davinci: vpif: display: add V4L2-async support
> >
> I see last two patches missing in Mauro's pull request for v3.11 and v3.11-rc1.

I had to split up my pull request into fixes for 3.11 and new stuff for 3.12
since the merge window was about to open at the time.

Your 'missing' patches are here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/for-v3.12

In the next few days I'll try to process all remaining patches delegated to me.
If you have patches not yet delegated to me, or that are not in my for-v3.12
branch, then let me know.

Regards,

	Hans
