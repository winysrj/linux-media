Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4918 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761391AbaGRL6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 07:58:55 -0400
Message-ID: <53C90BED.4040805@xs4all.nl>
Date: Fri, 18 Jul 2014 13:58:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [linuxtv-media:master 447/499] drivers/media/common/saa7146/saa7146_fops.c:536:13:
 sparse: incorrect type in assignment (different base types)
References: <53c862c4.axXMxgoD8CYYkiCj%fengguang.wu@intel.com> <2344820.NCMmLgcQJ6@avalon>
In-Reply-To: <2344820.NCMmLgcQJ6@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/14 13:53, Laurent Pinchart wrote:
> On Friday 18 July 2014 07:56:52 kbuild test robot wrote:
>> tree:   git://linuxtv.org/media_tree.git master
>> head:   0ca1ba2aac5f6b26672099b13040c5b40db93486
>> commit: d52e23813672c3c72f92e7b39c7408d4b9a40a96 [447/499] [media] v4l:
>> Support extending the v4l2_pix_format structure reproduce: make C=1
>> CF=-D__CHECK_ENDIAN__
>>
>>
>> sparse warnings: (new ones prefixed by >>)
>>
>>>> drivers/media/common/saa7146/saa7146_fops.c:536:13: sparse: incorrect
>>>> type in assignment (different base types)
>>    drivers/media/common/saa7146/saa7146_fops.c:536:13:    expected struct
>> v4l2_pix_format *fmt drivers/media/common/saa7146/saa7146_fops.c:536:13:   
>> got struct <noident> *<noident>
>> drivers/media/common/saa7146/saa7146_fops.c: In function 'saa7146_vv_init':
>> drivers/media/common/saa7146/saa7146_fops.c:536:6: warning: assignment from
>> incompatible pointer type [enabled by default] fmt = &vv->ov_fb.fmt;
>>          ^
> 
> I'll send a patch to fix that.

I posted a fix for that already:

[PATCH for v3.17] saa7146: fix compile warning

Part of pull request https://patchwork.linuxtv.org/patch/24885/

Regards,

	Hans
