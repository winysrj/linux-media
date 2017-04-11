Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59148
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751921AbdDKLkF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 07:40:05 -0400
Date: Tue, 11 Apr 2017 08:39:58 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCHv4 00/15] R-Car VSP1 Histogram Support
Message-ID: <20170411083958.2b738595@vento.lan>
In-Reply-To: <20170410192651.18486-1-hverkuil@xs4all.nl>
References: <20170410192651.18486-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Mon, 10 Apr 2017 21:26:36 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series is the rebased version of this pull request:
> 
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg111025.html
> 
> It slightly modifies 'Add metadata buffer type and format' (remove
> experimental note and add newline after label) and it adds support
> for V4L2_CTRL_FLAG_MODIFY_LAYOUT, as requested by Mauro.
> 
> No other changes were made.

Patch series look ok. I found just one typo on one of the patches.

What seems to be missing here is to set the GRABBED flag for controls
that modify layout but don't allow control update while streaming.

While it is OK to do such change for the existing drivers later
(as this is actually a bug fix), I would be expecting such change
for the controls used at the vsp1 driver, as, from what I'm seeing
at the code, vsp1_wpf_s_ctrl() will block changing any controls in
runtime. So, wpf_init_controls() should mark all such controls with
V4L2_CTRL_FLAG_GRABBED[1].

Could you please add such patch at the end of this patchset?

Thanks!
Mauro

[1] I don't see any reason why not allowing HFLIP/VFLIP controls
to be handled in realtime (except if the hardware itself doesn't
allow), but the current code doesn't allow such changes in
realtime anymore. Perhaps the code could be less pick in the
future.

Thanks,
Mauro
