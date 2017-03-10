Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:39737 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750734AbdCJBZY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 20:25:24 -0500
Date: Fri, 10 Mar 2017 09:24:15 +0800
From: Ye Xiaolong <xiaolong.ye@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kbuild test robot <lkp@intel.com>, ivo.g.dimitrov.75@gmail.com,
        linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>, kbuild-all@01.org,
        pali.rohar@gmail.com, mchehab@kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [kbuild-all] [media] omap3isp: Correctly set IO_OUT_SEL and
 VP_CLK_POL for CCP2 mode
Message-ID: <20170310012415.GE17010@yexl-desktop>
References: <20170301114545.GA19201@amd>
 <201703031931.OeUvSOwD%fengguang.wu@intel.com>
 <20170303214838.GA26826@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170303214838.GA26826@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03, Pavel Machek wrote:
>Hi!
>
>> [auto build test ERROR on linuxtv-media/master]
>> [also build test ERROR on v4.10 next-20170303]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>> 
>
>Yes, the patch is against Sakari's ccp2 branch. It should work ok there.

Could you tell us the url of Sakari's tree? thus we can add it to 0day's
monitoring list.

Thanks,
Xiaolong
>
>I don't think you can do much to fix the automated system....
>
>										Pavel
>
>-- 
>(english) http://www.livejournal.com/~pavelmachek
>(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



>_______________________________________________
>kbuild-all mailing list
>kbuild-all@lists.01.org
>https://lists.01.org/mailman/listinfo/kbuild-all
