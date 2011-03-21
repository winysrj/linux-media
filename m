Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab1CUTJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 15:09:27 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2LJ9QVr012152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 15:09:26 -0400
Received: from [10.3.229.63] (vpn-229-63.phx2.redhat.com [10.3.229.63])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p2LJ9Pl8017993
	for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 15:09:26 -0400
Message-ID: <4D87A264.2@redhat.com>
Date: Mon, 21 Mar 2011 16:09:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: v4l-dvb Mercurial repository and media-build git repository
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Today I added a patch at the old -hg repository meant to
warn people that might eventually be using the old v4l-dvb hg
repository in the hope that his device will eventually work
on it. The latest patch there were applied 8 months ago. So,
I'd say that the drivers there are likely older than 2.6.36 kernel.

I also updated the linuxtv git homepage to point to the 
media_build.git tree (that replaced the legacy tree), and added
a few patches there to help developers to know what media_tree.git
snapshot was used when some user reports an issue.

Now, when someone compiles from the media-build, a warning message
will be displayed when dvb, rc or v4l core is loaded. Something like:

Linux video capture interface: v2.00
WARNING: You are using an experimental version of the media stack.
	As the driver is backported to an older kernel, it doesn't offer
	enough quality for its usage in production.
	Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
	41f3becb7bef489f9e8c35284dd88a1ff59b190c [media] V4L DocBook: update V4L2 version
	00cd84ab54a51d4bce9754d54d5d8160358844c4 [media] V4L doc fixes
	e82aa4810c1ff222b344e3de6cc5c26177c321f6 [media] v4l2: vb2-dma-sg: fix potential security hole

With the above messages, developers that may be receiving a bug report
will know that:
	1) the reporter used a media_tree.git tree to report a bug, and
not a vanilla (or a distro-patched kernel);
	2) the latest 3 git commits that were applied at the tree, being
able to check if a newer patch might already be fixed the reported issue.

The tester will know that:
	1) he is using an experimental tree, not meant for production;
	2) the email where he could report an issue;
	3) that developers need a "dmesg" in order to know what's
happening.

It should be noticed that there are still a few group of developers
using the old hg tree as the basis for his development.

I don't have any intention to remove the -hg repository for the 
same reason we still preserve the legacy cvs repositories: people
may find its history useful.

Also, people still can send me pull requests from -hg, as I still
have my scripts to retrieve patches from it.

However, as the code is diverging from upstream, as nobody is keeping 
the -hg tree updated, the developers that are still using -hg will 
likely need to apply some backports by themselves, or eventually work
together to do backports, otherwise, the submitted patches may not 
apply upstream anymore, as some non-trivial merge conflict may happen.

Cheers,
Mauro

