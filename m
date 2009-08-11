Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58219 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbZHKLvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 07:51:06 -0400
From: "chaithrika" <chaithrika@ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>
References: <200908100807.23455.hverkuil@xs4all.nl> <024e01ca19b9$36c64c90$a452e5b0$@com> <A69FA2915331DC488A831521EAE36FE401451FC3A4@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401451FC3A4@dlee06.ent.ti.com>
Subject: RE: vpif_display.c bug
Date: Tue, 11 Aug 2009 15:21:40 +0530
Message-ID: <02c501ca1a69$53513680$f9f3a380$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 10, 2009 at 20:39:05, Karicheri, Muralidharan wrote:
> Chaithrika,
> 
> No need to change this since this is already corrected as part of my vpif capture patch set that I had submitted for review. I had mentioned this to Hans as well.
> 
Murali,

Thank you for correcting this bug in your patch set. 

Regards, 
Chaithrika

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
> >owner@vger.kernel.org] On Behalf Of Subrahmanya, Chaithrika
> >Sent: Monday, August 10, 2009 8:51 AM
> >To: 'Hans Verkuil'
> >Cc: linux-media@vger.kernel.org
> >Subject: RE: vpif_display.c bug
> >
> >On Mon, Aug 10, 2009 at 11:37:23, Hans Verkuil wrote:
> >> Hi Chaithrika,
> >>
> >> This code in vpif_display.c is not correct:
> >>
> >>         for (i = 0; i < subdev_count; i++) {
> >>                 vpif_obj.sd[i] =
> >v4l2_i2c_new_probed_subdev(&vpif_obj.v4l2_dev,
> >>                                                 i2c_adap,
> >subdevdata[i].name,
> >>                                                 subdevdata[i].name,
> >>                                                 &subdevdata[i].addr);
> >>                 if (!vpif_obj.sd[i]) {
> >>                         vpif_err("Error registering v4l2 subdevice\n");
> >>                         goto probe_subdev_out;
> >>                 }
> >>
> >>                 if (vpif_obj.sd[i])
> >>                         vpif_obj.sd[i]->grp_id = 1 << i;
> >>         }
> >>
> >> This: '&subdevdata[i].addr' should be: I2C_ADDRS(subdevdata[i].addr).
> >>
> >> The list of probe addresses must be terminated by I2C_CLIENT_END (= -1)
> >and
> >> that isn't the case here.
> >>
> >> An alternative solution is to use v4l2_i2c_new_subdev, but then no
> >probing
> >> will take place. But I think that you don't want probing at all since
> >this
> >> address information comes from the platform data, so one can assume that
> >> that data is correct.
> >>
> >> Even better is to copy the implementation from vpfe_capture.c and to use
> >> v4l2_i2c_new_subdev_board().
> >>
> >
> >Hans,
> >Thank you for the suggestions.
> >I will look into this and submit a patch to correct this bug.
> >
> >Regards,
> >Chaithrika
> >
> >> Regards,
> >>
> >> 	Hans
> >>
> >> --
> >> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> >>
> >
> >
> >
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


