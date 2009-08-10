Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49123 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbZHJMw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 08:52:28 -0400
From: "chaithrika" <chaithrika@ti.com>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>
References: <200908100807.23455.hverkuil@xs4all.nl>
In-Reply-To: <200908100807.23455.hverkuil@xs4all.nl>
Subject: RE: vpif_display.c bug
Date: Mon, 10 Aug 2009 18:21:01 +0530
Message-ID: <024e01ca19b9$36c64c90$a452e5b0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 10, 2009 at 11:37:23, Hans Verkuil wrote:
> Hi Chaithrika,
> 
> This code in vpif_display.c is not correct:
> 
>         for (i = 0; i < subdev_count; i++) {
>                 vpif_obj.sd[i] = v4l2_i2c_new_probed_subdev(&vpif_obj.v4l2_dev,
>                                                 i2c_adap, subdevdata[i].name,
>                                                 subdevdata[i].name,
>                                                 &subdevdata[i].addr);
>                 if (!vpif_obj.sd[i]) {
>                         vpif_err("Error registering v4l2 subdevice\n");
>                         goto probe_subdev_out;
>                 }
> 
>                 if (vpif_obj.sd[i])
>                         vpif_obj.sd[i]->grp_id = 1 << i;
>         }
> 
> This: '&subdevdata[i].addr' should be: I2C_ADDRS(subdevdata[i].addr).
> 
> The list of probe addresses must be terminated by I2C_CLIENT_END (= -1) and
> that isn't the case here.
> 
> An alternative solution is to use v4l2_i2c_new_subdev, but then no probing
> will take place. But I think that you don't want probing at all since this
> address information comes from the platform data, so one can assume that
> that data is correct.
> 
> Even better is to copy the implementation from vpfe_capture.c and to use
> v4l2_i2c_new_subdev_board().
> 

Hans,
Thank you for the suggestions.
I will look into this and submit a patch to correct this bug.

Regards, 
Chaithrika

> Regards,
> 
> 	Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> 




