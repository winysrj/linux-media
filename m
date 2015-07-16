Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34850 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbbGPImH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 04:42:07 -0400
Received: by lblf12 with SMTP id f12so39463109lbl.2
        for <linux-media@vger.kernel.org>; Thu, 16 Jul 2015 01:42:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1628799.CQBSk2GIHo@avalon>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
 <3162887.2tIlvOM8NK@avalon> <55A769E7.8010308@xs4all.nl> <1628799.CQBSk2GIHo@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 16 Jul 2015 10:41:46 +0200
Message-ID: <CAPybu_0Jw_wz_POrzupXqCRVJUP-7d+ntDQYxgdzmj2jQ6VUAQ@mail.gmail.com>
Subject: Re: [RFC v3 04/19] media/usb/uvc: Implement vivioc_g_def_ext_ctrls
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent

On Thu, Jul 16, 2015 at 10:27 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> I'd argue that even just two drivers would be enough :-) Especially given that
> the proposed implementation for uvcvideo is wrong.

This is why we have the review process :P. I do my best, but you are
the expert on your driver.

A core implementation cannot be completely correct, as it will not
support array controls.

I will resend this patch ASAP.


Thanks for your comments!


-- 
Ricardo Ribalda
