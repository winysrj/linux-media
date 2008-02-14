Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1EIetPI015662
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 13:40:55 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1EIeXR1022152
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 13:40:33 -0500
Date: Thu, 14 Feb 2008 16:40:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	DVB ML <linux-dvb@linuxtv.org>
Message-ID: <20080214164012.7b8ae26f@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [ANNOUNCE] linux-next and V4L/DVB linux-next
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

A recent announce at LKML introduced a new concept of integrated development
between the several subsystem trees, called linux-next.

The basic idea is to have a common tree that merges all development efforts,
helping to solve merge conflicts before arising at Linus main tree. More
details can be seen at the original announce [1].

With this concept, what happens is that a new patch will mature at the
development branches and at linux-next. At the release of a new kernel (let's
say 2.6.25), a merge window will open to the next kernel (2.6.26). The patches
for the next kernel will be submitted by each subsystem maintainer. Since those
patches were already tested on linux-next tree, the merging process will
become easier and the newer kernel will become more stable.

So, linux-next contains the patches for 2.6.25, plus the patches expected to be
added at kernel 2.6.26.

For this to happen, I've created a newer -git tree, containing the committed
changesets that are expected to appear at the next kernel. It contains
basically the same patches already present on -hg and v4l-dvb.git trees, plus
the base patches from linux-next (at 'stable' branch). Another branch
('master') will contain also the merged patches from the other subsystems. 

For those brave enough to test it, the tree is available at [2]. Please be
warned to use this on a testing system, since patches at core subsystems
(ext2, vfs, etc) may be broken there.

In order have a single point where all trees are listed, I've updated
README.patches file, and the main tree at http://linuxtv.org/hg with the newer
tree. I've also added a link to README.patches there.

[1] http://lkml.org/lkml/2008/2/11/512
[2] http://www.kernel.org/git/?p=linux/kernel/git/mchehab/linux-next.git;a=summary

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
