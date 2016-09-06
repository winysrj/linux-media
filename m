Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58064 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933133AbcIFKUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 06:20:53 -0400
Subject: Re: [PATCH v6 13/14] media: platform: pxa_camera: move pxa_camera out
 of soc_camera
To: Robert Jarzmik <robert.jarzmik@free.fr>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>
References: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
 <1473152664-5077-13-git-send-email-robert.jarzmik@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <581ba4d4-4c27-3336-1733-1c50b320042d@xs4all.nl>
Date: Tue, 6 Sep 2016 12:20:45 +0200
MIME-Version: 1.0
In-Reply-To: <1473152664-5077-13-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On 09/06/16 11:04, Robert Jarzmik wrote:
> As the conversion to a v4l2 standalone device is finished, move
> pxa_camera one directory up and finish severing any dependency to
> soc_camera.
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/Kconfig                       | 8 ++++++++
>  drivers/media/platform/Makefile                      | 1 +
>  drivers/media/platform/{soc_camera => }/pxa_camera.c | 0
>  drivers/media/platform/soc_camera/Kconfig            | 8 --------
>  drivers/media/platform/soc_camera/Makefile           | 1 -
>  5 files changed, 9 insertions(+), 9 deletions(-)
>  rename drivers/media/platform/{soc_camera => }/pxa_camera.c (100%)

Can you make a new patch that adds an entry to the MAINTAINERS file for 
this driver?

Thanks!

	Hans
