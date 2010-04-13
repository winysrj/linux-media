Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:8980 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab0DMJTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Apr 2010 05:19:46 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhu, Daniel" <daniel.zhu@intel.com>,
	"Bian, Jonathan" <jonathan.bian@intel.com>
Date: Tue, 13 Apr 2010 17:19:38 +0800
Subject: [RFC] support more color effects by extending the V4L2_CID_COLORFX
 user contorl ID
Message-ID: <33AB447FBD802F4E932063B962385B351D84C129@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi linux-media, 
 
Current V4l2 support a limited image effects (black white and sepia) and this is a RFC to support more color effects by extending the V4L2_CID_COLORFX user control ID, these effects are not platform specific and are available in mainstream digital camera devices, and will be supported by the ISP on Intel Atom platforms.

The image effects are listed as in below, we are proposing to extend V4L2_CID_COLORFX to support them:

V4L2_COLORFX_NEGATIVE - negative image effect.
V4L2_COLORFX_EMBOSS - emboss image effect
V4L2_COLORFX_SKETECH - sketch image effect
V4L2_COLORFX_SKY_BLUE - sky blue image effect
V4L2_COLORFX_GRASS_GREEN - grass green image effect
V4L2_COLORFX_SKIN_WHITEN - skin whiten image effect 
V4L2_COLORFX_VIVID - vivid image effect

The v4l2_colorfx also needs to contain more enum items (as in below) to support them, welcome any comment and suggest. 

enum v4l2_colorfx {
	V4L2_COLORFX_DEFAULT	= 0,
	V4L2_COLORFX_BW		= 1,
	V4L2_COLORFX_SEPIA	= 2,
	V4L2_COLORFX_NEGATIVE = 3, 
	V4L2_COLORFX_EMBOSS =4,
	V4L2_COLORFX_SKETECH =5, 
	V4L2_COLORFX_SKY_BLUE =6, 
	V4L2_COLORFX_GRASS_GREEN =7,
	V4L2_COLORFX_SKIN_WHITEN = 8, 
	V4L2_COLORFX_VIVID = 9,
};

BRs
Xiaolin
