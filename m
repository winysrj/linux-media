Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:41565 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752961AbeBEOhb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 09:37:31 -0500
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux-input@vger.kernel.org, modin@yuri.at
Subject: [PATCH 0/5] [RFC] add video controls to SUR40 driver
Date: Mon,  5 Feb 2018 15:29:36 +0100
Message-Id: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SUR40 (aka Pixelsense) has internal registers that expose sensor
parameters such as brightness, gain etc. This patch creates V4L2
control items and maps them to the appropriate parameters.

This is an initial submission for review, comments welcome!

Best regards, Florian
