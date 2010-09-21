Return-path: <mchehab@pedra>
Received: from mailgw.cvut.cz ([147.32.3.235]:41309 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab0IURU2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 13:20:28 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: Remaining BKL users, what to do
From: Petr Vandrovec <vandrove@vc.cvut.cz>
Date: Fri, 17 Sep 2010 16:21:41 -0700
To: Arnd Bergmann <arnd@arndb.de>, Anton Altaparmakov <aia21@cam.ac.uk>
CC: Jan Kara <jack@suse.cz>, codalist@coda.cs.cmu.edu,
	autofs@linux.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Anders Larsen <al@alarsen.net>,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Andrew Hendry <andrew.hendry@gmail.com>
Message-ID: <ead83d0d-e0ae-456d-8702-16ed8d3a179a@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'll try to come up with something for ncpfs.

Trivial lock replacement will open deadlock possibility when someone reads to page which is also mmaped from the same filesystem (like grep likes to do). BKL with its automated release on sleep helped (or papered over) a lot here.

Petr

"Arnd Bergmann" <arnd@arndb.de> wrote:

>On Thursday 16 September 2010, Anton Altaparmakov wrote:
>> On 16 Sep 2010, at 16:04, Jan Kara wrote:
>> > On Thu 16-09-10 16:32:59, Arnd Bergmann wrote:
>> >> The big kernel lock is gone from almost all code in linux-next, this is
>> >> the status of what I think will happen to the remaining users:
>> > ...
>> >> fs/ncpfs:
>> >>      Should be fixable if Petr still cares about it. Otherwise suggest
>> >>      moving to drivers/staging if there are no users left.
>> >  I think some people still use this...
>> 
>> Yes, indeed.  Netware is still alive (unfortunately!) and ncpfs is used in a lot of 
>> Universities here in the UK at least (we use it about a thousand workstations and
>> servers here at Cambridge University!).
>
>Ok, that means at least when someone gets around to fix it, there will be
>people that can test the patches.
>
>If you know someone who would like to help on this, it would be nice to try
>out the patch below, unless someone can come up with a better solution.
>My naïve understanding of the code tells me that simply using the super block
>lock there may work. In fact it makes locking stricter, so if it still works
>with that patch, there are probably no subtle regressions.
>The patch applies to current linux-next of my bkl/vfs series.
>
>	Arnd
>
>---
>ncpfs: replace BKL with lock_super
>
>This mindlessly changes every instance of lock_kernel in ncpfs to
>lock_super. I haven't tested this, it may work or may break horribly.
>Please test with CONFIG_LOCKDEP enabled.
>
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
>diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
>index 9578cbe..303338d 100644
>--- a/fs/ncpfs/dir.c
>+++ b/fs/ncpfs/dir.c
>@@ -19,7 +19,6 @@
> #include <linux/mm.h>
> #include <asm/uaccess.h>
> #include <asm/byteorder.h>
>-#include <linux/smp_lock.h>
> 
> #include <linux/ncp_fs.h>
> 
>@@ -339,9 +338,10 @@ static int
> ncp_lookup_validate(struct dentry * dentry, struct nameidata *nd)
> {
> 	int res;
>-	lock_kernel();
>+	struct super_block *sb = dentry->d_inode->i_sb;
>+	lock_super(sb);
> 	res = __ncp_lookup_validate(dentry);
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return res;
> }
> 
>@@ -404,6 +404,7 @@ static int ncp_readdir(struct file *filp, void *dirent, filldir_t filldir)
> {
> 	struct dentry *dentry = filp->f_path.dentry;
> 	struct inode *inode = dentry->d_inode;
>+	struct super_block *sb = inode->i_sb;
> 	struct page *page = NULL;
> 	struct ncp_server *server = NCP_SERVER(inode);
> 	union  ncp_dir_cache *cache = NULL;
>@@ -411,7 +412,7 @@ static int ncp_readdir(struct file *filp, void *dirent, filldir_t filldir)
> 	int result, mtime_valid = 0;
> 	time_t mtime = 0;
> 
>-	lock_kernel();
>+	lock_super(sb);
> 
> 	ctl.page  = NULL;
> 	ctl.cache = NULL;
>@@ -546,7 +547,7 @@ finished:
> 		page_cache_release(ctl.page);
> 	}
> out:
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return result;
> }
> 
>@@ -794,12 +795,13 @@ out:
> static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
> {
> 	struct ncp_server *server = NCP_SERVER(dir);
>+	struct super_block *sb = dir->i_sb;
> 	struct inode *inode = NULL;
> 	struct ncp_entry_info finfo;
> 	int error, res, len;
> 	__u8 __name[NCP_MAXPATHLEN + 1];
> 
>-	lock_kernel();
>+	lock_super(sb);
> 	error = -EIO;
> 	if (!ncp_conn_valid(server))
> 		goto finished;
>@@ -846,7 +848,7 @@ add_entry:
> 
> finished:
> 	PPRINTK("ncp_lookup: result=%d\n", error);
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return ERR_PTR(error);
> }
> 
>@@ -880,6 +882,7 @@ int ncp_create_new(struct inode *dir, struct dentry *dentry, int mode,
> {
> 	struct ncp_server *server = NCP_SERVER(dir);
> 	struct ncp_entry_info finfo;
>+	struct super_block *sb = dir->i_sb;
> 	int error, result, len;
> 	int opmode;
> 	__u8 __name[NCP_MAXPATHLEN + 1];
>@@ -888,7 +891,7 @@ int ncp_create_new(struct inode *dir, struct dentry *dentry, int mode,
> 		dentry->d_parent->d_name.name, dentry->d_name.name, mode);
> 
> 	error = -EIO;
>-	lock_kernel();
>+	lock_super(sb);
> 	if (!ncp_conn_valid(server))
> 		goto out;
> 
>@@ -935,7 +938,7 @@ int ncp_create_new(struct inode *dir, struct dentry *dentry, int mode,
> 
> 	error = ncp_instantiate(dir, dentry, &finfo);
> out:
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return error;
> }
> 
>@@ -949,6 +952,7 @@ static int ncp_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> {
> 	struct ncp_entry_info finfo;
> 	struct ncp_server *server = NCP_SERVER(dir);
>+	struct super_block *sb = dir->i_sb;
> 	int error, len;
> 	__u8 __name[NCP_MAXPATHLEN + 1];
> 
>@@ -956,7 +960,7 @@ static int ncp_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> 		dentry->d_parent->d_name.name, dentry->d_name.name);
> 
> 	error = -EIO;
>-	lock_kernel();
>+	lock_super(sb);
> 	if (!ncp_conn_valid(server))
> 		goto out;
> 
>@@ -985,13 +989,14 @@ static int ncp_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> 		error = ncp_instantiate(dir, dentry, &finfo);
> 	}
> out:
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return error;
> }
> 
> static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
> {
> 	struct ncp_server *server = NCP_SERVER(dir);
>+	struct super_block *sb = dir->i_sb;
> 	int error, result, len;
> 	__u8 __name[NCP_MAXPATHLEN + 1];
> 
>@@ -999,7 +1004,7 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
> 		dentry->d_parent->d_name.name, dentry->d_name.name);
> 
> 	error = -EIO;
>-	lock_kernel();
>+	lock_super(sb);
> 	if (!ncp_conn_valid(server))
> 		goto out;
> 
>@@ -1040,17 +1045,18 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
> 			break;
>        	}
> out:
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return error;
> }
> 
> static int ncp_unlink(struct inode *dir, struct dentry *dentry)
> {
> 	struct inode *inode = dentry->d_inode;
>+	struct super_block *sb = dir->i_sb;
> 	struct ncp_server *server;
> 	int error;
> 
>-	lock_kernel();
>+	lock_super(sb);
> 	server = NCP_SERVER(dir);
> 	DPRINTK("ncp_unlink: unlinking %s/%s\n",
> 		dentry->d_parent->d_name.name, dentry->d_name.name);
>@@ -1102,7 +1108,7 @@ static int ncp_unlink(struct inode *dir, struct dentry *dentry)
> 	}
> 		
> out:
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return error;
> }
> 
>@@ -1110,6 +1116,7 @@ static int ncp_rename(struct inode *old_dir, struct dentry *old_dentry,
> 		      struct inode *new_dir, struct dentry *new_dentry)
> {
> 	struct ncp_server *server = NCP_SERVER(old_dir);
>+	struct super_block *sb = old_dir->i_sb;
> 	int error;
> 	int old_len, new_len;
> 	__u8 __old_name[NCP_MAXPATHLEN + 1], __new_name[NCP_MAXPATHLEN + 1];
>@@ -1119,7 +1126,7 @@ static int ncp_rename(struct inode *old_dir, struct dentry *old_dentry,
> 		new_dentry->d_parent->d_name.name, new_dentry->d_name.name);
> 
> 	error = -EIO;
>-	lock_kernel();
>+	lock_super(sb);
> 	if (!ncp_conn_valid(server))
> 		goto out;
> 
>@@ -1165,7 +1172,7 @@ static int ncp_rename(struct inode *old_dir, struct dentry *old_dentry,
> 			break;
> 	}
> out:
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return error;
> }
> 
>diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
>index 3639cc5..a871df0 100644
>--- a/fs/ncpfs/file.c
>+++ b/fs/ncpfs/file.c
>@@ -17,7 +17,6 @@
> #include <linux/mm.h>
> #include <linux/vmalloc.h>
> #include <linux/sched.h>
>-#include <linux/smp_lock.h>
> 
> #include <linux/ncp_fs.h>
> #include "ncplib_kernel.h"
>@@ -284,9 +283,11 @@ static int ncp_release(struct inode *inode, struct file *file) {
> static loff_t ncp_remote_llseek(struct file *file, loff_t offset, int origin)
> {
> 	loff_t ret;
>-	lock_kernel();
>+	struct super_block *sb = file->f_path.dentry->d_inode->i_sb;
>+
>+	lock_super(sb);
> 	ret = generic_file_llseek_unlocked(file, offset, origin);
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return ret;
> }
> 
>diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
>index cdf0fce..f37d297 100644
>--- a/fs/ncpfs/inode.c
>+++ b/fs/ncpfs/inode.c
>@@ -26,7 +26,6 @@
> #include <linux/slab.h>
> #include <linux/vmalloc.h>
> #include <linux/init.h>
>-#include <linux/smp_lock.h>
> #include <linux/vfs.h>
> #include <linux/mount.h>
> #include <linux/seq_file.h>
>@@ -445,12 +444,12 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
> #endif
> 	struct ncp_entry_info finfo;
> 
>-	lock_kernel();
>+	lock_super(sb);
> 
> 	data.wdog_pid = NULL;
> 	server = kzalloc(sizeof(struct ncp_server), GFP_KERNEL);
> 	if (!server) {
>-		unlock_kernel();
>+		unlock_super(sb);
> 		return -ENOMEM;
> 	}
> 	sb->s_fs_info = server;
>@@ -704,7 +703,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
>         if (!sb->s_root)
> 		goto out_no_root;
> 	sb->s_root->d_op = &ncp_root_dentry_operations;
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return 0;
> 
> out_no_root:
>@@ -741,7 +740,7 @@ out:
> 	put_pid(data.wdog_pid);
> 	sb->s_fs_info = NULL;
> 	kfree(server);
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return error;
> }
> 
>@@ -749,7 +748,7 @@ static void ncp_put_super(struct super_block *sb)
> {
> 	struct ncp_server *server = NCP_SBP(sb);
> 
>-	lock_kernel();
>+	lock_super(sb);
> 
> 	ncp_lock_server(server);
> 	ncp_disconnect(server);
>@@ -778,7 +777,7 @@ static void ncp_put_super(struct super_block *sb)
> 	sb->s_fs_info = NULL;
> 	kfree(server);
> 
>-	unlock_kernel();
>+	unlock_super(sb);
> }
> 
> static int ncp_statfs(struct dentry *dentry, struct kstatfs *buf)
>@@ -850,6 +849,7 @@ dflt:;
> int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
> {
> 	struct inode *inode = dentry->d_inode;
>+	struct super_block *sb = inode->i_sb;
> 	int result = 0;
> 	__le32 info_mask;
> 	struct nw_modify_dos_info info;
>@@ -857,7 +857,7 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
> 
> 	result = -EIO;
> 
>-	lock_kernel();	
>+	lock_super(sb);	
> 
> 	server = NCP_SERVER(inode);
> 	if ((!server) || !ncp_conn_valid(server))
>@@ -1011,7 +1011,7 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
> 	mark_inode_dirty(inode);
> 
> out:
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return result;
> }
> 
>diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
>index 84a8cfc..4ce88d4 100644
>--- a/fs/ncpfs/ioctl.c
>+++ b/fs/ncpfs/ioctl.c
>@@ -17,7 +17,6 @@
> #include <linux/mount.h>
> #include <linux/slab.h>
> #include <linux/highuid.h>
>-#include <linux/smp_lock.h>
> #include <linux/vmalloc.h>
> #include <linux/sched.h>
> 
>@@ -844,8 +843,9 @@ static int ncp_ioctl_need_write(unsigned int cmd)
> long ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> {
> 	long ret;
>+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> 
>-	lock_kernel();
>+	lock_super(sb);
> 	if (ncp_ioctl_need_write(cmd)) {
> 		/*
> 		 * inside the ioctl(), any failures which
>@@ -863,19 +863,20 @@ long ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> 		mnt_drop_write(filp->f_path.mnt);
> 
> out:
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return ret;
> }
> 
> #ifdef CONFIG_COMPAT
> long ncp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> {
>+	struct super_block *sb = file->f_path.dentry->d_inode->i_sb;
> 	long ret;
> 
>-	lock_kernel();
>+	lock_super(sb);
> 	arg = (unsigned long) compat_ptr(arg);
> 	ret = ncp_ioctl(file, cmd, arg);
>-	unlock_kernel();
>+	unlock_super(sb);
> 	return ret;
> }
> #endif

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

