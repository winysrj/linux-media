Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D646AC282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 15:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7E6921773
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 15:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfBIPb4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 10:31:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:30196 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfBIPb4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Feb 2019 10:31:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Feb 2019 07:31:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,351,1544515200"; 
   d="scan'208";a="113650184"
Received: from laszlota-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.58.91])
  by orsmga007.jf.intel.com with ESMTP; 09 Feb 2019 07:31:53 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 91B6621D9A; Sat,  9 Feb 2019 17:31:48 +0200 (EET)
Date:   Sat, 9 Feb 2019 17:31:48 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        linux-media@vger.kernel.org,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 2/4] media: mt9m111: add VIDEO_V4L2_SUBDEV_API dependency
Message-ID: <20190209153147.dkp33m7vqf5ieu7s@kekkonen.localdomain>
References: <1549637565-32096-3-git-send-email-akinobu.mita@gmail.com>
 <201902090047.fTZ02W0h%fengguang.wu@intel.com>
 <CAC5umyixA-YYOou5OZLSuVDbnSqmckup8=oVWUXw56JVd_nFVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyixA-YYOou5OZLSuVDbnSqmckup8=oVWUXw56JVd_nFVg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Feb 09, 2019 at 08:54:39PM +0900, Akinobu Mita wrote:
> 2019年2月9日(土) 1:20 kbuild test robot <lkp@intel.com>:
> >
> > Hi Akinobu,
> >
> > I love your patch! Yet something to improve:
> >
> > [auto build test ERROR on linuxtv-media/master]
> > [also build test ERROR on next-20190208]
> > [cannot apply to v5.0-rc4]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> >
> > url:    https://github.com/0day-ci/linux/commits/Akinobu-Mita/media-i2c-tweak-Kconfig-dependencies/20190208-233718
> > base:   git://linuxtv.org/media_tree.git master
> > config: i386-randconfig-x019-201905 (attached as .config)
> 
> Ah, SOC_CAMERA_MT9M111 implicitly selects VIDEO_MT9M111 and in this case,
> VIDEO_V4L2_SUBDEV_API is not required.
> 
> This build error can be fixed by removing SOC_CAMERA_MT9M111 from
> drivers/media/i2c/soc_camera/Kconfig.

Ah, thanks, I was wondering what this could have been about. :-) I'll send
a patch.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
