Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:51425 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0CFOnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 09:43:03 -0500
Subject: Re: [git:v4l-dvb/master] NFS: Fix a bug in
 nfs_fscache_release_page()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org, David Howells <dhowells@redhat.com>
In-Reply-To: <E1NnuxV-0000pd-GG@www.linuxtv.org>
References: <E1NnuxV-0000pd-GG@www.linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 06 Mar 2010 09:43:02 -0500
Message-ID: <1267886582.4688.8.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-03-06 at 15:26 +0100, Patch from Trond Myklebust wrote: 
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> Not having an fscache cookie is perfectly valid if the user didn't mount
> with the fscache option.
> 
> This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=15234
> 
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Acked-by: David Howells <dhowells@redhat.com>
> Cc: stable@kernel.org
> 
>  fs/nfs/fscache.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/v4l-dvb.git?a=commitdiff;h=2c1740098c708b465e87637b237feb2fd98f129a
> 
> diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
> index fa58800..237874f 100644
> --- a/fs/nfs/fscache.c
> +++ b/fs/nfs/fscache.c
> @@ -354,12 +354,11 @@ void nfs_fscache_reset_inode_cookie(struct inode *inode)
>   */
>  int nfs_fscache_release_page(struct page *page, gfp_t gfp)
>  {
> -	struct nfs_inode *nfsi = NFS_I(page->mapping->host);
> -	struct fscache_cookie *cookie = nfsi->fscache;
> -
> -	BUG_ON(!cookie);
> -
>  	if (PageFsCache(page)) {
> +		struct nfs_inode *nfsi = NFS_I(page->mapping->host);
> +		struct fscache_cookie *cookie = nfsi->fscache;
> +
> +		BUG_ON(!cookie);
>  		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
>  			 cookie, page, nfsi);
>  

Err.... Why are we receiving this email? This changeset is already
committed upstream in Linus' tree and has nothing to do with V4L/DVB.

Trond
