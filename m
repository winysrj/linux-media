Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52893 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbbGNWyD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 18:54:03 -0400
Message-ID: <55A59308.1080008@osg.samsung.com>
Date: Tue, 14 Jul 2015 16:54:00 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: "Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IENvbXBpbGVyIHdhcm5pbmcgZnJvbSBkcml2ZXJzL21lZGlhL3U=?=
 =?UTF-8?B?c2IvYXUwODI4L2F1MDgyOC12aWRlby5jOiBJbiBmdW5jdGlvbiDigJhxdWV1ZV8=?=
 =?UTF-8?B?c2V0dXDigJk=?=
References: <558A1E79.8050902@osg.samsung.com>
In-Reply-To: <558A1E79.8050902@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/23/2015 09:05 PM, Shuah Khan wrote:
> Hi Mauro,
> 
> I am seeing the following warning from au0828 - linux_media
> media_controller branch:
> 
> drivers/media/usb/au0828/au0828-video.c: In function ‘queue_setup’:
> drivers/media/usb/au0828/au0828-video.c:679:6: warning: ‘entity’ may be
> used uninitialized in this function [-Wmaybe-uninitialized]
>    if (sink == entity)
>       ^
> drivers/media/usb/au0828/au0828-video.c:644:24: note: ‘entity’ was
> declared here
>   struct media_entity  *entity, *source;
>                         ^
> 
> This looks real to me, but don't know what entity should have been
> initialized to.
> 

Hi Mauro,

I don't your patch that fixes this issue in the media-controller branch.
Are you planning to get that in?

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
