Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46571
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751464AbdHHKnh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 06:43:37 -0400
Date: Tue, 8 Aug 2017 07:43:28 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [GIT PULL FOR v4.14] Add meson-ao-cec driver
Message-ID: <20170808074328.65b1ef81@vento.lan>
In-Reply-To: <77ba4a16-c11e-bf65-b2c9-943dddcab0f7@xs4all.nl>
References: <77ba4a16-c11e-bf65-b2c9-943dddcab0f7@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Jul 2017 15:05:07 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:
> 
>   media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git meson-cec
> 
> for you to fetch changes up to 098b47db51270f6e671773160411e3d285ea0d66:
> 
>   dt-bindings: media: Add Amlogic Meson AO-CEC bindings (2017-07-28 14:58:38 +0200)
> 
> ----------------------------------------------------------------
> Neil Armstrong (2):
>       platform: Add Amlogic Meson AO CEC Controller driver
>       dt-bindings: media: Add Amlogic Meson AO-CEC bindings
> 
>  Documentation/devicetree/bindings/media/meson-ao-cec.txt |  28 ++
>  drivers/media/platform/Kconfig                           |  11 +
>  drivers/media/platform/Makefile                          |   2 +
>  drivers/media/platform/meson/Makefile                    |   1 +
>  drivers/media/platform/meson/ao-cec.c                    | 744 +++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 786 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/meson-ao-cec.txt
>  create mode 100644 drivers/media/platform/meson/Makefile
>  create mode 100644 drivers/media/platform/meson/ao-cec.c

Addition to MAINTAINERS file for this driver is missing.



Thanks,
Mauro
