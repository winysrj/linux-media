Return-path: <mchehab@pedra>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:56378 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab1BWVwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 16:52:25 -0500
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Wed, 23 Feb 2011 22:40:39 +0100
To: linux-media@vger.kernel.org
Cc: steven.toth@me.com
Subject: DVB header file license question
Message-ID: <20110223214039.GA15646@triton8.kn-bremen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

 I hate license discussions as much as the next guy, but...  I have
made patches to add DVB ioctl support to FreeBSD's Linux compatibility
layer:

	http://people.freebsd.org/~nox/dvb/linux-dvb-2nd.patch
	(for FreeBSD-current aka the head branch)

	http://people.freebsd.org/~nox/dvb/linux-dvb-2nd-8.patch
	(for FreeBSD 8)

and I was asked to request relicensing of the parts I took from
<linux/dvb/frontend.h> under a BSD license.  That's
src/sys/compat/linux/linux_dvb.h in the patches (also attached),
basically I took the #define.s and structs for FE_[GS]ET_PROPERTY
as those were the only ioctls needing 32/64 bit stuct size
translations (other than some in osd.h and video.h that no drivers
we use support.)

 It seems those parts were authored by Steven Toth, so I added
him to the Cc.

 The same relicensing had been done for <linux/videodev.h> earlier
(except that that file itself didn't have a license), and I see
<linux/videodev2.h> is dual-licensed too, so I hope it can be done
in this case too.

 Thanx!
	Juergen

--lrZ03NoBR/3+SXJZ
Content-Type: text/x-chdr; charset=us-ascii
Content-Disposition: attachment; filename="linux_dvb.h"

/*
 * Extracted from <linux/dvb/frontend.h>, which is:
 *
 * Copyright (C) 2000 Marcus Metzler <marcus@convergence.de>
 *		    Ralph  Metzler <ralph@convergence.de>
 *		    Holger Waechtler <holger@convergence.de>
 *		    Andre Draszik <ad@convergence.de>
 *		    for convergence integrated media GmbH
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2.1
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 */

#ifndef __LINUX_DVB_H
#define __LINUX_DVB_H

#include <sys/types.h>

struct dtv_property {
	uint32_t cmd;
	uint32_t reserved[3];
	union {
		uint32_t data;
		struct {
			uint8_t data[32];
			uint32_t len;
			uint32_t reserved1[3];
			void *reserved2;
		} buffer;
	} u;
	int result;
} __attribute__ ((packed));

/* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
#define DTV_IOCTL_MAX_MSGS 64

struct dtv_properties {
	uint32_t num;
	struct dtv_property *props;
};

#define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
/* 
 * This is broken on linux as well but they workaround it in the driver.
 * Since this is impossible to do on FreeBSD fix the header instead.
 * Detailed and discussion :
 * http://lists.freebsd.org/pipermail/freebsd-multimedia/2010-April/010958.html
 */
#define FE_GET_PROPERTY		   _IOW('o', 83, struct dtv_properties)

#endif /*__LINUX_DVB_H*/

--lrZ03NoBR/3+SXJZ--
