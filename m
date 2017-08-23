Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60380 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdHWVUM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 17:20:12 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [RFC 0/3] Proof of concept to fix reference counting of DVB frontends
Date: Thu, 24 Aug 2017 00:20:36 +0300
Message-Id: <20170823212039.27751-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Following the discussion we had today on IRC, here's a proof of concept patch
that fixes the reference counting bug in the em28xx driver with the PCTV 520E.

The problem was noticed when the tuner driver was missing. The error handling
code path tried to free the frontend by calling dvb_frontend_detach(), which
can't operate properly if the frontend refcount field hasn't been initialized
yet.

This is a proof of concept only as it doesn't patch all frontend drivers to
call the dvb_frontend_init() function. You might also want to avoid bisection
problems, and possibly bikeshed function names. You could also add a Fixes tag
somewhere referencing

	commit 1f862a68df2449bc7b1cf78dce616891697b4bdf
	Author: Max Kellermann <max.kellermann@gmail.com>
	Date:   Tue Aug 9 18:32:51 2016 -0300

	    [media] dvb_frontend: move kref to struct dvb_frontend

although I think the problem preexisted that commit under another form.

Laurent Pinchart (3):
  dvb_frontend: Rename the dvb_frontend_init() function
  dvb_frontend: Add dvb_frontend_init() function
  media: drxk: Initialize the frontend after allocating it

 drivers/media/dvb-core/dvb_frontend.c   | 50 ++++++++++++++++++++-------------
 drivers/media/dvb-core/dvb_frontend.h   | 11 ++++++++
 drivers/media/dvb-frontends/drxk_hard.c |  5 ++++
 3 files changed, 46 insertions(+), 20 deletions(-)

-- 
Regards,

Laurent Pinchart
