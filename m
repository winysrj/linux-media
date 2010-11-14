Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:53879 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab0KNP67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 10:58:59 -0500
Date: Sun, 14 Nov 2010 08:58:57 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: cafe_ccic: can ioctl be replaced by unlocked_ioctl?
Message-ID: <20101114085857.6ce90356@bike.lwn.net>
In-Reply-To: <201011141444.52248.hverkuil@xs4all.nl>
References: <201011141444.52248.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 14 Nov 2010 14:44:52 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Unless you have any objections I'd like to replace .ioctl by .unlocked_ioctl
> in this driver.

No objections, it should have been that way from the beginning.  In
fact, I thought it *was* that way...oh well, better late than never.

jon
