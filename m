Return-path: <linux-media-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:36291 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbeFEKeC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 06:34:02 -0400
Subject: Re: [PATCH v5 2/3] media: rc: introduce BPF_PROG_LIRC_MODE2
To: Sean Young <sean@mess.org>, Matthias Reichl <hias@horus.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
References: <cover.1527419762.git.sean@mess.org>
 <9f2c54d4956f962f44fcda739a824397ddea132c.1527419762.git.sean@mess.org>
 <20180604174730.sctfoklq7klswebp@camel2.lan>
 <20180605101629.yffyp64o7adg6hu5@gofer.mess.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <04cc36e7-4597-dc57-4ad7-71afcc17244a@iogearbox.net>
Date: Tue, 5 Jun 2018 12:33:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180605101629.yffyp64o7adg6hu5@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/05/2018 12:16 PM, Sean Young wrote:
> On Mon, Jun 04, 2018 at 07:47:30PM +0200, Matthias Reichl wrote:
[...]
>>> @@ -1695,6 +1700,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
>>>  	case BPF_CGROUP_SOCK_OPS:
>>>  	case BPF_CGROUP_DEVICE:
>>>  		break;
>>> +	case BPF_LIRC_MODE2:
>>> +		return lirc_prog_query(attr, uattr);
>>
>> When testing this patch series I was wondering why I always got
>> -EINVAL when trying to query the registered programs.
>>
>> Closer inspection revealed that bpf_prog_attach/detach/query and
>> calls to them in the bpf syscall are in "#ifdef CONFIG_CGROUP_BPF"
>> blocks - and as I built the kernel without CONFIG_CGROUP_BPF
>> BPF_PROG_ATTACH/DETACH/QUERY weren't handled in the syscall switch
>> and I got -EINVAL from the bpf syscall function.
>>
>> I haven't checked in detail yet, but it looks to me like
>> bpf_prog_attach/detach/query could always be built (or when
>> either cgroup bpf or lirc bpf are enabled) and the #ifdefs moved
>> inside the switch(). So lirc bpf could be used without cgroup bpf.
>> Or am I missing something?
> 
> You are right, this features depends on CONFIG_CGROUP_BPF right now. This
> also affects the BPF_SK_MSG_VERDICT, BPF_SK_SKB_STREAM_VERDICT and
> BPF_SK_SKB_STREAM_PARSER type bpf attachments, and as far as I know
> these shouldn't depend on CONFIG_CGROUP_BPF either.

The latter three do depend on it from a bigger picture as sockmap progs
are orchestrated via cgroups. But I'd be fine if you decouple lirc from
it since there's really no dependency at all, and presumably there are
valid cases where you would want to run it on low-end devices with minimal
kernel.

Thanks,
Daniel
