Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34240 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbcEQVgG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 17:36:06 -0400
MIME-Version: 1.0
In-Reply-To: <20160517212956.GV27098@phenom.ffwll.local>
References: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
	<1462806459-8124-2-git-send-email-benjamin.gaignard@linaro.org>
	<CACvgo52cHhJ0XoibSXgu2eBg1sK51_nFqtA9CmWZwtCDYa7-WQ@mail.gmail.com>
	<CA+M3ks56F61k9NPs18eYTmvNkUGmeytLQRENHVgv1ZYUGtW9Gw@mail.gmail.com>
	<CACvgo508W=BxwMkkOP5EswnDqnjfcWmvX1cShbie1nF3-8brTw@mail.gmail.com>
	<20160517212956.GV27098@phenom.ffwll.local>
Date: Tue, 17 May 2016 22:36:03 +0100
Message-ID: <CACvgo53bRiE-At1ntM3yTHYmpiURnHpx=-sYQV_e=f5d+MVAmw@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] create SMAF module
From: Emil Velikov <emil.l.velikov@gmail.com>
To: Emil Velikov <emil.l.velikov@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Cc Ma <cc.ma@mediatek.com>,
	Pascal Brand <pascal.brand@linaro.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Dan Caprita <dan.caprita@windriver.com>,
	Zoltan Kuscsik <zoltan.kuscsik@linaro.org>,
	Joakim Bech <joakim.bech@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 May 2016 at 22:29, Daniel Vetter <daniel@ffwll.ch> wrote:

> Please don't use __kernel_size_t, it's only for backwards compat if you
> already botched an ioctl definition ;-)
>
That explains why I've not seen it in (m)any other UAPI headers but
our legacy ones.

Thank you !
Emil
