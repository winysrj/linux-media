Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2451 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZHJGH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 02:07:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: chaithrika <chaithrika@ti.com>
Subject: vpif_display.c bug
Date: Mon, 10 Aug 2009 08:07:23 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908100807.23455.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chaithrika,

This code in vpif_display.c is not correct:

        for (i = 0; i < subdev_count; i++) {
                vpif_obj.sd[i] = v4l2_i2c_new_probed_subdev(&vpif_obj.v4l2_dev,
                                                i2c_adap, subdevdata[i].name,
                                                subdevdata[i].name,
                                                &subdevdata[i].addr);
                if (!vpif_obj.sd[i]) {
                        vpif_err("Error registering v4l2 subdevice\n");
                        goto probe_subdev_out;
                }

                if (vpif_obj.sd[i])
                        vpif_obj.sd[i]->grp_id = 1 << i;
        }

This: '&subdevdata[i].addr' should be: I2C_ADDRS(subdevdata[i].addr).

The list of probe addresses must be terminated by I2C_CLIENT_END (= -1) and
that isn't the case here.

An alternative solution is to use v4l2_i2c_new_subdev, but then no probing
will take place. But I think that you don't want probing at all since this
address information comes from the platform data, so one can assume that
that data is correct.

Even better is to copy the implementation from vpfe_capture.c and to use
v4l2_i2c_new_subdev_board().

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
