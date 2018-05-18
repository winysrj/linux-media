Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:40347 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbeERUIu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 16:08:50 -0400
MIME-Version: 1.0
In-Reply-To: <36f48c3a4a563bd8cdac18bcf8d48c0d06365863.1526651592.git.sean@mess.org>
References: <cover.1526651592.git.sean@mess.org> <36f48c3a4a563bd8cdac18bcf8d48c0d06365863.1526651592.git.sean@mess.org>
From: Y Song <ys114321@gmail.com>
Date: Fri, 18 May 2018 13:08:09 -0700
Message-ID: <CAH3MdRWfFDXz0Vc7m9bw817DnWj4BPj8s7eOteBk+ZUqMqyFcg@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] bpf: bpf_prog_array_copy() should return -ENOENT
 if exclude_prog not found
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 7:07 AM, Sean Young <sean@mess.org> wrote:
> This makes is it possible for bpf prog detach to return -ENOENT.
>
> Signed-off-by: Sean Young <sean@mess.org>

Acked-by: Yonghong Song <yhs@fb.com>
