Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923DDC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63F972070B
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfCZLen (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 07:34:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:13769 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfCZLen (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 07:34:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 04:34:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="158489539"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2019 04:34:38 -0700
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id E7567207E2; Tue, 26 Mar 2019 13:34:37 +0200 (EET)
Date:   Tue, 26 Mar 2019 13:34:37 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mickael GUENE <mickael.guene@st.com>
Cc:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Kao <ben.kao@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ricardo Ribalda Delgado <ricardo@ribalda.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>
Subject: Re: [PATCH v2 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL
 bridge driver
Message-ID: <20190326113437.bpebmfs7mipsg24y@paasikivi.fi.intel.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1553500510-153260-1-git-send-email-mickael.guene@st.com>
 <1553500510-153260-3-git-send-email-mickael.guene@st.com>
 <20190325114430.zot5tbiczqrhpskl@kekkonen.localdomain>
 <eaf82024-1f65-a1e3-8410-49209b5414aa@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaf82024-1f65-a1e3-8410-49209b5414aa@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mickael,

On Mon, Mar 25, 2019 at 12:22:17PM +0000, Mickael GUENE wrote:
...
> >> +	/* register it for later use */
> >> +	bridge->rx = ep;
> >> +	bridge->rx.link_frequencies = ep.nr_of_link_frequencies == 1 ?
> >> +		&bridge->link_frequency : NULL;
> > 
> > I think you need to simply ignore the link frequencies here. The
> > transmitting device can tell the frequency based on its configuration
> > (based on the link frequencies). You seem to have implemented that already.
> > 
>  Idea of this was to allow some support for sensor that doesn't implement
> V4L2_CID_PIXEL_RATE. Do you think it's useless ?

Sensor drivers need to be amended with support for that control.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
