Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35863 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbbCJOaC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 10:30:02 -0400
Date: Tue, 10 Mar 2015 10:30:00 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/18] marvell-ccic + ov7670 fixes
Message-ID: <20150310103000.7d79bb7f@lwn.net>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon,  9 Mar 2015 22:22:05 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> This patch series makes loads of fixes and improvements to the marvell-ccic
> and ov7670 drivers. This has been tested on an OLPC XO-1 laptop.

So I'm traveling and even shorter on time than usual.  I've had a quick
look over these patches, and they generally seem OK.  Just don't ding me
for not using a bunch of infrastructure that wasn't there when I wrote
this thing! :)

Ideally it would be nice to see patch 9 split - locking changes separate
from use of helpers - but that's a quibble.

Out of curiosity, is there a use driving this work, or are you just
making things cleaner?

Regardless, it clearly improves the drivers; thanks for doing this.

Acked-by: Jonathan Corbet <corbet@lwn.net>

> I do need to check the last patch with Libin Yang since his patch from mid-2013
> broke the driver for the OLPC laptop. Nobody noticed since the latest released
> kernel from the OLPC project for that laptop is 3.3, which didn't have his patch.

Libin seems to have vanished, and I think that whatever interest Marvell
had in supporting this driver has vanished with him, unfortunately.  I'm
still tempted to revert much of that work, since I'm not sure it has ever
worked on a real system...

jon
