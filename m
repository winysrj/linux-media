Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab1AKULw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 15:11:52 -0500
Message-ID: <4D2CD5A4.2040404@redhat.com>
Date: Tue, 11 Jan 2011 20:11:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
Subject: Re: [GIT PATCHES FOR 2.6.38] Use the control framework in various
 subdevs
References: <201012311437.00074.hverkuil@xs4all.nl> <201101071049.30943.hverkuil@xs4all.nl> <201101071144.55426.hverkuil@xs4all.nl>
In-Reply-To: <201101071144.55426.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-01-2011 08:44, Hans Verkuil escreveu:
> On Friday, January 07, 2011 10:49:30 Hans Verkuil wrote:

> So this patch series is OK to merge.

>>> The following changes since commit 187134a5875df20356f4dca075db29f294115a47:
>>>   David Henningsson (1):
>>>         [media] DVB: IR support for TechnoTrend CT-3650
>>>
>>> are available in the git repository at:
>>>
>>>   ssh://linuxtv.org/git/hverkuil/media_tree.git subdev-ctrl1
>>>
>>> Hans Verkuil (11):
>>>       vivi: convert to the control framework and add test controls.


Hmm.. this patch is producing a new warning:
drivers/media/video/vivi.c:1059: warning: this decimal constant is unsigned only in ISO C90

Please fix.
Mauro.
