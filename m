Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD255C4360F
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 07:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B25C20851
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 07:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfCGH51 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 02:57:27 -0500
Received: from mga05.intel.com ([192.55.52.43]:17231 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbfCGH51 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 02:57:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2019 23:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,451,1544515200"; 
   d="scan'208";a="121736749"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga006.jf.intel.com with ESMTP; 06 Mar 2019 23:57:23 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 56030204CC; Thu,  7 Mar 2019 09:57:22 +0200 (EET)
Date:   Thu, 7 Mar 2019 09:57:22 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: Re: [PATCH 1/5] staging: imgu: Switch to __aligned() from
 __attribute__((aligned()))
Message-ID: <20190307075722.d5actmzq2wdzvr5i@paasikivi.fi.intel.com>
References: <20190220111953.7886-1-sakari.ailus@linux.intel.com>
 <20190220111953.7886-2-sakari.ailus@linux.intel.com>
 <CAAFQd5D=kTUEdzc4gStvKH45SMhDycDO_5ipJGaD=+aduiPESw@mail.gmail.com>
 <CAAFQd5CwQaOivM81fQ4aGYWZTsUEhKOr55XvtwGYSJDJkSELpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5CwQaOivM81fQ4aGYWZTsUEhKOr55XvtwGYSJDJkSELpQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 07, 2019 at 12:00:59PM +0900, Tomasz Figa wrote:
> On Thu, Mar 7, 2019 at 12:00 PM Tomasz Figa <tfiga@chromium.org> wrote:
> >
> > Hi Sakari,
> >
> > On Wed, Feb 20, 2019 at 8:21 PM Sakari Ailus
> > <sakari.ailus@linux.intel.com> wrote:
> > >
> > > __aligned() is preferred. The patch has been generated using the following
> > > command in the drivers/staging/media/ipu3 directory:
> > >
> > > $ git grep -l 'aligned(32)' | \
> > >         xargs perl -i -pe \
> > >         's/__attribute__\s*\(\(\s*aligned\s*\(([0-9]+)\s*\)\s*\)\)/__aligned($1)/g;'
> >
> > Thanks for the patch. These structs are expected to move to uapi/ once
> > the driver leaves staging. Is __aligned() now accessible to uapi
> > headers?
> 
> Ah, just noticed the v2 of the series doesn't include this patch.
> Sorry for the noise.

No worries. I just intended to postpone it first but it seems it's better
to drop it. Handling __aligned(whatever) is a pain with sed --- as it may
be more than just numbers.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
