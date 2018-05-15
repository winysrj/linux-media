Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:32589 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbeEOCAf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 22:00:35 -0400
Date: Tue, 15 May 2018 09:59:51 +0800
From: kbuild test robot <lkp@intel.com>
To: Sean Young <sean@mess.org>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH v1 3/4] media: rc bpf: move ir_raw_event to uapi
Message-ID: <201805150934.eFWtrdSq%fengguang.wu@intel.com>
References: <6ecdbd01b8c42c8784f2235c1e5109dac3dd86a5.1526331777.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <6ecdbd01b8c42c8784f2235c1e5109dac3dd86a5.1526331777.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sean,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.17-rc5]
[cannot apply to next-20180514]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sean-Young/media-rc-introduce-BPF_PROG_IR_DECODER/20180515-093234
config: i386-tinyconfig (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

>> ./usr/include/linux/bpf_rcdev.h:13: found __[us]{8,16,32,64} type without #include <linux/types.h>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--T4sUOijqQbZv57TR
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--T4sUOijqQbZv57TR--
