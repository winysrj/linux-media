Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57256
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbcHFUBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2016 16:01:31 -0400
Date: Sat, 6 Aug 2016 07:35:36 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Shuah Khan <shuah.kh@samsung.com>
Subject: [GIT PULL for v4.8-rc1] mailcap fixup for two entries
Message-ID: <20160806073536.2bd92a93@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from my tree for a small fixup on my entry and Shuah's entry at
.mailcap.

Basically, those entries were with a syntax that makes get_maintainer.pl to
do the wrong thing.

Thanks!
Mauro

PS.: Andrew asked to handle this one via my tree, as he had some issued with
some UTF-8 characters on this file, at the context lines.


The following changes since commit 292eaf50c7df4ae2ae8aaa9e1ce3f1240a353ee8:

  [media] cec: fix off-by-one memset (2016-07-28 20:16:35 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-6

for you to fetch changes up to 5055610e3d30ed90de77525cf240d0066ac616e4:

  .mailmap: Correct entries for Mauro Carvalho Chehab and Shuah Khan (2016-08-04 21:35:41 -0300)

----------------------------------------------------------------
media updates for v4.8-rc1

----------------------------------------------------------------
Joe Perches (1):
      .mailmap: Correct entries for Mauro Carvalho Chehab and Shuah Khan

 .mailmap | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

