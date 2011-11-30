Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37610 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1K3Ufm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 15:35:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC/PATCH v2 0/3] 64-bit integer menus
Date: Wed, 30 Nov 2011 21:35:45 +0100
Cc: linux-media@vger.kernel.org, snjw23@gmail.com, hverkuil@xs4all.nl
References: <20111130173821.GH29805@valkosipuli.localdomain>
In-Reply-To: <20111130173821.GH29805@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111302135.46637.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patches. They look good to me.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

On Wednesday 30 November 2011 18:38:21 Sakari Ailus wrote:
> Hi all,
> 
> This patchset, which I'm sending as RFC since it has not been really tested
> (including compiling the vivi patch), adds 64-bit integer menu controls.
> The control items in the integer menu are just like in regular menus but
> they are 64-bit integers instead of strings.
> 
> I'm also pondering whether to assign 1 to ctrl->step for menu type controls
> as well but haven't checked what may have been the original reason to
> implement it as it is now implemented.
> 
> The reason why I don't use a union for qmenu and qmenu_int in
> v4l2_ctrl_config is that a lot of drivers use that field in the initialiser
> and GCC < 4.6 does not support initialisers with anonymous unions.
> 
> Similar union is created in v4l2_querymenu but I do not see this as a
> problem since I do not expect initialisers to be used with this field in
> the user space code.
> 
> Comments and questions are welcome.
> 
> ---
> Changes since RFC/PATCH v1:
> 
> - Fix documentation according to suggestions from Sylwester and Laurent.
> - Don't allow creating new standard integer menu controls using
>   v4l2_ctrl_new_std_menu() since we don't have them yet.
> 
> Kind regards,

-- 
Regards,

Laurent Pinchart
