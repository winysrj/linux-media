Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:18865 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZC3FeC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 01:34:02 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2401576wff.4
        for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 22:34:00 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Mar 2009 14:34:00 +0900
Message-ID: <5e9665e10903292234u3023af4elb9ebf7a1956362c8@mail.gmail.com>
Subject: [RFC] Is it looking good enough controlling white balance through
	existing V4L2 API?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Bill Dirks <bill@thedirks.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

Last few days, I've got a big question popping up handling white
balance with V4L2_CID_WHITE_BALANCE_TEMPERATURE CID.

Because in digital camera we generally control over user interface
with pre-defined white balance name. I mean, user controls white
balance with presets not with kelvin number.
I'm very certain that TEMPERATURE CID is needed in many of video
capture devices, but also 100% sure that white balance preset control
is also necessary for digital cameras.
How can we control white balance through preset name with existing V4L2 API?
For now, I define preset names in user space with supported color
temperature preset in driver like following.

#define MANUAL_WB_TUNGSTEN 3000
#define MANUAL_WB_FLUORESCENT 4000
#define MANUAL_WB_SUNNY 5500
#define MANUAL_WB_CLOUDY 6000

and make driver to handle those presets like this. (I split in several
ranges to make driver pretend to be generic)

case V4L2_CID_WHITE_BALANCE_TEMPERATURE:
		if (vc->value < 3500) {
			/* tungsten */
			err = ce131f_cmds(c, ce131f_wb_tungsten);
		} else if (vc->value < 4100) {
			/* fluorescent */
			err = ce131f_cmds(c, ce131f_wb_fluorescent);
		} else if (vc->value < 6000) {
			/* sunny */
			err = ce131f_cmds(c, ce131f_wb_sunny);
		} else if (vc->value < 6500) {
			/* cloudy */
			err = ce131f_cmds(c, ce131f_wb_cloudy);
		} else {
			printk(KERN_INFO "%s: unsupported kelvin range\n", __func__);
		}
		......

I think this way seems to be ugly. Don't you think that another CID is
necessary to handle WB presets?
Because most of mobile camera modules can't make various color
temperatures in expecting kelvin number with user parameter.
Any opinion will be appreciated.
Regards,

Nate
