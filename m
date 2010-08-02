Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab0HBV1i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 17:27:38 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o72LRbY0014057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 2 Aug 2010 17:27:38 -0400
Received: from [10.11.10.146] (vpn-10-146.rdu.redhat.com [10.11.10.146])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o72LRYJr020705
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 2 Aug 2010 17:27:36 -0400
Message-ID: <4C57386B.7050103@redhat.com>
Date: Mon, 02 Aug 2010 18:28:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [announce]  changes on my git tree
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear developers and users,

After merging patches directly on my git tree, I was impressed by the number
of things I discovered that I should not do when handling it ;) 
Living and learning :)

There are lots of trash there, due to the way patches get merged back from
upstream.

As reverting a patch there will break things for everybody that clones from
my tree, I decided to go to an easier way: let's start from scratch.

I've created a new tree, at:
	http://git.linuxtv.org/media_tree.git

Currently, it is just a clone of Linus tree, all pointing to v2.6.35. I'll soon
be adding more patches there.

In order to avoid the same kind of troubles I had in the past, I intend to
use the following guidelines:

1) branch "master" - will have the contents of Linus tree.
2) branch "staging/2.6.35" - will have patches for the current stable kernel;
2) branch "staging/2.6.36" - will have patches for the current development cycle;
3) branch "staging/2.6.37" - will have patches for linux-next

On every new kernel release, I'll create another branch.

No branches will be rebased, but I won't merge from a staging branch into
master. If needed, I'll just update master to from Linus tree after having
a changeset pulled there.

As need arises, I'll be adding some development branches there with stuff that
are already accepted, but there are still pending patches that are needed before
sending that patch set upstream (for example, new internal/external API's
added, while there's no driver actually using them).

For those that already sent me pull requests, and for a few weeks, there's no
action need. I'll be manually handling the tree differences for a while. Yet,
the better is to rebase your trees using the new one as the basis.

Except when needed (like depending on a third-party patch applied on my tree), 
the better is to have your local git trees always based on master.

Cheers,
Mauro.

