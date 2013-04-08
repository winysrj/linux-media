Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:44851 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934568Ab3DHJUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 05:20:12 -0400
MIME-Version: 1.0
In-Reply-To: <1348754853-28619-11-git-send-email-g.liakhovetski@gmx.de>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <1348754853-28619-11-git-send-email-g.liakhovetski@gmx.de>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 8 Apr 2013 17:19:52 +0800
Message-ID: <CAGsJ_4zYvF-U0_ETs9EP8i+bOJiJLkXWrJdMNnW_sXU-QwnXQw@mail.gmail.com>
Subject: Re: [PATCH 10/14] media: soc-camera: support OF cameras
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
	zilong.wu@csr.com, "renwei.wu" <renwei.wu@csr.com>,
	xiaomeng.hou@csr.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi Guennadi,

2012/9/27 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> With OF we aren't getting platform data any more. To minimise changes we
> create all the missing data ourselves, including compulsory struct
> soc_camera_link objects. Host-client linking is now done, based on the OF
> data. Media bus numbers also have to be assigned dynamically.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

as your V4L2 core DT based supports
[media] Add a V4L2 OF parser
[media] Add common video interfaces OF bindings documentation
have been in media_tree queue for 3.10. i do care about the status of
this patch for soc_camera.

will you have a plan to resend these soc-camera patches based on your
final V4L2 core DT patches? otherwise, we might do some jobs for that.

> ---
>  drivers/media/platform/soc_camera/soc_camera.c |  337 ++++++++++++++++++++++--
>  include/media/soc_camera.h                     |    5 +
>  2 files changed, 326 insertions(+), 16 deletions(-)
>
-barry
