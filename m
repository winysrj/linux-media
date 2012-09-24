Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3141 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab2IXM6c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 08:58:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v5] media: v4l2-ctrl: add a helper function to add standard control with driver specific menu
Date: Mon, 24 Sep 2012 14:58:14 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LDOC <linux-doc@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	VGER <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Rob Landley <rob@landley.net>
References: <1348491221-6068-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1348491221-6068-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209241458.14376.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon September 24 2012 14:53:40 Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> Add helper function v4l2_ctrl_new_std_menu_items(), which adds
> a standard menu control, with driver specific menu.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Rob Landley <rob@landley.net>
> ---
>  Changes for v5:
>  1: Fixed some grammatical issues pointed by Hans.
> 
>  Changes for v4:
>  1: Rather then adding a function to modify the menu, added a helper
>    function, that creates a new standard control with user specific
>    menu.
> 
>  Changes for v3:
>  1: Fixed style/grammer issues as pointed by Hans.
>    Thanks Hans for providing the description.
> 
>  Changes for v2:
>  1: Fixed review comments from Hans, to have return type as
>    void, add WARN_ON() for fail conditions, allow this fucntion
>    to modify the menu of custom controls.
> 
>  Documentation/video4linux/v4l2-controls.txt |   24 +++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c        |   30 +++++++++++++++++++++++++++
>  include/media/v4l2-ctrls.h                  |   23 ++++++++++++++++++++
>  3 files changed, 77 insertions(+), 0 deletions(-)
