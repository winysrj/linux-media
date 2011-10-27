Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1J0LTf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Oct 2011 07:19:35 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: uvcvideo: Add support for control events
Date: Thu, 27 Oct 2011 13:19:50 +0200
Message-Id: <1319714392-4406-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This patch set adds support for control events to the uvcvideo driver. Note
this patch set depends on the "Various ctrl and event frame work patches"
set which I just send out.

Regards,

Hans
