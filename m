Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49550 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751687AbbCVLN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 07:13:27 -0400
Date: Sun, 22 Mar 2015 13:12:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [GIT FIXES FOR v3.20] Fix USERPTR buffers for vb2 dma-contig mem
 type
Message-ID: <20150322111253.GK16613@valkosipuli.retiisi.org.uk>
References: <20150213101611.GJ32575@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150213101611.GJ32575@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping.

On Fri, Feb 13, 2015 at 12:16:11PM +0200, Sakari Ailus wrote:
> Hi Mauro,
> 
> This single patch fixes setting the write parameter to 1 for
> get_user_pages() on writable buffers. Without this using USERPTR buffers
> with the dma-contig mem type will corrupt system memory.
> 
> This is directly applicable to fixes and master branches and should be
> pulled into both.
> 
> The following changes since commit 4bad5d2d25099a42e146d7b18d2b98950ed287f5:
> 
>   [media] dvb_net: Convert local hex dump to print_hex_dump_debug (2015-02-03 18:24:44 -0200)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git vb2-fix
> 
> for you to fetch changes up to 5a433fbc3ead7d65143bf039eb77512d0558e2e7:
> 
>   vb2: Fix dma_dir setting for dma-contig mem type (2015-02-13 12:14:31 +0200)
> 
> ----------------------------------------------------------------
> Sakari Ailus (1):
>       vb2: Fix dma_dir setting for dma-contig mem type
> 
>  drivers/media/v4l2-core/videobuf2-dma-contig.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
