Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab0BVXVk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:21:40 -0500
Message-ID: <4B831178.7060303@redhat.com>
Date: Mon, 22 Feb 2010 20:21:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, MXXrton NXXmeth <nm127@freemail.hu>
Subject: Re: [git:v4l-dvb/master] V4L/DVB: uvcvideo: Clamp control values
 to the minimum and maximum values
References: <E1Njfbf-0000g0-7v@www.linuxtv.org> <201002230011.05447.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201002230011.05447.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Monday 22 February 2010 22:14:19 Patch from Laurent Pinchart wrote:
>> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=utf-8
>> Content-Transfer-Encoding: 8bit
> 
> There's a problem somewhere.

It seems to be only at the git post-update script I wrote, since the commit is sane:

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=a8677cd5589be9e35ef5117f75e4b996724102fb

What's weird is that the script doesn't add any mime/utf stuff. It just fills the usual
from/to/date/subject/cc fields, and calls sendmail.

Maybe sendmail didn't like having a non-7-bits CC.

Cheers,
Mauro
