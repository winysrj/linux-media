Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab0CLAV4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 19:21:56 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2C0LuuG027262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 19:21:56 -0500
Message-ID: <4B99891E.9010406@redhat.com>
Date: Thu, 11 Mar 2010 21:21:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans De Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: pushes at v4l-utils tree
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

As we've agreed that the idea is to allow multiple people to commit at v4l-utils,
today, I've added 3 commits at v4l-utils tree (2 keycode-related and 1 is .gitignore
stuff). One of the reasons were to test the viability for such commits.

I've temporarily enabled the same script that we use for upstream patches to
generate patches against linuxtv-commits ML.

>From my experiences, I have some notes:
	1) git won't work fine if more than one is committing at the same tree.
The reason is simple: it won't preserve the same group as the previous commits. So,
the next committer will have troubles if we allow multiple committers;

	2) people need to pull/rebase before pushing, if we fix the group permission
issue above. I've enabled a hook that is meant to avoid rebase upstream, to prevent
troubles if people push something with -f. I hope it works fine.

	3) the mailbomb script uses the from: as the email author. However, the
linuxtv-commits is limited to posts from a few specific authors. So, I need to add
more emails there or change the policy, if we decide to use such script.
I'll keep the script disabled for now, until I have some time to check it.

In summary, for now, I think that the better is to post all patches to v4l-utils at ML
and ask Hans to merge them.

-- 

Cheers,
Mauro
