Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp106.ord1c.emailsrvr.com ([108.166.43.106]:46400 "EHLO
        smtp106.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752011AbdHGGbm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 02:31:42 -0400
Received: from smtp14.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp14.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 57941C03BB
        for <linux-media@vger.kernel.org>; Mon,  7 Aug 2017 02:25:14 -0400 (EDT)
Received: from smtp14.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp14.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 56057C043C
        for <linux-media@vger.kernel.org>; Mon,  7 Aug 2017 02:25:14 -0400 (EDT)
Received: by smtp14.relay.ord1c.emailsrvr.com (Authenticated sender: edgar.thier-AT-theimagingsource.com) with ESMTPSA id 0A868C03BB
        for <linux-media@vger.kernel.org>; Mon,  7 Aug 2017 02:25:13 -0400 (EDT)
From: Edgar Thier <edgar.thier@theimagingsource.com>
To: linux-media@vger.kernel.org
Subject: UVC property auto update
Message-ID: <c3f8b20a-65f9-ead3-9ffd-041641254af7@theimagingsource.com>
Date: Mon, 7 Aug 2017 08:25:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have some USB-3.0 cameras that use UVC.
These cameras offer auto updates for various properties.
An example of such a property would be gain, that will be adjusted when activating the auto-gain
property. These property changes are not queried by the UVC driver, unless it already has the
property marked as auto update via UVC_CTRL_FLAG_AUTO_UPDATE.
>From what I have seen, it seems that this flag is not checked when indexing the camera controls.
However it is checked when using extension units, so all properties loaded through such a unit are
being updates as one would hope.

My questions:

Is it intended that properties cannot mark themselves as autoupdate?
If yes:
	Is there a recommended way of working around this?
	Do all autoupdate properties have to be in an extension unit?
If no:
	What should a fix look like?

Regards,

Edgar
