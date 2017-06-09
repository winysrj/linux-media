Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58648 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751672AbdFIJUc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 05:20:32 -0400
Date: Fri, 9 Jun 2017 12:20:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com
Subject: Re: [PATCH 11/12] intel-ipu3: Add imgu v4l2 driver
Message-ID: <20170609092028.GM1019@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-12-git-send-email-yong.zhi@intel.com>
 <7e246180-8c9b-f4bd-d90e-e55141bf4a38@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e246180-8c9b-f4bd-d90e-e55141bf4a38@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Jun 06, 2017 at 11:08:07AM +0200, Hans Verkuil wrote:
> > +		/* Initialize vdev */
> > +		strlcpy(vdev->name, node->name, sizeof(vdev->name));
> > +		vdev->release = video_device_release_empty;
> > +		vdev->fops = &m2m2->v4l2_file_ops;
> > +		vdev->ioctl_ops = &ipu3_v4l2_ioctl_ops;
> > +		vdev->lock = &node->lock;
> > +		vdev->v4l2_dev = &m2m2->v4l2_dev;
> > +		vdev->queue = &node->vbq;
> > +		vdev->vfl_dir = node->output ? VFL_DIR_TX : VFL_DIR_RX;
> 
> Why have two video nodes (one tx, one rx) instead of a single m2m device
> node?
> 
> I'm not saying this is wrong, I just like to know the rationale for this
> design.

There are a bunch of outputs from the same input stream. Also the parameters
are needed to process the frame, I think there are two OUTPUT devices and
five CAPTURE devices.

Yong: could you send the media graph of the device, please?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
