Return-path: <mchehab@gaivota>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1482 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab0L3TJE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 14:09:04 -0500
Received: from durdane.localnet (marune.xs4all.nl [82.95.89.49])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBUJ92tr020293
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 20:09:03 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build: WARNINGS
Date: Thu, 30 Dec 2010 20:09:02 +0100
References: <201012301831.oBUIVc8P001036@smtp-vbr11.xs4all.nl>
In-Reply-To: <201012301831.oBUIVc8P001036@smtp-vbr11.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012302009.02232.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Just a quick note that I made some changes to the build script so that
the number of warnings on the ARM platforms has decreased dramatically.

The mips architecture doesn't compile at the moment. A fix is in the Linus
tree, but not yet in the for_v2.6.38 branch I'm using in this daily build.
Once the trees are updated after 2.6.37 is released this should be fixed
automatically.

The number of sparse errors has also been reduced dramatically. You can
ignore the 'bad asm output' errors, that's due to dev_dbg and CONFIG_DYNAMIC_DEBUG.

I fixed this, so those 'bad asm' errors shouldn't be present anymore in the next
daily build.

Regards,

	Hans

On Thursday, December 30, 2010 19:31:38 Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
> 
> Results of the daily build of v4l-dvb:
> 
> date:        Thu Dec 30 19:00:21 CET 2010
> git master:       59365d136d205cc20fe666ca7f89b1c5001b0d5a
> git media-master: gcc version:      i686-linux-gcc (GCC) 4.5.1
> host hardware:    x86_64
> host os:          2.6.32.5
> 
> linux-git-armv5: WARNINGS
> linux-git-armv5-davinci: WARNINGS
> linux-git-armv5-ixp: WARNINGS
> linux-git-armv5-omap2: WARNINGS
> linux-git-i686: WARNINGS
> linux-git-m32r: WARNINGS
> linux-git-mips: WARNINGS
> linux-git-powerpc64: WARNINGS
> linux-git-x86_64: WARNINGS
> spec-git: OK
> sparse: ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Thursday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Thursday.tar.bz2
> 
> The V4L-DVB specification from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
