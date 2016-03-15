Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36921 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965635AbcCOS2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 14:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <20160315070412.GA13560@mwanda>
References: <20160315070412.GA13560@mwanda>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 15 Mar 2016 18:28:15 +0000
Message-ID: <CA+V-a8tpSbiUqjvV8CMY8=HUA1ZuPD1RTw2s5=+3z=g+DCpkeA@mail.gmail.com>
Subject: Re: [patch] [media] am437x-vpfe: fix an uninitialized variable bug
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Benoit Parrot <bparrot@ti.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thanks for the patch.

On Tue, Mar 15, 2016 at 7:04 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> If we are doing V4L2_FIELD_NONE then "ret" is used uninitialized.
>
> Fixes: 417d2e507edc ('[media] media: platform: add VPFE capture driver support for AM437X')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
