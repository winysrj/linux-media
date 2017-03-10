Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:10745 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751067AbdCJCtf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 21:49:35 -0500
Date: Fri, 10 Mar 2017 10:49:29 +0800
From: Fengguang Wu <lkp@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kbuild-all@01.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, git@vger.kernel.org,
        Ye Xiaolong <xiaolong.ye@intel.com>
Subject: Re: [media] omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for
 CCP2 mode
Message-ID: <20170310024929.la3uuzhtckdn5tm2@wfg-t540p.sh.intel.com>
References: <20170301114545.GA19201@amd>
 <201703031931.OeUvSOwD%fengguang.wu@intel.com>
 <20170303214838.GA26826@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170303214838.GA26826@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 03, 2017 at 10:48:38PM +0100, Pavel Machek wrote:
>Hi!
>
>> [auto build test ERROR on linuxtv-media/master]
>> [also build test ERROR on v4.10 next-20170303]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>
>
>Yes, the patch is against Sakari's ccp2 branch. It should work ok there.
>
>I don't think you can do much to fix the automated system....

We could, if "git format-patch" can be setup to auto append lines

        parent-commit: X
        parent-patch-id: Y

With that information, as long as the parent commit/patch is public --
either by "git push" or posting patch to mailing lists -- we'll have
good chance to find and use it as the base for "git am".

Currently "git format-patch" already has the option "--base=auto" to
auto append the more accurate lines

        base-commit: P
        prerequisite-patch-id: X
        prerequisite-patch-id: Y
        prerequisite-patch-id: Z

That's the best information git can offer. Unfortunately it cannot
ALWAYS work without human aid. What's worse, when it cannot figure out
the base-commit, the whole "git format-patch" command will abort like
this

        $ git format-patch -1
        fatal: base commit shouldn't be in revision list

That fatal error makes it not a viable option to always turn on
"--base=auto" in .gitconfig.

Without a fully-automated solution, I don't think many people will
bother or remember to manually specify base-commit before sending
patches out.

To effectively save the robot from "base commit" guessing works, what
we can do is to

1) append "parent-commit"/"parent-patch-id" lines when git cannot
   figure out and append the "base-commit"/"prerequisite-patch-id"
   lines. So that the test robot always get the information to do
   its job.

2) advise kernel developers to run this once

        git config format.useAutoBase yes

   to configure "--base=auto" as the default behavior.

Thanks,
Fengguang
