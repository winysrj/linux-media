Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:16872 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2HGNNA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 09:13:00 -0400
From: Konke Radlow <kradlow@cisco.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com, koradlow@gmail.com
Subject: [RFC PATCH 0/2] Add support for RDS decoding (updated) 
Date: Tue,  7 Aug 2012 15:11:53 +0000
Message-Id: <1344352315-1184-1-git-send-email-kradlow@cisco.com>
In-Reply-To: <[RFC PATCH 0/2] Add support for RDS decoding>
References: <[RFC PATCH 0/2] Add support for RDS decoding>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
first of all: thank you for the comments to my previous RFC for the
libv4l2rds library and the rds-ctl control & testing tool.
The proposed changes have been implemented, and the code has been     
further improved after a thorough code review by Hans Verkuil.

Changes:
  -the code is rebased on the latest v4l-utils code (as of today 07.08)
  -added feature: time/date decoding
  -implementing proposed changes
  -code cleanup
  -extended comments

Status:
>From my point of view the RDS decoding is now almost feature complete.
There are some obscure RDS features like paging that are not supported,
but they do not seem to used anywhere. 
So in the near future no features will be added and the goal is to get 
the library and control tool merged into the v4l-utils codebase.

Upcoming:
Work on RDS-TMC decoding is going well and is being done in a seperate 
branch. It will be the subject of a future RFC, once it has reached a 
mature stage. But TMC is not a core feature of RDS but an addition.

Regards,
Konke

