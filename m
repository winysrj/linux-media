Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:59776 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753998AbeBFVB4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 16:01:56 -0500
From: Florian Echtler <floe@butterbrot.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
Subject: [PATCH v2] [RFC] add video controls for SUR40 driver
Date: Tue,  6 Feb 2018 22:01:40 +0100
Message-Id: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed previously, here's a second iteration of my patch to add
control functions for the SUR40 driver, now using the V4L2 control
framework.
