Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:60413 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3C2UWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 16:22:16 -0400
Received: by mail-yh0-f53.google.com with SMTP id q3so59202yhf.40
        for <linux-media@vger.kernel.org>; Fri, 29 Mar 2013 13:22:16 -0700 (PDT)
Message-ID: <5155F7F6.4070400@gmail.com>
Date: Fri, 29 Mar 2013 15:22:14 -0500
From: Rob Herring <robherring2@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: LMML <linux-media@vger.kernel.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR 3.10] Media DT bindings and V4L2 OF parsing library
References: <5155D1EE.1020201@samsung.com>
In-Reply-To: <5155D1EE.1020201@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/29/2013 12:39 PM, Sylwester Nawrocki wrote:
> Mauro,
> 
> This includes two patches adding device tree support at the V4L2 API.
> I added Rob and Grant at Cc in case they still wanted to comment on
> those patches. Not sure what the exact policy is but I guess we need
> an explicit DT maintainer's Ack on stuff like this.

Bindings regularly go in without Grant's or my ack simply because there
are too many to keep up with and it really requires knowledge of the
particular h/w being described.

I've skimmed thru this one on several versions and nothing concerning
jumps out. So I think it is good to go in.

Rob

> These patches have been discussed quite extensively and first versions
> appeared about 6 months ago. Now we need DT support at the media
> subsystem since some SoCs are already starting to loose non-dt booting
> support upstream. Without this most of our media drivers would have been
> pretty useless.
> 
> Thanks,
> Sylwester
> 
> The following changes since commit 9e7664e0827528701074875eef872f2be1dfaab8:
> 
>   [media] solo6x10: The size of the thresholds ioctls was too large (2013-03-29
> 08:34:23 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/snawrocki/samsung.git v4l_devicetree
> 
> for you to fetch changes up to 27ab1e94d69d9139d530a661832c7b3a047a69e0:
> 
>   [media] Add a V4L2 OF parser (2013-03-29 17:34:55 +0100)
> 
> ----------------------------------------------------------------
> Guennadi Liakhovetski (2):
>       [media] Add common video interfaces OF bindings documentation
>       [media] Add a V4L2 OF parser
> 
>  .../devicetree/bindings/media/video-interfaces.txt |  228 +++++++++++++++++
>  drivers/media/v4l2-core/Makefile                   |    3 +
>  drivers/media/v4l2-core/v4l2-of.c                  |  267 ++++++++++++++++++++
>  include/media/v4l2-of.h                            |  111 ++++++++
>  4 files changed, 609 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/video-interfaces.txt
>  create mode 100644 drivers/media/v4l2-core/v4l2-of.c
>  create mode 100644 include/media/v4l2-of.h
> 

