Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4790 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2E1Ni6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 09:38:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCHv2 1/3] [media] media: reorganize the main Kconfig items
Date: Mon, 28 May 2012 15:38:39 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	stefanr@s5r6.in-berlin.de
References: <1338207469-32606-1-git-send-email-mchehab@redhat.com> <201205281451.50127.hverkuil@xs4all.nl> <4FC37DF9.5080401@redhat.com>
In-Reply-To: <4FC37DF9.5080401@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205281538.39869.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 28 2012 15:30:33 Mauro Carvalho Chehab wrote:
> Em 28-05-2012 09:51, Hans Verkuil escreveu:
> > On Mon May 28 2012 14:17:47 Mauro Carvalho Chehab wrote:

...

> >> +
> >> +	  Say Y when you have a board with digital support or a board with
> >> +	  hybrid digital TV and analog TV.
> >> +
> >> +config MEDIA_RADIO_SUPPORT
> >> +	bool "AM/FM radio receivers/transmitters support"
> >> +	---help---
> >> +	  Enable AM/FM radio support.
> > 
> > Just drop the 'AM/FM' part. We may get other devices that support other
> > bands as well (I know they exist, and one is actually on its way to me).
> 
> The thing is that "radio" is an ambiguous term inside the Kernel, as it
> can mean wireless, bluetooth, etc.

On second thought, just keep AM/FM. I keep forgetting that the AM band is
comprised of SW, MW and LW.

Regards,

	Hans
