Return-path: <linux-media-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:34308 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756209AbeFOODR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 10:03:17 -0400
Subject: Re: [PATCH] bpf: attach type BPF_LIRC_MODE2 should not depend on
 CONFIG_CGROUP_BPF
To: Sean Young <sean@mess.org>
Cc: Y Song <ys114321@gmail.com>, Matthias Reichl <hias@horus.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
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
 <34406f72-722d-9c23-327f-b7c5d7a3090c@iogearbox.net>
 <20180614184207.khwcmwmj4duous4c@gofer.mess.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d2613314-406e-dd7d-1cf0-b5a78a155e3b@iogearbox.net>
Date: Fri, 15 Jun 2018 16:03:13 +0200
MIME-Version: 1.0
In-Reply-To: <20180614184207.khwcmwmj4duous4c@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On 06/14/2018 08:42 PM, Sean Young wrote:
> If the kernel is compiled with CONFIG_CGROUP_BPF not enabled, it is not
> possible to attach, detach or query IR BPF programs to /dev/lircN devices,
> making them impossible to use. For embedded devices, it should be possible
> to use IR decoding without cgroups or CONFIG_CGROUP_BPF enabled.
> 
> This change requires some refactoring, since bpf_prog_{attach,detach,query}
> functions are now always compiled, but their code paths for cgroups need
> moving out. Rather than a #ifdef CONFIG_CGROUP_BPF in kernel/bpf/syscall.c,
> moving them to kernel/bpf/cgroup.c does not require #ifdefs since that file
> is already conditionally compiled.
> 
> Signed-off-by: Sean Young <sean@mess.org>

Just two minor edits below from my side:

>  include/linux/bpf-cgroup.h |  31 +++++++++++
>  kernel/bpf/cgroup.c        | 110 +++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c       | 105 ++---------------------------------
>  3 files changed, 145 insertions(+), 101 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 975fb4cf1bb7..ee67cd35f426 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -188,12 +188,43 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
>  									      \
>  	__ret;								      \
>  })
> +int sockmap_get_from_fd(const union bpf_attr *attr, int type, bool attach);
> +int cgroup_bpf_prog_attach(const union bpf_attr *attr,
> +			   enum bpf_prog_type ptype);
> +int cgroup_bpf_prog_detach(const union bpf_attr *attr,
> +			   enum bpf_prog_type ptype);
> +int cgroup_bpf_prog_query(const union bpf_attr *attr,
> +			  union bpf_attr __user *uattr);
>  #else
>  
>  struct cgroup_bpf {};
>  static inline void cgroup_bpf_put(struct cgroup *cgrp) {}
>  static inline int cgroup_bpf_inherit(struct cgroup *cgrp) { return 0; }
>  
> +static inline int sockmap_get_from_fd(const union bpf_attr *attr,
> +				      int type, bool attach)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int cgroup_bpf_prog_attach(const union bpf_attr *attr,
> +					 enum bpf_prog_type ptype)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int cgroup_bpf_prog_detach(const union bpf_attr *attr,
> +					 enum bpf_prog_type ptype)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
> +					union bpf_attr __user *uattr)
> +{
> +	return -EINVAL;
> +}
> +
>  #define cgroup_bpf_enabled (0)
>  #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
>  #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk,skb) ({ 0; })
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index f7c00bd6f8e4..d6e18f9dc0c4 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -428,6 +428,116 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  	return ret;
>  }
>  
> +int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
> +				      enum bpf_attach_type attach_type)
> +{
> +	switch (prog->type) {
> +	case BPF_PROG_TYPE_CGROUP_SOCK:
> +	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> +		return attach_type == prog->expected_attach_type ? 0 : -EINVAL;
> +	default:
> +		return 0;
> +	}
> +}

This one is rather BPF core, cgroup progs only happen to use it. Could
you either move it as static inline into include/linux/bpf.h or leave it
in kernel/bpf/syscall.c? In any case the #ifdef CONFIG_CGROUP_BPF wrapper
could probably be dropped as well from it.

> +int sockmap_get_from_fd(const union bpf_attr *attr, int type, bool attach)
> +{
> +	struct bpf_prog *prog = NULL;
> +	int ufd = attr->target_fd;
> +	struct bpf_map *map;
> +	struct fd f;
> +	int err;
> +
> +	f = fdget(ufd);
> +	map = __bpf_map_get(f);
> +	if (IS_ERR(map))
> +		return PTR_ERR(map);
> +
> +	if (attach) {
> +		prog = bpf_prog_get_type(attr->attach_bpf_fd, type);
> +		if (IS_ERR(prog)) {
> +			fdput(f);
> +			return PTR_ERR(prog);
> +		}
> +	}
> +
> +	err = sock_map_prog(map, prog, attr->attach_type);
> +	if (err) {
> +		fdput(f);
> +		if (prog)
> +			bpf_prog_put(prog);
> +		return err;
> +	}
> +
> +	fdput(f);
> +	return 0;
> +}

And this one should rather end up in kernel/bpf/sockmap.c to have it with
the rest of sockmap code. Moving into cgroup.c would rather be a in the
wrong place given what the code does.

Thanks,
Daniel
