Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39104 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbZHQUD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 16:03:27 -0400
From: "Sikka, Neil" <neilsikka@ti.com>
To: "Sikka, Neil" <neilsikka@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Mon, 17 Aug 2009 15:03:20 -0500
Subject: RE: [PATCH v1 0/4] Adding capture support for DM365 device
Message-ID: <A69FA2915331DC488A831521EAE36FE40145300E72@dlee06.ent.ti.com>
References: <1250537679-2239-1-git-send-email-neilsikka@ti.com>
In-Reply-To: <1250537679-2239-1-git-send-email-neilsikka@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please disregard the previous patch. I am sending one with corrected Subject fields.

-----Original Message-----
From: Sikka, Neil 
Sent: Monday, August 17, 2009 3:35 PM
To: linux-media@vger.kernel.org; davinci-linux-open-source@linux.davincidsp.com
Cc: khilman@deeprootsystems.com; hverkuil@xs4all.nl; Sikka, Neil
Subject: [PATCH v1 0/4] Adding capture support for DM365 device

From: Neil Sikka <neilsikka@ti.com>

This patch series adds support for the VPSS capture on the DM365 SOC.
Specifically, it supports the CCDC/ISIF module. This code has been tested and
works with the TVP5146 decoder (using the tvp514x driver). During testing of
this code, the NTSC capture format was used. This patch depends on previous
other patches contributed by Muralidharan Karicheri. Please see the individual
patch notes for dependency details. The patches contained in this patch set are:

1) DM365 Platform support for VPFE-additions to the DM365 SOC files
2) DM365 VPSS support-additions to the VPSS.h and VPSS.c files
3) CCDC support on DM365-the actual DM365 CCDC driver and its supporting files

NOTE: All patches are to be applied before build.

Mandatory reviewers:
Hans Verkuil <hverkuil@xs4all.nl> for V4L tree
Kevin Hilman <khilman@deeprootsystems.com> for DaVinci tree

Reviewed-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Signed-off-by: Neil Sikka <neilsikka@ti.com>
