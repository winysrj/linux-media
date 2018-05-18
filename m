Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39664 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752348AbeERNsH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 09:48:07 -0400
Received: by mail-wr0-f193.google.com with SMTP id w18-v6so5534217wrn.6
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 06:48:06 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] bpf: add selftest for rawir_event type program
To: Sean Young <sean@mess.org>
Cc: Y Song <ys114321@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
References: <cover.1526504511.git.sean@mess.org>
 <78945f2bf82e9f16695f72bed3930d1302d38e29.1526504511.git.sean@mess.org>
 <CAH3MdRUhrBzHXKgcu1htSHTqeKVWnci+ADrTriCqjXLHUezB+w@mail.gmail.com>
 <20180517210140.ck225yuckq6onheb@gofer.mess.org>
 <86ffb16c-9b4e-c826-ecd2-82266e7b8c2e@netronome.com>
 <20180518133329.fafkew5nkr2bmzah@gofer.mess.org>
From: Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <efa49fb3-0d7d-ecb2-861e-5d61186e161e@netronome.com>
Date: Fri, 18 May 2018 14:48:04 +0100
MIME-Version: 1.0
In-Reply-To: <20180518133329.fafkew5nkr2bmzah@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-05-18 14:33 UTC+0100 ~ Sean Young <sean@mess.org>
> On Fri, May 18, 2018 at 11:13:07AM +0100, Quentin Monnet wrote:
>> 2018-05-17 22:01 UTC+0100 ~ Sean Young <sean@mess.org>
>>> On Thu, May 17, 2018 at 10:17:59AM -0700, Y Song wrote:
>>>> On Wed, May 16, 2018 at 2:04 PM, Sean Young <sean@mess.org> wrote:
>>>>> This is simple test over rc-loopback.
>>>>>
>>>>> Signed-off-by: Sean Young <sean@mess.org>
>>>>> ---
>>>>>  tools/bpf/bpftool/prog.c                      |   1 +
>>>>>  tools/include/uapi/linux/bpf.h                |  57 +++++++-
>>>>>  tools/lib/bpf/libbpf.c                        |   1 +
>>>>>  tools/testing/selftests/bpf/Makefile          |   8 +-
>>>>>  tools/testing/selftests/bpf/bpf_helpers.h     |   6 +
>>>>>  tools/testing/selftests/bpf/test_rawir.sh     |  37 +++++
>>>>>  .../selftests/bpf/test_rawir_event_kern.c     |  26 ++++
>>>>>  .../selftests/bpf/test_rawir_event_user.c     | 130 ++++++++++++++++++
>>>>>  8 files changed, 261 insertions(+), 5 deletions(-)
>>>>>  create mode 100755 tools/testing/selftests/bpf/test_rawir.sh
>>>>>  create mode 100644 tools/testing/selftests/bpf/test_rawir_event_kern.c
>>>>>  create mode 100644 tools/testing/selftests/bpf/test_rawir_event_user.c
>>
>> [...]
>>
>>>> Most people probably not really familiar with lircN device. It would be
>>>> good to provide more information about how to enable this, e.g.,
>>>>   CONFIG_RC_CORE=y
>>>>   CONFIG_BPF_RAWIR_EVENT=y
>>>>   CONFIG_RC_LOOPBACK=y
>>>>   ......
>>>
>>> Good point. I'll add some words explaining what is and how to make it work.
>>>
>>> Thanks
>>> Sean
>>
>>
>> By the way, shouldn't the two eBPF helpers bpf_rc_keydown() and
>> bpf_rc_repeat() be compiled out in patch 1 if e.g.
>> CONFIG_BPF_RAWIR_EVENT is not set? There are some other helpers that are
>> compiled only if relevant config options are set (bpf_get_xfrm_state()
>> for example).
> 
> So if CONFIG_BPF_RAWIR_EVENT is not set, then bpf-rawir-event.c is not
> compiled. Stubs are created in include/linux/bpf_rcdev.h, so this is
> already the case if I understand your correctly.

This is correct, sorry for the mistake.

>> (If you were to change that, please also update helper documentations to
>> indicate what configuration options are required to be able to use the
>> helpers.)
> 
> Ok, I'll add that.
Thanks a lot!

Quentin
