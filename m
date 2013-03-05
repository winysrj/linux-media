Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab3CEMc6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Mar 2013 07:32:58 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r25CWw3h026572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 5 Mar 2013 07:32:58 -0500
Received: from localhost.localdomain (vpn1-5-66.gru2.redhat.com [10.97.5.66])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r25CWtio029068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 5 Mar 2013 07:32:57 -0500
Date: Tue, 5 Mar 2013 09:32:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] Changes at the master repository (media-tree.git)
Message-ID: <20130305093255.4595eb49@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I did today one change at the master driver development repository.

In the past, we used to have per-kernel release branches. The rationale is that
we were doing rebases on each new version, when we migrated from hg to git.

Well, we don't do such rebases anymore; instead, when a new version comes, we
just merge from Linus tree (typically at *-rc1). So, we don't need that schema
anymore.

Also, as we'll now have sub-maintainers, it is better to keep the branch
namespace ready for topic branches.

So, I renamed all previous "staging/for*" branches to "staging/for*" tags.

Also, we'll now be using the "master" branch for development.

Except for the noise during this transition phase, I expect that this
way, it will be easier for developers, as they don't need anymore to
track when a new "staging/for*" branch is created, in order to do their
work.

It also prevents me and others to change any existing auto-building script
to work with the newly "staging/for*" branch when it is created.

Regards,
Mauro
