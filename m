Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4765 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3CKWBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 18:01:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 00/42] go7007: complete overhaul
Date: Mon, 11 Mar 2013 23:01:01 +0100
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303112301.01418.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon March 11 2013 12:45:38 Hans Verkuil wrote:
> Hi all,
> 
> This patch series updates the staging go7007 driver to the latest
> V4L2 frameworks and actually makes it work reliably.
> 
> Some highlights:
> 
> - moved the custom i2c drivers to media/i2c.
> - replaced the s2250-loader by a common loader for all the supported
>   devices.
> - replaced all MPEG-related custom ioctls by standard ioctls and FMT
>   support.
> - added the saa7134-go7007 combination (similar to the saa7134-empress).
> 
> In addition I've made some V4L2 core and saa7115 changes (the first 6
> patches):
> 
> - eliminate false lockdep warnings when dealing with nested control
>   handlers. This patch is a slightly modified version from the one Andy
>   posted a long time ago.
> - add support to easily test if any subdevices support a particular operation.
> - fix a few bugs in the code that tests if an ioctl is available: it didn't
>   take 'disabling of ioctls' into account.
> - added additional configuration flags to saa7115, needed by the go7007.
> - improved querystd support in saa7115.
> 
> This driver now passes all v4l2-compliance tests.
> 
> Volokh, I've merged your tw2804 v4l2 framework cleanup patches into one
> with my modifications on top. I hope you don't mind.
> 
> It has been tested with:
> 
> - Plextor PX-TV402U (PAL model)
> - Sensoray S2250S (generously provided by Sensoray, all audio inputs
>   now work!)
> - Sensoray Model 614 (saa7134+go7007 PCI board, generously provided by
>   Sensoray)
> - WIS X-Men II sensor board (generously provided by Sensoray)
> - Adlink PCI-MPG24 surveillance board

and it has also been tested with:

- Plextor PX-M402U (it arrived today)

Regards,

	Hans
