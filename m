Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53226 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2IZJsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 05:48:14 -0400
Received: by wgbdr13 with SMTP id dr13so357301wgb.1
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 02:48:13 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, mchehab@infradead.org, hverkuil@xs4all.nl
Subject: [PATCH 0/5] media: ov7670: driver cleanup and support for ov7674.
Date: Wed, 26 Sep 2012 11:47:52 +0200
Message-Id: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following series includes all the changes discussed in [1] that
don't affect either bridge drivers that use ov7670 or soc-camera framework
For this reason they are considered non controversial and sent separately.
At least 1 more series will follow in order to implement all features
described in [1].



[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg51778.html
