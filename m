Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585F1C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 02:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2342A2145D
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 02:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WZ3k1uoh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbeLRCF1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 21:05:27 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33339 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbeLRCF1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 21:05:27 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so14285917wrr.0;
        Mon, 17 Dec 2018 18:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gp5oBxJMffKFMYY7T/TAUB+UvDykRhd5sHGr6PNUtQ0=;
        b=WZ3k1uohdhinXGNtm6QTuADPGhR8MybqelvCxZbstonzeM7o80CDfzUJKYGp0kzgoV
         tWTqOBra+dyJ7btJAMv5ZRQA5/Dxx6uUnlbw5kU2fPhXZvoojzzg6sc43qWd7tcHIq5L
         EuYyO+819RVlNHqMif3zBMEK0Ebzzwu5K9LPf9DCZIK1GF7EJPCyt1ylGl6AaHaNeSm0
         LcOki7mSX89pJX1mFjtzdneCB9u5kky1oHNM+oFulA1DvU+erjPPL48CRG6GKg26GOpT
         AdOniZ+s6jVObBeejWQj9bWt2TXkTu372mG3NkqTkVQO9j1rIhamiDU3J9d1dNlU4B26
         BPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gp5oBxJMffKFMYY7T/TAUB+UvDykRhd5sHGr6PNUtQ0=;
        b=DdAjRO+L5n+BaX8V/Y5Uyr78QLclhEPHJly6Ky3++N+LScy+qZjASGmN8EUMw6zTUY
         SRMgP2eI+tavkz763uE3zYoMd9+IlMgCzYTSx/XES4OFh8C12DoV5uyvIJuSnVQ1HIFT
         L7lOMeLaXXBNLcDezhyiaP+9jfxZNqMUaZueysPVYdH2FhqR6hmbx5oEK39qjtkDRFXy
         Axa1oKZGYF/+4/2QKwq+A3Es/b/BVu98vTQjLWE+wHWHeDHIf9xMKP8E+W6jh+Od3tHu
         K7KgnfZyJvOTkWExZQBGk/ANfgqCoxhm0TAv2Ig8CRPW8QDMbEkS+jF7/BdIyOtGOvvb
         5c1Q==
X-Gm-Message-State: AA+aEWaCP99A8nE7HWjLs9IVm8Ep/b2cHL3IgjLrENHRzRsyImBSA4j8
        O0rGoKAGtvnUNmB9J9Xhf0vm5LIlNFHTtoVym8A=
X-Google-Smtp-Source: AFSGD/VyLZWdEsppuq5Exz1vfI5QVSN5jQdeGwh3m6PiwWwA+q+QlrOP5XaXji8k6wHJ/wGhKb7rDWX1r4Mw9X4HquU=
X-Received: by 2002:adf:8506:: with SMTP id 6mr13296194wrh.128.1545098724214;
 Mon, 17 Dec 2018 18:05:24 -0800 (PST)
MIME-Version: 1.0
References: <3d7393a6287db137a69c4d05785522d5@gmx.de> <20181205090721.43e7f36c@coco.lan>
 <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc> <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
 <20181206160145.2d23ac0e@coco.lan> <8858694d5934ce78e46ef48d6f90061a@gmx.de> <20181216122315.2539ae80@coco.lan>
In-Reply-To: <20181216122315.2539ae80@coco.lan>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 17 Dec 2018 21:05:11 -0500
Message-ID: <CADnq5_Ntq7_pXkTE53-PV15G5BUP9WOJ8YQ8+Q+OBzCkWVRCgQ@mail.gmail.com>
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
To:     mchehab@kernel.org,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Cc:     Markus Dobel <markus.dobel@gmx.de>,
        Brad Love <brad@nextdimension.cc>,
        linux-media <linux-media@vger.kernel.org>,
        linux-media-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sun, Dec 16, 2018 at 9:23 AM Mauro Carvalho Chehab
