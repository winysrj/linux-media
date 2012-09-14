Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:40319 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758704Ab2INKPx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:15:53 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <lliubbo@gmail.com>,
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
Date: Fri, 14 Sep 2012 18:15:19 +0800
Subject: RE: [PATCH] nommu: remap_pfn_range: fix addr parameter check
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FB1E6975F@EAPEX1MAIL1.st.com>
References: <1347504057-5612-1-git-send-email-lliubbo@gmail.com>
	<20120913122738.04eaceb3.akpm@linux-foundation.org>
 <CAHG8p1CJ7YizySrocYvQeCye4_63TkAimsAGU1KC5+Fn0wqF8w@mail.gmail.com>
In-Reply-To: <CAHG8p1CJ7YizySrocYvQeCye4_63TkAimsAGU1KC5+Fn0wqF8w@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Scott Jiang [mailto:scott.jiang.linux@gmail.com]
> Sent: Friday, September 14, 2012 2:53 PM
> To: Andrew Morton
> Cc: Bob Liu; linux-mm@kvack.org; Bhupesh SHARMA;
> laurent.pinchart@ideasonboard.com; uclinux-dist-
> devel@blackfin.uclinux.org; linux-media@vger.kernel.org;
> dhowells@redhat.com; geert@linux-m68k.org; gerg@uclinux.org;
> stable@kernel.org; gregkh@linuxfoundation.org; Hugh Dickins
> Subject: Re: [PATCH] nommu: remap_pfn_range: fix addr parameter check
> 
> > Yes, the MMU version of remap_pfn_range() does permit non-page-
> aligned
> > `addr' (at least, if the userspace maaping is a non-COW one).  But I
> > suspect that was an implementation accident - it is a nonsensical
> > thing to do, isn't it?  The MMU cannot map a bunch of kernel pages
> > onto a non-page-aligned userspace address.
> >
> > So I'm thinking that we should declare ((addr & ~PAGE_MASK) != 0) to
> > be a caller bug, and fix up this regrettably unidentified v4l driver?
> 
> I agree. This should be fixed in videobuf.
> 
> Hi sharma, what's your kernel version? It seems videobuf2 already fixed this
> bug in 3.5.

Hi Scott,

I was using 3.3 linux kernel. I will again check if videobuf2 in 3.5 has already fixed this issue.

Regards,
Bhupesh


