Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52326 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2JCFiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 01:38:50 -0400
Received: by ieak13 with SMTP id k13so16511776iea.19
        for <linux-media@vger.kernel.org>; Tue, 02 Oct 2012 22:38:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506B4733.3070505@gmail.com>
References: <506B1D47.8040602@samsung.com>
	<20121002150603.31b6b72d@redhat.com>
	<506B4733.3070505@gmail.com>
Date: Wed, 3 Oct 2012 11:08:49 +0530
Message-ID: <CALt3h7-YQ6PAv+5Yy+x-9jFpKf0XEA6GY_U9v59PiC5FkcdC1w@mail.gmail.com>
Subject: Re: [GIT PULL FOR 3.7] Samsung Exynos MFC driver update
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sunil Joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

>
> Indeed it looks like big blob patch. I think this reflects how these patches
> were created, were one person creates practically new driver for new device
> revision, with not much care about the old one, and then somebody else is
> trying to make it a step by step process and ensuring support for all H/W
> revisions is properly maintained.
>
> Anyway, Arun, can you please rebase your patch series onto latest linuxtv
> for_v3.7 branch and try to split this above patch. AFAICS there are following
> things done there that could be separated:
>
> 1. Move contents of file s5p_mfc_opr.c to new file s5p_mfc_opr_v5.c
> 2. Rename functions in s5p_mfc_opr_v5.c
> 3. Use s5p_mfc_hw_call for H/W specific function calls
> 4. Do S5P_FIMV/S5P_MFC whatever magic.

I couldnt go with more finer splits, as I wanted to keep a working driver
between all successive patches. Now I will try to make the splits as
suggested and see if it can still be done.

>
> Also I've noticed some patches do break compilation. There are some definitions
> used there which are added only in subsequent patches. Arun, can you please make
> sure there is no build break after each single patch is applied ?

I have checked this while applying and I didnt see any break in
compilation after each patch is applied. I ensured not only compilation
but also a working driver after applying each patch. I will ensure
this again on
the next rebase.

I will make these suggested changes and post an updated patchset today.

Regards
Arun
