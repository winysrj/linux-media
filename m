Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4515 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060Ab2D0JjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:39:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: [RFC PATCH 3/3] [media] gspca - main: implement vidioc_g_ext_ctrls and vidioc_s_ext_ctrls
Date: Fri, 27 Apr 2012 11:34:18 +0200
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org,
	Erik =?utf-8?q?Andr=C3=A9n?= <erik.andren@gmail.com>
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it> <201204271020.23880.hverkuil@xs4all.nl> <20120427112443.7edd32f3@tele>
In-Reply-To: <20120427112443.7edd32f3@tele>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204271134.18893.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, April 27, 2012 11:24:43 Jean-Francois Moine wrote:
> On Fri, 27 Apr 2012 10:20:23 +0200
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > I might have some time (no guarantees yet) to help with this. It would
> > certainly be interesting to add support for the control framework in the
> > gspca core. Hmm, perhaps that's a job for the weekend...
> 
> Hi Hans,
> 
> I hope you will not do it! The way gspca treats the controls is static,
> quick and very small. The controls in the subdrivers ask only for the
> declaration of the controls and functions to send the values to the
> webcams. Actually, not all subdrivers have been converted to the new
> gspca control handling, but, when done, it will save more memory.

And that is exactly what the control framework also does for you. Drivers
only have to declare the controls and have a function to set their value.
Everything else is handled by the control framework. And you get support
for the extended control API for free and also support for control events,
plus any future changes/enhancements to how controls are done will be
automatically added. Not to mention that it ensures consistent and correct
behavior of the control API towards applications.

Note that the control code is already part of videodev.ko, so you have that
code in memory anyway. So why not use it?

Regards,

	Hans
