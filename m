Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35714 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbdBWRsV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 12:48:21 -0500
MIME-Version: 1.0
In-Reply-To: <1487870304.14159.29.camel@perches.com>
References: <cover.1487314666.git.joe@perches.com> <CAL_JsqLTaq-QLTqfyDO8EVJYpgeUx1e4J0Fo2NvfFWqVoiVedQ@mail.gmail.com>
 <1487870304.14159.29.camel@perches.com>
From: Emil Velikov <emil.l.velikov@gmail.com>
Date: Thu, 23 Feb 2017 17:41:20 +0000
Message-ID: <CACvgo50LUm5VSn_F=Dh8kL5zCPpCQDoCyUEL=Z+=1+6hJpfTaw@mail.gmail.com>
Subject: Re: [PATCH 00/35] treewide trivial patches converting pr_warning to pr_warn
To: Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-ia64@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        ML nouveau <nouveau@lists.freedesktop.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:VIRTIO GPU DRIVER"
        <virtualization@lists.linux-foundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        sparclinux@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        sfi-devel@simplefirmware.org,
        amd-gfx mailing list <amd-gfx@lists.freedesktop.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        tboot-devel@lists.sourceforge.net, oprofile-list@lists.sf.net,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        xen-devel@lists.xenproject.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        gigaset307x-common@lists.sourceforge.net,
        acpi4asus-user@lists.sourceforge.net,
        adi-buildroot-devel@lists.sourceforge.net,
        Pekka Paalanen <ppaalanen@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Karol Herbst <karolherbst@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-alpha@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 February 2017 at 17:18, Joe Perches <joe@perches.com> wrote:
> On Thu, 2017-02-23 at 09:28 -0600, Rob Herring wrote:
>> On Fri, Feb 17, 2017 at 1:11 AM, Joe Perches <joe@perches.com> wrote:
>> > There are ~4300 uses of pr_warn and ~250 uses of the older
>> > pr_warning in the kernel source tree.
>> >
>> > Make the use of pr_warn consistent across all kernel files.
>> >
>> > This excludes all files in tools/ as there is a separate
>> > define pr_warning for that directory tree and pr_warn is
>> > not used in tools/.
>> >
>> > Done with 'sed s/\bpr_warning\b/pr_warn/' and some emacsing.
> []
>> Where's the removal of pr_warning so we don't have more sneak in?
>
> After all of these actually get applied,
> and maybe a cycle or two later, one would
> get sent.
>
By which point you'll get a few reincarnation of it. So you'll have to
do the same exercise again :-(

I guess the question is - are you expecting to get the series merged
all together/via one tree ? If not, your plan is perfectly reasonable.
Fwiw in the DRM subsystem, similar cleanups does purge the respective
macros/other with the final commit. But there one can pull the lot in
one go.

Regards,
Emil
