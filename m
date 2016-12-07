Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:56121 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752748AbcLGKpE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Dec 2016 05:45:04 -0500
Date: Wed, 7 Dec 2016 10:45:01 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 00/13] Use sysfs filter for winbond & nuvoton wakeup
Message-ID: <20161207104501.GA21260@gofer.mess.org>
References: <cover.1481019109.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1481019109.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 06, 2016 at 10:19:08AM +0000, Sean Young wrote:
> This patch series resurrects an earlier series with a new approach.

I've discovered some bugs in this series. Protocol modules are not
autoloaded and rc-loopback and is missing the wakeup_protocols sysfs file.

Please treat this series as RFC while I fix the issues and do more testing.


Sean
