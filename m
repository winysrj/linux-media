Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1246 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZHKL5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 07:57:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: vpif_display.c bug
Date: Tue, 11 Aug 2009 08:35:06 +0200
Cc: "Subrahmanya, Chaithrika" <chaithrika@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200908100807.23455.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE401451FC39E@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401451FC39E@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908110835.06215.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 10 August 2009 17:07:51 Karicheri, Muralidharan wrote:
> Hans,
> 
> I have already changed v4l2_i2c_new_probed_subdev() to v4l2_i2c_new_subdev_board() in my latest patch set for adding vpif capture driver for DM6467 that you had reviewed. I think this change is not needed
> once that patch is applied.

You are right. Hmm, I really have a bad memory for these things, I reviewed
it only last Friday :-(

Regards,

	Hans

> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> new phone: 301-407-9583
> Old Phone : 301-515-3736 (will be deprecated)
> email: m-karicheri2@ti.com
> 
> >-----Original Message-----
> >From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >owner@vger.kernel.org] On Behalf Of Hans Verkuil
> >Sent: Monday, August 10, 2009 2:07 AM
> >To: Subrahmanya, Chaithrika
> >Cc: linux-media@vger.kernel.org
> >Subject: vpif_display.c bug
> >
> >Hi Chaithrika,
> >
> >This code in vpif_display.c is not correct:
> >
> >        for (i = 0; i < subdev_count; i++) {
> >                vpif_obj.sd[i] =
> >v4l2_i2c_new_probed_subdev(&vpif_obj.v4l2_dev,
> >                                                i2c_adap,
> >subdevdata[i].name,
> >                                                subdevdata[i].name,
> >                                                &subdevdata[i].addr);
> >                if (!vpif_obj.sd[i]) {
> >                        vpif_err("Error registering v4l2 subdevice\n");
> >                        goto probe_subdev_out;
> >                }
> >
> >                if (vpif_obj.sd[i])
> >                        vpif_obj.sd[i]->grp_id = 1 << i;
> >        }
> >
> >This: '&subdevdata[i].addr' should be: I2C_ADDRS(subdevdata[i].addr).
> >
> >The list of probe addresses must be terminated by I2C_CLIENT_END (= -1) and
> >that isn't the case here.
> >
> >An alternative solution is to use v4l2_i2c_new_subdev, but then no probing
> >will take place. But I think that you don't want probing at all since this
> >address information comes from the platform data, so one can assume that
> >that data is correct.
> >
> >Even better is to copy the implementation from vpfe_capture.c and to use
> >v4l2_i2c_new_subdev_board().
> >
> >Regards,
> >
> >	Hans
> >
> >--
> >Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
