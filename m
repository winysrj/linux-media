Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59074 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751368AbdH0Vp3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 17:45:29 -0400
Date: Mon, 28 Aug 2017 00:45:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        hdegoede@redhat.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: atomisp: constify v4l2_subdev_sensor_ops
Message-ID: <20170827214525.qw4oycwsrhvhcwim@valkosipuli.retiisi.org.uk>
References: <cc864898af00fc9e3e0e84246848b235aeb85aca.1503813075.git.arvind.yadav.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc864898af00fc9e3e0e84246848b235aeb85aca.1503813075.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arvind,

On Sun, Aug 27, 2017 at 11:26:39AM +0530, Arvind Yadav wrote:
> v4l2_subdev_sensor_ops are not supposed to change at runtime.
> v4l2_subdev_sensor_ops are working with const 'sensor' field of
> sturct v4l2_subdev_ops. So mark the non-const v4l2_subdev_sensor_ops
> structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Thanks for the patch. The change has already been made by this patch:

commit 65058214f5c2ebe844916b92d1bece64fd00206e
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Tue Aug 8 06:58:29 2017 -0400

    media: staging: media: atomisp: constify video_subdev structures
    
    These structures are both stored in fields of v4l2_subdev_ops
    structures, all of which are const, so these structures can be
    const as well.
    
    Done with the help of Coccinelle.
    
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
