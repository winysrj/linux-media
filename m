Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58891 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751560AbeERNdc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 09:33:32 -0400
Date: Fri, 18 May 2018 14:33:30 +0100
From: Sean Young <sean@mess.org>
To: Quentin Monnet <quentin.monnet@netronome.com>
Cc: Y Song <ys114321@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH v3 2/2] bpf: add selftest for rawir_event type program
Message-ID: <20180518133329.fafkew5nkr2bmzah@gofer.mess.org>
References: <cover.1526504511.git.sean@mess.org>
 <78945f2bf82e9f16695f72bed3930d1302d38e29.1526504511.git.sean@mess.org>
 <CAH3MdRUhrBzHXKgcu1htSHTqeKVWnci+ADrTriCqjXLHUezB+w@mail.gmail.com>
 <20180517210140.ck225yuckq6onheb@gofer.mess.org>
 <86ffb16c-9b4e-c826-ecd2-82266e7b8c2e@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ffb16c-9b4e-c826-ecd2-82266e7b8c2e@netronome.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 11:13:07AM +0100, Quentin Monnet wrote:
> 2018-05-17 22:01 UTC+0100 ~ Sean Young <sean@mess.org>
> > On Thu, May 17, 2018 at 10:17:59AM -0700, Y Song wrote:
> >> On Wed, May 16, 2018 at 2:04 PM, Sean Young <sean@mess.org> wrote:
> >>> This is simple test over rc-loopback.
> >>>
> >>> Signed-off-by: Sean Young <sean@mess.org>
> >>> ---
> >>>  tools/bpf/bpftool/prog.c                      |   1 +
> >>>  tools/include/uapi/linux/bpf.h                |  57 +++++++-
> >>>  tools/lib/bpf/libbpf.c                        |   1 +
> >>>  tools/testing/selftests/bpf/Makefile          |   8 +-
> >>>  tools/testing/selftests/bpf/bpf_helpers.h     |   6 +
> >>>  tools/testing/selftests/bpf/test_rawir.sh     |  37 +++++
> >>>  .../selftests/bpf/test_rawir_event_kern.c     |  26 ++++
> >>>  .../selftests/bpf/test_rawir_event_user.c     | 130 ++++++++++++++++++
> >>>  8 files changed, 261 insertions(+), 5 deletions(-)
> >>>  create mode 100755 tools/testing/selftests/bpf/test_rawir.sh
> >>>  create mode 100644 tools/testing/selftests/bpf/test_rawir_event_kern.c
> >>>  create mode 100644 tools/testing/selftests/bpf/test_rawir_event_user.c
> 
> [...]
> 
> >> Most people probably not really familiar with lircN device. It would be
> >> good to provide more information about how to enable this, e.g.,
> >>   CONFIG_RC_CORE=y
> >>   CONFIG_BPF_RAWIR_EVENT=y
> >>   CONFIG_RC_LOOPBACK=y
> >>   ......
> > 
> > Good point. I'll add some words explaining what is and how to make it work.
> > 
> > Thanks
> > Sean
> 
> 
> By the way, shouldn't the two eBPF helpers bpf_rc_keydown() and
> bpf_rc_repeat() be compiled out in patch 1 if e.g.
> CONFIG_BPF_RAWIR_EVENT is not set? There are some other helpers that are
> compiled only if relevant config options are set (bpf_get_xfrm_state()
> for example).

So if CONFIG_BPF_RAWIR_EVENT is not set, then bpf-rawir-event.c is not
compiled. Stubs are created in include/linux/bpf_rcdev.h, so this is
already the case if I understand your correctly.
 
> (If you were to change that, please also update helper documentations to
> indicate what configuration options are required to be able to use the
> helpers.)

Ok, I'll add that.

Thanks again!

Sean
