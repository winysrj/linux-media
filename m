Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:44003 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753695AbeBGNAo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 08:00:44 -0500
From: Florian Echtler <floe@butterbrot.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
Subject: [PATCH v3] add video controls for SUR40 driver
Date: Wed,  7 Feb 2018 14:00:34 +0100
Message-Id: <1518008438-26603-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed previously, here's the third iteration of my patch to add
control functions for the SUR40 driver, with (hopefully) correct handling
of default values/module parameters, using the V4L2 control framework.

Best regards, Florian
