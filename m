Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:40895 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbbBRWhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 17:37:10 -0500
Received: by wesx3 with SMTP id x3so3967265wes.7
        for <linux-media@vger.kernel.org>; Wed, 18 Feb 2015 14:37:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5b078f35e4176dbd2383999289bc9f9651722759.1424273378.git.mchehab@osg.samsung.com>
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
 <5b078f35e4176dbd2383999289bc9f9651722759.1424273378.git.mchehab@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 18 Feb 2015 22:36:38 +0000
Message-ID: <CA+V-a8sGMwgydP4v8RdTjXOBtvhJEeTbUacWvguRznQk2ejNLg@mail.gmail.com>
Subject: Re: [PATCH 3/7] [media] tuner-core: fix compilation if the media
 controller is not defined
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2015 at 3:29 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> drivers/media/v4l2-core/tuner-core.c:440:7: error: 'struct v4l2_subdev' has no member named 'entity'
>      t->sd.entity.name = t->name;
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
