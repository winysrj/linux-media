Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4748 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3BJIj0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 03:39:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Emile Joubert <emile.joubert@gmail.com>
Subject: Re: bt878: radio frequency stuck
Date: Sun, 10 Feb 2013 09:39:21 +0100
Cc: linux-media@vger.kernel.org
References: <51170DC3.8070302@gmail.com>
In-Reply-To: <51170DC3.8070302@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302100939.21660.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun February 10 2013 04:02:27 Emile Joubert wrote:
> 
> Hi,
> 
> I have the same symptoms as the ones described here:
> http://article.gmane.org/gmane.linux.kernel/1214773
> 
> I have the same model card (37284) which also stopped working at commit
> cbde689823776d187ba1b307a171625dbc02dd4f. Since that commit the radio
> produces white noise and changing the frequency has no effect on the
> sound. I've tried kernel 3.8.0-rc7 and the problem still exists in that
> version.
> 
> Please let me know if there is further information I can provide towards
> a solution, or if there are any patches I could try.

Try this branch:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/bttv

Of particular interest is the patch "bttv: set initial tv/radio frequencies".
You could actually try applying just that patch first. If that doesn't
work, then try the whole patch series.

If none of that works, then let me know and we can do some more debugging.

Regards,

	Hans
