Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab0DWArI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 20:47:08 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3N0l4Bn023001
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Apr 2010 20:47:04 -0400
Received: from [10.11.10.107] (vpn-10-107.rdu.redhat.com [10.11.10.107])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o3N0l1f1000942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 22 Apr 2010 20:47:03 -0400
Message-ID: <4BD0EE04.4080601@redhat.com>
Date: Thu, 22 Apr 2010 21:47:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: How to use git development trees
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

A few developers asked me how I'm working with the git trees for development.

So, I decided to write a few quick notes about it at the wiki:
	http://linuxtv.org/wiki/index.php/Using_a_git_driver_development_tree

I also added the script I use to remove the modules from the memory.

Based on my own experience, using the Git tree instead of Mercurial speed up
my development time when working with IR, especially since I had to touch at
the input system core, to add two new ioctls. As input core is not at the Mercurial,
if I was using the old way, I would have to deal with both mercurial and upstream
trees. The drawback of doing a full compilation of the upstream kernel is not bad
for me, since I always test the latest kernel anyway. Of course, other people may
have different experiences. That's why we're keep supporting the mercurial trees ;)

Btw, in order to help developers to work with git, I'm trying to preserve the git
tree with the latest stable Linus kernel version (currently, 2.6.33), plus the
v4l-dvb new drivers. So, I intend to backport from upstream only with 2.6.34.

PS.: with respect to the pending patches, I was abroad last week, and I'm currently
with a very high volume of patches, some requiring lots of tests. My intention
is to merge the great majority of the patches until the end of this weekend.

-- 

Cheers,
Mauro
