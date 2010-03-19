Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:37819 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0CSSfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 14:35:33 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id o2JIZUlV019096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 13:35:32 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>
Date: Sat, 20 Mar 2010 00:05:23 +0530
Subject: RE: [PATCH-V2 7/7] TVP514x: Add Powerup sequence during s_input to
 lock the signal properly
Message-ID: <19F8576C6E063C45BE387C64729E7394044DE0E3FF@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1268978653-32710-8-git-send-email-hvaibhav@ti.com>
 <A69FA2915331DC488A831521EAE36FE4016A6ECBC9@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016A6ECBC9@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Karicheri, Muralidharan
> Sent: Friday, March 19, 2010 11:40 PM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Cc: Rajashekhara, Sudhakar
> Subject: RE: [PATCH-V2 7/7] TVP514x: Add Powerup sequence during s_input to
> lock the signal properly
> 
> Vaibhav,
> 
> This patch has not fully resolved the lock issue. In my testing the change
> done by Brijesh was required as well. Can you update me on what was your
> findings based on my last email on this issue?
> 
[Hiremath, Vaibhav] Murali,

I think I had already explained it to you, let me explain it again for broader audience.

We are talking about two different issues here - 

- The default state of TVP514x after reset is active state, but when you execute streamoff then driver will put TVP514x into powered down state, which will cause locking issues when you try to S_INPUT next time. Since power on sequence will only be get executed during streamon.

This is valid bug in the driver, which this patch addresses.

- The second issue is related to auto switch feature and detected/set standard. The fix which you are talking about is putting TVP514x in auto switch mode in QUERYSTD. This is only required when application sets the standard explicitly and the spec says that the standard should not change unless set explicitly by the user. And since user is very well aware of what he is doing. 

I had a good discussion with Hans on this; please refer to the link below

http://www.mail-archive.com/linux-media@vger.kernel.org/msg11518.html

I was about to re-initiate this thread, since we did not have any conclusion last time.

I hope this clears all your doubts.

Thanks,
Vaibhav

> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2@ti.com
> 
> >-----Original Message-----
> >From: Hiremath, Vaibhav
> >Sent: Friday, March 19, 2010 2:04 AM
> >To: linux-media@vger.kernel.org
> >Cc: Karicheri, Muralidharan; Hiremath, Vaibhav; Rajashekhara, Sudhakar
> >Subject: [PATCH-V2 7/7] TVP514x: Add Powerup sequence during s_input to
> >lock the signal properly
> >
> >From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> >For the sequence streamon -> streamoff and again s_input, it fails
> >to lock the signal, since streamoff puts TVP514x into power off state
> >which leads to failure in sub-sequent s_input.
> >
> >So add powerup sequence in s_routing (if disabled), since it is
> >important to lock the signal at this stage.
> >
> >Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> >Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
> >---
> > drivers/media/video/tvp514x.c |   13 +++++++++++++
> > 1 files changed, 13 insertions(+), 0 deletions(-)
> >
> >diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> >index 26b4e71..97b7db5 100644
> >--- a/drivers/media/video/tvp514x.c
> >+++ b/drivers/media/video/tvp514x.c
> >@@ -78,6 +78,8 @@ struct tvp514x_std_info {
> > };
> >
> > static struct tvp514x_reg tvp514x_reg_list_default[0x40];
> >+
> >+static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
> > /**
> >  * struct tvp514x_decoder - TVP5146/47 decoder object
> >  * @sd: Subdevice Slave handle
> >@@ -643,6 +645,17 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
> > 		/* Index out of bound */
> > 		return -EINVAL;
> >
> >+	/*
> >+	 * For the sequence streamon -> streamoff and again s_input
> >+	 * it fails to lock the signal, since streamoff puts TVP514x
> >+	 * into power off state which leads to failure in sub-sequent s_input.
> >+	 *
> >+	 * So power up the TVP514x device here, since it is important to lock
> >+	 * the signal at this stage.
> >+	 */
> >+	if (!decoder->streaming)
> >+		tvp514x_s_stream(sd, 1);
> >+
> > 	input_sel = input;
> > 	output_sel = output;
> >
> >--
> >1.6.2.4

