Return-path: <linux-media-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42554 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbcAFQea (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 11:34:30 -0500
Date: Wed, 6 Jan 2016 16:34:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH][davinci] ccdc_update_raw_params() frees the wrong thing
Message-ID: <20160106163427.GV9938@ZenIV.linux.org.uk>
References: <20151213003201.GQ20997@ZenIV.linux.org.uk>
 <CA+V-a8v-NC9oToS5KcaGwuATAxvOaXE3p=uT769uaKoebBVeBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8v-NC9oToS5KcaGwuATAxvOaXE3p=uT769uaKoebBVeBg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 05, 2016 at 05:37:06PM +0000, Lad, Prabhakar wrote:
> On Sun, Dec 13, 2015 at 12:32 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >         Passing a physical address to free_pages() is a bad idea.
> > config_params->fault_pxl.fpc_table_addr is set to virt_to_phys()
> > of __get_free_pages() return value; what we should pass to free_pages()
> > is its phys_to_virt().  ccdc_close() does that properly, but
> > ccdc_update_raw_params() doesn't.
> >
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> >
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Regards,
> --Prabhakar Lad

	Which tree should it go through?  I can certainly put that into
vfs.git#work.misc, but it looks like a better fit for linux-media tree, or
the davinci-specific one...
