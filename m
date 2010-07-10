Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0GJRWp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 13:22:45 -0400
Message-ID: <4C38AC74.60008@redhat.com>
Date: Sat, 10 Jul 2010 14:23:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v2 7/7] v4l: subdev: Generic ioctl support
References: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278689512-30849-8-git-send-email-laurent.pinchart@ideasonboard.com> <4C387EEE.3000108@redhat.com> <201007101831.49445.hverkuil@xs4all.nl>
In-Reply-To: <201007101831.49445.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-07-2010 13:31, Hans Verkuil escreveu:
> On Saturday 10 July 2010 16:08:46 Mauro Carvalho Chehab wrote:
>> Em 09-07-2010 12:31, Laurent Pinchart escreveu:

>> Hmm... private ioctls at subdev... I'm not sure if I like this idea. I prefer to merge this patch
>> only after having a driver actually needing it, after discussing why not using a standard ioctl
>> for that driver.
> 
> Part of the reason for making these subdev device nodes is to actually allow
> private ioctls (after properly discussing it and with documentation). SoCs tend
> to have a lot of very hardware specific features that do not translate to generic
> ioctls. Until now these are either ignored or handled through custom drivers, but
> but it is much better to handle them in a 'controlled' fashion.

I understand that SoC's may have lots of features that are currently not being exposed,
but if they'll be either be shown as CTRL or as new ioctls need further discussions. That's
why I prefer to receive this patch in a patch series where such needed is required.

Cheers,
Mauro.
