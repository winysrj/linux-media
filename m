Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2629 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaF0OPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 10:15:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: it@sca-uk.com, =stoth@kernellabs.com
Subject: [PATCH 0/2] cx23885: add support for Hauppauge ImpactVCB-e
Date: Fri, 27 Jun 2014 16:15:40 +0200
Message-Id: <1403878542-1230-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This has been sitting in my queue for some time now. I've cleaned it
up and it should be ready for 3.17.

The main problem was related to inconsistent use of UNSET and
TUNER_ABSENT to denote an absent tuner (as is the case of this new
Hauppauge device). So the first patch cleans that up first.

Regards,

        Hans

