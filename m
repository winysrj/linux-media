Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51873 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933512AbcIEN62 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 09:58:28 -0400
Date: Mon, 5 Sep 2016 16:58:25 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 1/2] [media] tw5864-core: remove double irq lock code
Message-ID: <20160905135825.6jjnew5acovhp4oz@zver>
References: <c5f789d7d85f4c4b6bcdb2b1674d6495f05ada42.1472056235.git.mchehab@s-opensource.com>
 <1472136366.1628907.705944009.76C1558A@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1472136366.1628907.705944009.76C1558A@webmail.messagingengine.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just received a notification from patchwork that my alternative patch on
this was rejected as not applicable.

Thanks to Hans Verkuil - he has applied a reversion of Mauro's wrong
patch and also applied my patch in his repo,
git://linuxtv.org/hverkuil/media_tree.git (branch for-v4.9c).

As I see the wrong patch is in git://linuxtv.org/media_tree.git master
branch, and is considered "merged", but I would love to see that wrong
patch (and reversion of it) dropped before it gets into linux-next (I
don't know whether media tree has a tradition to not reset branches).
