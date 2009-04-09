Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:2306 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZDIVud (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 17:50:33 -0400
Received: by wf-out-1314.google.com with SMTP id 29so812297wff.4
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2009 14:50:32 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Apr 2009 06:50:32 +0900
Message-ID: <5e9665e10904091450u3e70cda8w9e1d57e45365a32b@mail.gmail.com>
Subject: [RFC] White Balance control for digital camera
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, g.liakhovetski@gmx.de,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	laurent.pinchart@skynet.be
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

I'm posting this RFC one more time because it seems to everyone has
been forgot this, and I'll be appreciated if any of you who is reading
this mailing list give me comment.

I'm adding some choices for you to make it easier. (even the option
for that this is a pointless discussion)



I've got a big question popping up handling white balance with
V4L2_CID_WHITE_BALANCE_TEMPERATURE CID.

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
                       printk(KERN_INFO "%s: unsupported kelvin
range\n", __func__);
               }
               ......

I think this way seems to be ugly. Don't you think that another CID is
necessary to handle WB presets?
Because most of mobile camera modules can't make various color
temperatures in expecting kelvin number with user parameter.

So, here you are some options you can chose to give your opinion.(or
you can make your own opinion)

(A). Make a new CID to handle well known white balance presets
Like V4L2_CID_WHITE_BALANCE_PRESET for CID and enum values like
following for value

enum v4l2_whitebalance_presets {
     V4L2_WHITEBALANCE_TUNGSTEN  = 0,
     V4L2_WHITEBALANCE_FLUORESCENT,
     V4L2_WHITEBALANCE_SUNNY,
     V4L2_WHITEBALANCE_CLOUDY,
....

(B). Define well known kelvin number in videodev2.h as preset name and
share with user space
Like following

#define V4L2_WHITEBALANCE_TUNGSTEN 3000
#define V4L2_WHITEBALANCE_FLUORESCENT 4000
#define V4L2_WHITEBALANCE_SUNNY 5500
#define V4L2_WHITEBALANCE_CLOUDY 6000

and use those defined values with V4L2_CID_WHITE_BALANCE_TEMPERATURE

urgh.....

(C). Leave it alone. It's a pointless discussion. we are good with
existing WB API.
(really?)


I'm very surprised about this kind of needs were not issued yet.

Any opinion will be appreciated.
Regards,

Nate

-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
