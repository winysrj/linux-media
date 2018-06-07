Return-path: <linux-media-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:46632 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbeFGWkN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 18:40:13 -0400
Subject: Re: [PATCH] bpf: attach type BPF_LIRC_MODE2 should not depend on
 CONFIG_BPF_CGROUP
To: Y Song <ys114321@gmail.com>, Sean Young <sean@mess.org>
Cc: Matthias Reichl <hias@horus.com>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
References: <cover.1527419762.git.sean@mess.org>
 <9f2c54d4956f962f44fcda739a824397ddea132c.1527419762.git.sean@mess.org>
 <20180604174730.sctfoklq7klswebp@camel2.lan>
 <20180605101629.yffyp64o7adg6hu5@gofer.mess.org>
 <04cc36e7-4597-dc57-4ad7-71afcc17244a@iogearbox.net>
 <20180606210939.q3vviyc4b2h6gu3c@gofer.mess.org>
 <CAH3MdRXE8=dE25Sj3TPDzVh7ytnvCkUDvCDzZkEZe0N84dy-Zw@mail.gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <34406f72-722d-9c23-327f-b7c5d7a3090c@iogearbox.net>
Date: Fri, 8 Jun 2018 00:40:10 +0200
MIME-Version: 1.0
In-Reply-To: <CAH3MdRXE8=dE25Sj3TPDzVh7ytnvCkUDvCDzZkEZe0N84dy-Zw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/07/2018 08:14 PM, Y Song wrote:
> On Wed, Jun 6, 2018 at 2:09 PM, Sean Young <sean@mess.org> wrote:
>> Compile bpf_prog_{attach,detach,query} even if CONFIG_BPF_CGROUP is not
>> set.
> 
> It should be CONFIG_CGROUP_BPF here. The same for subject line.
> Today, if CONFIG_CGROUP_BPF is not defined. Users will get an -EINVAL
> if they try to attach/detach/query.
> 
> I am not sure what is the motivation behind this change. Could you explain more?

Motivation was that lirc2 progs are not related to cgroups at all and there
are users that have compiled it out, yet it uses BPF_PROG_ATTACH/DETACH for
managing them. This definitely needs to be more clearly explained in the
changelog, agree.

>> Signed-off-by: Sean Young <sean@mess.org>
>> ---
>>  include/linux/bpf-cgroup.h |  31 +++++++++++
>>  kernel/bpf/cgroup.c        | 110 +++++++++++++++++++++++++++++++++++++
>>  kernel/bpf/syscall.c       | 105 ++---------------------------------
>>  3 files changed, 145 insertions(+), 101 deletions(-)
>>[...]
