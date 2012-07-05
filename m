Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2GEUqt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 16:46:49 -0400
Message-ID: <4FF5FD2C.7030505@redhat.com>
Date: Thu, 05 Jul 2012 17:46:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.6] V4L2 API cleanups
References: <4FD50223.4030501@iki.fi> <6836133.PoLuVdfeXV@avalon> <20120611093944.GF12505@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120611093944.GF12505@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-06-2012 06:39, Sakari Ailus escreveu:
> On Mon, Jun 11, 2012 at 09:50:54AM +0200, Laurent Pinchart wrote:
>> Hi Sakari,
>>
>> On Sunday 10 June 2012 23:22:59 Sakari Ailus wrote:
>>> Hi Mauro,
>>>
>>> Here are two V4L2 API cleanup patches; the first removes __user from
>>> videodev2.h from a few places, making it possible to use the header file
>>> as such in user space, while the second one changes the
>>> v4l2_buffer.input field back to reserved.
>>>
>>>
>>> The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:
>>>
>>>    [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
>>> 09:27:24 -0300)
>>>
>>> are available in the git repository at:
>>>    ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.6
>>>
>>> Sakari Ailus (2):
>>>        v4l: Remove __user from interface structure definitions
>>
>> NAK, sorry.
>>
>> __user has a purpose, we need to add it where it's missing, not remove it
>> where it's rightfully present.
> 
> It's not quite as simple as adding __user everywhere it might belong to ---
> these structs are being used in kernel space, too.

Only kernelspace see __user. The "make headers_install" target removes __user
from the userspace copy.

Regards,
Mauro
