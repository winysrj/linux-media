Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:36279 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935743AbeFRSrX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 14:47:23 -0400
Date: Tue, 19 Jun 2018 02:46:29 +0800
From: kbuild test robot <lkp@intel.com>
To: Sean Young <sean@mess.org>
Cc: kbuild-all@01.org, Daniel Borkmann <daniel@iogearbox.net>,
        Y Song <ys114321@gmail.com>, Matthias Reichl <hias@horus.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v3] bpf: attach type BPF_LIRC_MODE2 should not depend on
 CONFIG_CGROUP_BPF
Message-ID: <201806190203.kfm0Xhda%fengguang.wu@intel.com>
References: <20180618171216.gearpr755pm3wot7@gofer.mess.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20180618171216.gearpr755pm3wot7@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sean,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.18-rc1 next-20180618]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sean-Young/bpf-attach-type-BPF_LIRC_MODE2-should-not-depend-on-CONFIG_CGROUP_BPF/20180619-023056
config: i386-tinyconfig (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   In file included from kernel///events/core.c:45:0:
>> include/linux/bpf.h:710:1: error: expected identifier or '(' before '{' token
    {
    ^

vim +710 include/linux/bpf.h

   707	
   708	int sockmap_get_from_fd(const union bpf_attr *attr, int type,
   709				struct bpf_prog *prog);
 > 710	{
   711		return -EINVAL;
   712	}
   713	#endif
   714	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--+HP7ph2BbKc20aGI
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--+HP7ph2BbKc20aGI--
