Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59881 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2Shj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 14:37:39 -0400
Date: Tue, 29 Aug 2017 11:37:38 -0700
From: Kyle McMartin <kyle@infradead.org>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Kyle McMartin <kyle@infradead.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>, linux-firmware@kernel.org
Subject: Re: [PATCH] linux-firmware: intel: Add Kabylake IPU3 firmware
Message-ID: <20170829183738.GC5405@bombadil.infradead.org>
References: <1500350210-1119-1-git-send-email-rajmohan.mani@intel.com>
 <6F87890CF0F5204F892DEA1EF0D77A59725DD5BF@FMSMSX114.amr.corp.intel.com>
 <20170823165441.GT13400@bombadil.infradead.org>
 <CAAFQd5AS-KSLZiFn85vxQvhfy406Uw8nBB8F8W9xM4GryQcurg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5AS-KSLZiFn85vxQvhfy406Uw8nBB8F8W9xM4GryQcurg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 24, 2017 at 10:10:25AM +0900, Tomasz Figa wrote:
> On Thu, Aug 24, 2017 at 1:54 AM, Kyle McMartin <kyle@infradead.org> wrote:
> > On Fri, Jul 21, 2017 at 12:08:32AM +0000, Mani, Rajmohan wrote:
> >> I am also following up on the second approach to submit the IPU3 firmware patch.
> >>
> >> git remote add ipu3fw https://github.com/RajmohanMani/linux-firmware.git
> >> git remote update
> >> git pull ipu3fw master
> >>
> >
> > I assume this was covered by the later pull request I got today?
> >
> 
> Yes, this patch was an initial attempt, but given the binary size, we
> decided to go with a pull request to make things easier.
> 
> Thanks for handling this.
> 

no worries, thanks for your patience.

regards, kyle
