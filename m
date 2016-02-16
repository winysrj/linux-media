Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:36198 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbcBPCH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 21:07:26 -0500
MIME-Version: 1.0
In-Reply-To: <201602152005.UfVs7xXd%fengguang.wu@intel.com>
References: <a0c13be89c5f43de0693f37144a00255c6090ffd.1455528251.git.knightrider@are.ma>
	<201602152005.UfVs7xXd%fengguang.wu@intel.com>
Date: Tue, 16 Feb 2016 11:07:26 +0900
Message-ID: <CAKnK8-TjJcohucT-cAViSTXyMD2+HL_GY-jDhUApLKVoxOsc-g@mail.gmail.com>
Subject: Re: [media 7/7] PCI bridge driver for PT3 & PXQ3PE
From: "AreMa Inc." <info@are.ma>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-media <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans De Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-02-15 21:57 GMT+09:00 kbuild test robot <lkp@intel.com>:
> Hi Буди,
>
> [auto build test ERROR on linuxtv-media/master]
> [cannot apply to v4.5-rc4 next-20160215]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/info-are-ma/Driver-bundle-for-PT3-PX-Q3PE/20160215-173307
> base:   git://linuxtv.org/media_tree.git master
> config: x86_64-allyesconfig (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64

We tried to reproduce. It compiles successfully. Nothing wrong.
Your attached .config is corrupted, it doesn't match the kernel
mentioned (v4.5-rc4 next-20160215).
Remaking .config solved the problem. Voila!
