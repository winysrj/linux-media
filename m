Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:34300 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbbD3KRN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 06:17:13 -0400
Received: by laat2 with SMTP id t2so40473884laa.1
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2015 03:17:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c803709a49957c2be8f0a43782cd3140b4aedf4a.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
 <c803709a49957c2be8f0a43782cd3140b4aedf4a.1430235781.git.mchehab@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 30 Apr 2015 11:16:41 +0100
Message-ID: <CA+V-a8vHSoJqmUKq-M=hiG8u7CvRF9-ewLifFYmCZpJZys312g@mail.gmail.com>
Subject: Re: [PATCH 09/14] zoran: fix indent
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	mjpeg-users@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 28, 2015 at 4:43 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> As reported by smatch:
>         drivers/media/pci/zoran/zoran_device.c:1594 zoran_init_hardware() warn: inconsistent indenting
>
> Fix indent. While here, fix CodingStyle and remove dead code, as it
> can always be recovered from git logs.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
