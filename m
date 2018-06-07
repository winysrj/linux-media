Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:56300 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933635AbeFGSMi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 14:12:38 -0400
Received: by mail-wm0-f66.google.com with SMTP id v16-v6so19686208wmh.5
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 11:12:37 -0700 (PDT)
Date: Thu, 7 Jun 2018 20:12:34 +0200
From: Simon Horman <simon.horman@netronome.com>
To: Sean Young <sean@mess.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>,
        Matthias Reichl <hias@horus.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH] bpf: attach type BPF_LIRC_MODE2 should not depend on
 CONFIG_BPF_CGROUP
Message-ID: <20180607181233.oazgcezk2tgeiuqc@netronome.com>
References: <cover.1527419762.git.sean@mess.org>
 <9f2c54d4956f962f44fcda739a824397ddea132c.1527419762.git.sean@mess.org>
 <20180604174730.sctfoklq7klswebp@camel2.lan>
 <20180605101629.yffyp64o7adg6hu5@gofer.mess.org>
 <04cc36e7-4597-dc57-4ad7-71afcc17244a@iogearbox.net>
 <20180606210939.q3vviyc4b2h6gu3c@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180606210939.q3vviyc4b2h6gu3c@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 06, 2018 at 10:09:40PM +0100, Sean Young wrote:
> Compile bpf_prog_{attach,detach,query} even if CONFIG_BPF_CGROUP is not
> set.
> 
> Signed-off-by: Sean Young <sean@mess.org>

Hi Sean,

This patch seems to involve rather extensive refactoring, the details of
which are not explained, in order to make a change whose motivation is also
not explained. I for one would value a more extensive changelog if
not a series of patches which implement discrete changes.

Thanks!
