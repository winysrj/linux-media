Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35671 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971145AbdDTQeW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Apr 2017 12:34:22 -0400
MIME-Version: 1.0
In-Reply-To: <881e9c72-62fc-157b-b74a-66dc14f111d4@xs4all.nl>
References: <20170419165936.2836426-1-arnd@arndb.de> <881e9c72-62fc-157b-b74a-66dc14f111d4@xs4all.nl>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 20 Apr 2017 18:34:20 +0200
Message-ID: <CAK8P3a386_bpmQg2bqRLmEJnU1e-SrddJxWNJbyAt=i7j7Sc8Q@mail.gmail.com>
Subject: Re: [PATCH] [media] sti: hdmi: improve MEDIA_CEC_NOTIFIER dependency
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Vincent Abriou <vincent.abriou@st.com>,
        David Airlie <airlied@linux.ie>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 19, 2017 at 11:06 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 19/04/17 18:59, Arnd Bergmann wrote:
>> When the media subsystem is built as a loadable module, a built-in

>> This adds a Kconfig dependency to enforce the HDMI driver to also
>> be a loadable module in this case.
>
> I've marked this patch and the exynos_hdmi patch as 'Obsoleted' in patchwork:
> today several CEC Kconfig cleanup patches were merged that invalidate these
> two patches. I expect they'll turn up soon in -next.

I can confirm that the previous problems are fixed with today's linux-next,
but I have now run into another problem, with CONFIG_INPUT=m forcing
CONFIG_RC_CORE=m:

drivers/media/cec/cec-core.o: In function `cec_unregister_adapter':
cec-core.c:(.text.cec_unregister_adapter+0x18): undefined reference to
`rc_unregister_device'
drivers/media/cec/cec-core.o: In function `cec_delete_adapter':
cec-core.c:(.text.cec_delete_adapter+0x54): undefined reference to
`rc_free_device'
drivers/media/cec/cec-core.o: In function `cec_register_adapter':
cec-core.c:(.text.cec_register_adapter+0x94): undefined reference to
`rc_register_device'
cec-core.c:(.text.cec_register_adapter+0xa4): undefined reference to
`rc_free_device'
cec-core.c:(.text.cec_register_adapter+0x110): undefined reference to
`rc_unregister_device'
drivers/media/cec/cec-core.o: In function `cec_allocate_adapter':
cec-core.c:(.text.cec_allocate_adapter+0x234): undefined reference to
`rc_allocate_device'
drivers/media/cec/cec-adap.o: In function `cec_received_msg':
cec-adap.c:(.text.cec_received_msg+0x734): undefined reference to `rc_keydown'
cec-adap.c:(.text.cec_received_msg+0x768): undefined reference to `rc_keyup'
/git/arm-soc/Makefile:1033: recipe for target 'vmlinux' failed

I don't see an obvious fix for  this, and as you seem to have a good grip on the
problem already, I'll let you figure out how to best address it.

       Arnd
