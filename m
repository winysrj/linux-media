Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41651 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1KXXJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 18:09:45 -0500
Received: by bke11 with SMTP id 11so3562511bke.19
        for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 15:09:43 -0800 (PST)
Message-ID: <4ECECEB4.9010801@gmail.com>
Date: Fri, 25 Nov 2011 00:09:40 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: [RFC/PATCH 0/3] 64-bit integer menus
References: <20111124161228.GA29342@valkosipuli.localdomain>
In-Reply-To: <20111124161228.GA29342@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thanks for the patches.

On 11/24/2011 05:12 PM, Sakari Ailus wrote:
> Hi all,
> 
> This patchset, which I'm sending as RFC since it has not been really tested
> (including compiling the vivi patch), adds 64-bit integer menu controls. The
> control items in the integer menu are just like in regular menus but they
> are 64-bit integers instead of strings.
> 
> I'm also pondering whether to assign 1 to ctrl->step for menu type controls
> as well but haven't checked what may have been the original reason to
> implement it as it is now implemented.
> 
> The reason why I don't use a union for qmenu and qmenu_int in
> v4l2_ctrl_config is that a lot of drivers use that field in the initialiser
> and GCC<  4.6 does not support initialisers with anonymous unions.
> 
> Similar union is created in v4l2_querymenu but I do not see this as a
> problem since I do not expect initialisers to be used with this field in the
> user space code.
> 
> Comments and questions are welcome.

I've gone briefly through the patches and they seem to realize exactly what
I needed. I think we've discussed the integer menu controls during the Cambourne 
meeting, however I wasn't sure yesterday if it was just this.

I'll try and implement some of the controls for m5mols based on your patches.
Cannot guarantee I'll manage to have something ready for 3.3, I need to finish 
a few other things before I get to this. 

-- 
Thanks,
Sylwester
