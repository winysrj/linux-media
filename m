Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1A1C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75A2620675
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfCEIr1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:47:27 -0500
Received: from mga18.intel.com ([134.134.136.126]:48616 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfCEIr0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 03:47:26 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2019 00:47:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,443,1544515200"; 
   d="scan'208";a="138148851"
Received: from schmiger-mobl3.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.45.12])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Mar 2019 00:47:23 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id CCAFD21E9B; Tue,  5 Mar 2019 10:47:20 +0200 (EET)
Date:   Tue, 5 Mar 2019 10:47:20 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Cao, Bingbu" <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: staging/intel-ipu3: reduce kernel stack usage
Message-ID: <20190305084720.jlgwd5ifouq3vvra@kekkonen.localdomain>
References: <20190304202758.1802417-1-arnd@arndb.de>
 <EE45BB6704246A4E914B70E8B61FB42A15C131D5@SHSMSX104.ccr.corp.intel.com>
 <20190305075317.4t32uyyhzftuoebp@kekkonen.localdomain>
 <CAK8P3a17qNvFvEVpjd5W0gwDn-HocW_ChDyeukiqHBbJbyAedQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a17qNvFvEVpjd5W0gwDn-HocW_ChDyeukiqHBbJbyAedQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 05, 2019 at 09:40:24AM +0100, Arnd Bergmann wrote:
> On Tue, Mar 5, 2019 at 8:53 AM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > On Tue, Mar 05, 2019 at 12:25:18AM +0000, Cao, Bingbu wrote:
> 
> > > >     struct v4l2_pix_format_mplane *const in =
> > > >                                     &q[IPU3_CSS_QUEUE_IN].fmt.mpix;
> > > >     struct v4l2_pix_format_mplane *const out = @@ -1753,6 +1754,11 @@
> > > > int imgu_css_fmt_try(struct imgu_css *css,
> > > >                                     &q[IPU3_CSS_QUEUE_VF].fmt.mpix;
> > > >     int i, s, ret;
> > > >
> > > > +   if (!q) {
> > > > +           ret = -ENOMEM;
> > > > +           goto out;
> > > > +   }
> > > [Cao, Bingbu]
> > > The goto here is wrong, you can just report an error, and I prefer it is next to the alloc.
> >
> > I agree, the goto is just not needed.
> 
> Should I remove all the gotos then and do an explicit kfree() in each
> error path?
> 
> I'd prefer not to mix the two styles, as that can lead to subtle mistakes
> when the code is refactored again.

In this case there's no need for kfree as q is NULL. Goto is often useful
if you need to do things to undo stuff that was done earlier in the
function but it's not the case here. I prefer keeping the rest gotos.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
