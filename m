Return-path: <linux-media-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:45396 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932544AbeFZKDi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 06:03:38 -0400
Subject: Re: [PATCH v4] bpf: attach type BPF_LIRC_MODE2 should not depend on
 CONFIG_CGROUP_BPF
To: Sean Young <sean@mess.org>, Y Song <ys114321@gmail.com>,
        Matthias Reichl <hias@horus.com>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
References: <20180618171216.gearpr755pm3wot7@gofer.mess.org>
 <201806190203.kfm0Xhda%fengguang.wu@intel.com>
 <20180618230423.nk2ey2755p2zkqmv@gofer.mess.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <57baf751-cd2a-dedf-05bc-9ac3b4e050be@iogearbox.net>
Date: Tue, 26 Jun 2018 12:03:35 +0200
MIME-Version: 1.0
In-Reply-To: <20180618230423.nk2ey2755p2zkqmv@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2018 01:04 AM, Sean Young wrote:
> If the kernel is compiled with CONFIG_CGROUP_BPF not enabled, it is not
> possible to attach, detach or query IR BPF programs to /dev/lircN devices,
> making them impossible to use. For embedded devices, it should be possible
> to use IR decoding without cgroups or CONFIG_CGROUP_BPF enabled.
> 
> This change requires some refactoring, since bpf_prog_{attach,detach,query}
> functions are now always compiled, but their code paths for cgroups need
> moving out. Rather than a #ifdef CONFIG_CGROUP_BPF in kernel/bpf/syscall.c,
> moving them to kernel/bpf/cgroup.c and kernel/bpf/sockmap.c does not
> require #ifdefs since that is already conditionally compiled.
> 
> Signed-off-by: Sean Young <sean@mess.org>

Applied to bpf, thanks Sean!
