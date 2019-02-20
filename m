Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A1DC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 18:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5F020880
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 18:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfBTSC5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 13:02:57 -0500
Received: from mga12.intel.com ([192.55.52.136]:24817 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfBTSC5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 13:02:57 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2019 10:02:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,391,1544515200"; 
   d="scan'208";a="148440466"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2019 10:02:55 -0800
Date:   Wed, 20 Feb 2019 10:02:56 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-fpga@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-fbdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        devel@lists.orangefs.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [RESEND PATCH 0/7] Add FOLL_LONGTERM to GUP fast and use it
Message-ID: <20190220180255.GA12020@iweiny-DESK2.sc.intel.com>
References: <20190220053040.10831-1-ira.weiny@intel.com>
 <20190220151930.GB11695@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220151930.GB11695@infradead.org>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Feb 20, 2019 at 07:19:30AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 19, 2019 at 09:30:33PM -0800, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > Resending these as I had only 1 minor comment which I believe we have covered
> > in this series.  I was anticipating these going through the mm tree as they
> > depend on a cleanup patch there and the IB changes are very minor.  But they
> > could just as well go through the IB tree.
> > 
> > NOTE: This series depends on my clean up patch to remove the write parameter
> > from gup_fast_permitted()[1]
> > 
> > HFI1, qib, and mthca, use get_user_pages_fast() due to it performance
> > advantages.  These pages can be held for a significant time.  But
> > get_user_pages_fast() does not protect against mapping of FS DAX pages.
> 
> This I don't get - if you do lock down long term mappings performance
> of the actual get_user_pages call shouldn't matter to start with.
> 
> What do I miss?

A couple of points.

First "longterm" is a relative thing and at this point is probably a misnomer.
This is really flagging a pin which is going to be given to hardware and can't
move.  I've thought of a couple of alternative names but I think we have to
settle on if we are going to use FL_LAYOUT or something else to solve the
"longterm" problem.  Then I think we can change the flag to a better name.

Second, It depends on how often you are registering memory.  I have spoken with
some RDMA users who consider MR in the performance path...  For the overall
application performance.  I don't have the numbers as the tests for HFI1 were
done a long time ago.  But there was a significant advantage.  Some of which is
probably due to the fact that you don't have to hold mmap_sem.

Finally, architecturally I think it would be good for everyone to use *_fast.
There are patches submitted to the RDMA list which would allow the use of
*_fast (they reworking the use of mmap_sem) and as soon as they are accepted
I'll submit a patch to convert the RDMA core as well.  Also to this point
others are looking to use *_fast.[2]

As an asside, Jasons pointed out in my previous submission that *_fast and
*_unlocked look very much the same.  I agree and I think further cleanup will
be coming.  But I'm focused on getting the final solution for DAX at the
moment.

Ira

