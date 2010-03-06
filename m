Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0CFRPI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Mar 2010 12:15:08 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o26HF6ti005787
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 6 Mar 2010 12:15:06 -0500
Received: from [10.11.9.128] (vpn-9-128.rdu.redhat.com [10.11.9.128])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o26HF3Nc030400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 6 Mar 2010 12:15:06 -0500
Message-ID: <4B928D97.70908@redhat.com>
Date: Sat, 06 Mar 2010 14:15:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linuxtv-commits] [git:v4l-dvb/master] ecryptfs: don't ignore
 return value from lock_rename
References: <E1Nnuzl-0002DJ-Q6@www.linuxtv.org>
In-Reply-To: <E1Nnuzl-0002DJ-Q6@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrew,

Patch from Erez Zadok wrote:
> From: Erez Zadok <ezk@cs.sunysb.edu>
> 
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> Cc: Dustin Kirkland <kirkland@canonical.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

Sorry for all those crappy messages! 

Please discard all messages you received today from linuxtv-commits. Due to an error at
the post-receive hook I wrote, linuxtv server tried to send a message for every commit
from 2.6.32-rc5 to 2.6.33, when I merged back from your tree.

After noticing the problem, I've stopped the exim and dropped all such messages from
the server queue, but several messages were already sent.

I've disabled the hook for now, until I find a way to properly handle merged patches on it.

Sorry for the inconvenience.
Mauro.


> 
>  fs/ecryptfs/inode.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/v4l-dvb.git?a=commitdiff;h=0d132f7364694da8f7cafd49e2fc2721b73e96e4
> 
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 5726d7a..764dc77 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -614,6 +614,7 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	struct dentry *lower_new_dentry;
>  	struct dentry *lower_old_dir_dentry;
>  	struct dentry *lower_new_dir_dentry;
> +	struct dentry *trap = NULL;
>  
>  	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
>  	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
> @@ -621,7 +622,17 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	dget(lower_new_dentry);
>  	lower_old_dir_dentry = dget_parent(lower_old_dentry);
>  	lower_new_dir_dentry = dget_parent(lower_new_dentry);
> -	lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
> +	trap = lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
> +	/* source should not be ancestor of target */
> +	if (trap == lower_old_dentry) {
> +		rc = -EINVAL;
> +		goto out_lock;
> +	}
> +	/* target should not be ancestor of source */
> +	if (trap == lower_new_dentry) {
> +		rc = -ENOTEMPTY;
> +		goto out_lock;
> +	}
>  	rc = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
>  			lower_new_dir_dentry->d_inode, lower_new_dentry);
>  	if (rc)
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits


-- 

Cheers,
Mauro