<mchehab@kernel.org> wrote:
>
> Em Sun, 16 Dec 2018 11:37:02 +0100
> Markus Dobel <markus.dobel@gmx.de> escreveu:
>
> > On 06.12.2018 19:01, Mauro Carvalho Chehab wrote:
> > > Em Thu, 06 Dec 2018 18:18:23 +0100
> > > Markus Dobel <markus.dobel@gmx.de> escreveu:
> > >
> > >> Hi everyone,
> > >>
> > >> I will try if the hack mentioned fixes the issue for me on the weekend
> > >> (but I assume, as if effectively removes the function).
> > >
> > > It should, but it keeps a few changes. Just want to be sure that what
> > > would be left won't cause issues. If this works, the logic that would
> > > solve Ryzen DMA fixes will be contained into a single point, making
> > > easier to maintain it.
> >
> > Hi,
> >
> > I wanted to have this setup running stable for a few days before
> > replying, that's why I am answering only now.
> >
> > But yes, as expected, with Mauro's hack, the driver has been stable for
> > me for about a week, with several
> > scheduled recordings in tvheadend, none of them missed.
> >
> > So, adding a reliable detection for affected chipsets, where the `if
> > (1)` currently is, should work.
>
> Markus,
>
> Thanks for testing!
>
> Brad/Alex,
>
> I guess we should then stick with this patch:
>         https://patchwork.linuxtv.org/patch/53351/
>
> The past approach that we used on cx88, bttv and other old drivers
> were to patch drivers/pci/quirks.c, making them to "taint" DMA
> memory controllers that were known to bad affect on media devices,
> and then some logic at the drivers to check for such "taint".
>
> However, that would require to touch another subsystem, with
> usually cause delays. Also, as Alex pointed, this could well
> be just a matter of incompatibility between the cx23885 and
> the Ryzen DMA controller, and may not affect any other drivers.
>
> So, let's start with a logic like what I proposed, fine
> tuning it to the Ryzen DMA controllers with we know have
> troubles with the driver.
>
> We need to list the PCI ID of the memory controllers at the
> device ID table on that patch, though. At the RFC patch,
> I just added an IOMMU PCI ID from a randon Ryzen CPU:
>
>         +static struct {
>         +       int vendor, dev;
>         +} const broken_dev_id[] = {
>         +       /* According with
>         +        * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%201800X/lspci,
>         +        * 0x1451 is PCI ID for the IOMMU found on Ryzen 7
>         +        */
>         +       { PCI_VENDOR_ID_AMD, 0x1451 },
>         +};
>         +
>
> Ideally, the ID for the affected Ryzen DMA engines should be there at
> include/linux/pci_ids.h, instead of hard-coded inside a driver.
>
> Also, we should, instead, add there the PCI IDs of the DMA engines
> that are known to have problems with the cx23885.

These aren't really DMA engines.  Isn't this just the pcie bridge on the CPU?


>
> There one thing that still bothers me: could this problem be due to
> some BIOS setup [1]? If so, are there any ways for dynamically
> disabling such features inside the driver?
>
> [1] like this: https://www.techarp.com/bios-guide/cpu-pci-write-buffer/
>

possibly?  It's still not clear to me that this is specific to ryzen
chips rather than a problem with the DMA setup on the cx board.  Is
there a downside to enabling the workaround in general?  The original
commit mentioned that xeon platforms were affected as well.  Is it
possible it's just particular platforms with wonky bioses?  Maybe DMI
matching would be better?

> Brad,
>
> From your reports about the DMA issues, do you know what generations
> of the Ryzen are affected?
>
> Alex,
>
> Do you know if are there any differences at the IP block for the
> DMA engine used on different Ryzen CPUs? I mean: I suspect that
> the engine for Ryzen 2nd generation would likely be different than
> the one at the 1st generation, but, along the same generation, does
> the Ryzen 3, 5, 7 and Threadripper use the same DMA engine?

+ Suravee.  I'm not really familiar with the changes, if any, that are
in the pcie bridges on various AMD CPUs.  Or if there are changes, it
would be hard to say whether this issue would affect them or not.

Alex
