Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:53060 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932533AbbICPYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2015 11:24:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: gjasny@googlemail.com
Subject: [PATCH 0/2] v4l-utils: new configure options
Date: Thu,  3 Sep 2015 17:23:14 +0200
Message-Id: <1441293796-16972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gregor,

Can you take a look at this to see if I did this correctly? I'm no
autoconf hero, so before I push I'd like some feedback.

The main reason for these changes is that I need to build v4l2-ctl for
an embedded system and rather than having to hack on my side, I prefer
to add configure options that do what I (and probably others) want.

Regards,

        Hans

