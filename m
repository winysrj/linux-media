Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:55920 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab0KNVwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 16:52:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Sun, 14 Nov 2010 22:53:29 +0100
Cc: linux-media@vger.kernel.org
References: <cover.1289740431.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289740431.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011142253.29768.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 14 November 2010, Hans Verkuil wrote:
> This patch series converts 24 v4l drivers to unlocked_ioctl. These are low
> hanging fruit but you have to start somewhere :-)
> 
> The first patch replaces mutex_lock in the V4L2 core by mutex_lock_interruptible
> for most fops.

The patches all look good as far as I can tell, but I suppose the title is
obsolete now that the BKL has been replaced with a v4l-wide mutex, which
is what you are removing in the series.

	Arnd
