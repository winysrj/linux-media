Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47270 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2IQGCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 02:02:33 -0400
Received: by iahk25 with SMTP id k25so5091207iah.19
        for <linux-media@vger.kernel.org>; Sun, 16 Sep 2012 23:02:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FB1E69774@EAPEX1MAIL1.st.com>
References: <1347504057-5612-1-git-send-email-lliubbo@gmail.com>
	<20120913122738.04eaceb3.akpm@linux-foundation.org>
	<CAHG8p1CJ7YizySrocYvQeCye4_63TkAimsAGU1KC5+Fn0wqF8w@mail.gmail.com>
	<D5ECB3C7A6F99444980976A8C6D896384FB1E69774@EAPEX1MAIL1.st.com>
Date: Mon, 17 Sep 2012 14:02:32 +0800
Message-ID: <CAHG8p1AwCSvWJm_xvpOOr4PAcQ6MjWgYx+RKa2i6OHPwRSkCig@mail.gmail.com>
Subject: Re: [PATCH] nommu: remap_pfn_range: fix addr parameter check
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bob Liu <lliubbo@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"geert@linux-m68k.org" <geert@linux-m68k.org>,
	"gerg@uclinux.org" <gerg@uclinux.org>,
	"stable@kernel.org" <stable@kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I was using 3.3 linux kernel. I will again check if videobuf2 in 3.5 has already
>> fixed this issue.
>
> [snip..]
>
> Ok I just checked the vb2_dma_contig allocator and it has no major changes from my version,
> http://lxr.linux.no/linux+v3.5.3/drivers/media/video/videobuf2-dma-contig.c#L37
>
> So, I am not sure if this issue has been fixed in the videobuf2 (or if any patch is in the pipeline
> which fixes the issue).
>
I run my test on our blackfin platform, and all addresses in
remap_pfn_range is aligned for 3.5 branch.
