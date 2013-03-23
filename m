Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:59729 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3CWTBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 15:01:07 -0400
Message-ID: <514DFBEE.6040404@gmail.com>
Date: Sat, 23 Mar 2013 20:01:02 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC 10/12] exynos-fimc-is: Adds the hardware interface module
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com> <1362754765-2651-11-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1362754765-2651-11-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2013 03:59 PM, Arun Kumar K wrote:
> The hardware interface module finally sends the commands to the
> FIMC-IS firmware and runs the interrupt handler for getting the
> responses.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   .../media/platform/exynos5-is/fimc-is-interface.c  | 1003 ++++++++++++++++++++
>   .../media/platform/exynos5-is/fimc-is-interface.h  |  130 +++
>   2 files changed, 1133 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.c
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.h
[...]
> +static void itf_set_state(struct fimc_is_interface *itf,
> +		unsigned long state)
> +{
> +	unsigned long flags;
> +	spin_lock_irqsave(&itf->slock_state, flags);
> +	set_bit(state,&itf->state);

If itf->state is always modified with itf->slock_state spinlock
held you could use non-atomic variant, i.e. __set_bit().

> +	spin_unlock_irqrestore(&itf->slock_state, flags);
> +}
> +
> +static void itf_clr_state(struct fimc_is_interface *itf,
> +		unsigned long state)
> +{
> +	unsigned long flags;
> +	spin_lock_irqsave(&itf->slock_state, flags);
> +	clear_bit(state,&itf->state);
> +	spin_unlock_irqrestore(&itf->slock_state, flags);
> +}
> +
> +static int itf_get_state(struct fimc_is_interface *itf,
> +		unsigned long state)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&itf->slock_state, flags);
> +	ret = test_bit(state,&itf->state);
> +	spin_unlock_irqrestore(&itf->slock_state, flags);
> +	return ret;
> +}

> +int fimc_is_itf_hw_dump(struct fimc_is_interface *itf)
> +{
> +	struct fimc_is *is = fimc_interface_to_is(itf);
> +	int debug_cnt;
> +	char *debug;
> +	char letter;
> +	int count = 0, i;
> +
> +	debug = (char *)(is->minfo.fw_vaddr + DEBUG_OFFSET);
> +	debug_cnt = *((int *)(is->minfo.fw_vaddr + DEBUGCTL_OFFSET))
> +			- DEBUG_OFFSET;
> +
> +	if (itf->debug_cnt>  debug_cnt)
> +		count = (DEBUG_CNT - itf->debug_cnt) + debug_cnt;
> +	else
> +		count = debug_cnt - itf->debug_cnt;
> +
> +	if (count) {
> +		pr_info("start(%d %d)\n", debug_cnt, count);
> +		for (i = itf->debug_cnt; count>  0; count--) {
> +			letter = debug[i];
> +			if (letter)
> +				pr_cont("%c", letter);
> +			i++;
> +			if (i>  DEBUG_CNT)
> +				i = 0;
> +		}
> +		itf->debug_cnt = debug_cnt;
> +		pr_info("end\n");
> +	}
> +	return count;
> +}

Why don't you use debugfs for dumping this log buffer ? I found it much
more convenient and the logs appear exactly as written by the firmware.

This is what I have in the Exynos4x12 FIMC-IS driver:


static int fimc_is_log_show(struct seq_file *s, void *data)
{
	struct fimc_is *is = s->private;
	const u8 *buf = is->memory.vaddr + FIMC_IS_DEBUG_REGION_OFFSET;

	if (is->memory.vaddr == NULL) {
		dev_err(&is->pdev->dev, "Firmware memory is not initialized\n");
		return -EIO;
	}

	seq_printf(s, "%s\n", buf);
	return 0;
}

static int fimc_is_debugfs_open(struct inode *inode, struct file *file)
{
	return single_open(file, fimc_is_log_show, inode->i_private);
}

static const struct file_operations fimc_is_debugfs_fops = {
	.open		= fimc_is_debugfs_open,
	.read		= seq_read,
	.llseek		= seq_lseek,
	.release	= single_release,
};

static void fimc_is_debugfs_remove(struct fimc_is *is)
{
	debugfs_remove(is->debugfs_entry);
	is->debugfs_entry = NULL;
}

static int fimc_is_debugfs_create(struct fimc_is *is)
{
	struct dentry *dentry;

	is->debugfs_entry = debugfs_create_dir("fimc_is", NULL);

	dentry = debugfs_create_file("fw_log", S_IRUGO, is->debugfs_entry,
				     is, &fimc_is_debugfs_fops);
	if (!dentry)
		fimc_is_debugfs_remove(is);

	return is->debugfs_entry == NULL ? -EIO : 0;
}
