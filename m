Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38158 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbbFWI6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 04:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <20150623073959.GC21872@gmail.com>
References: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
 <1435012318-381-2-git-send-email-mcgrof@do-not-panic.com> <20150623073959.GC21872@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 23 Jun 2015 01:57:43 -0700
Message-ID: <CAB=NE6W7oJuqva=YM_aegzTu1XLGy66WF8jF52YLX8opEm2+XQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86/mm/pat, drivers/infiniband/ipath: replace WARN()
 with pr_warn()
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Doug Ledford <dledford@redhat.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 23, 2015 at 12:39 AM, Ingo Molnar <mingo@kernel.org> wrote:
> Same observation as for the other patch: please only warn if the hardware is
> present and the driver tries to activate. No need to annoy others.

Will fix, and respin.

 Luis
