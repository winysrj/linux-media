Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:39052 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdE1IXj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 04:23:39 -0400
Date: Sun, 28 May 2017 10:23:37 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 03/16] lirc_dev: correct error handling
Message-ID: <20170528082337.2hk4zwfi47xzjqea@hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
 <149365463117.12922.15518669536847504845.stgit@zeus.hardeman.nu>
 <20170521085712.GA29355@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170521085712.GA29355@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 21, 2017 at 09:57:13AM +0100, Sean Young wrote:
>On Mon, May 01, 2017 at 06:03:51PM +0200, David H�rdeman wrote:
>> If an error is generated, nonseekable_open() shouldn't be called.
>
>There is no harm in calling nonseekable_open(), so this commit is
>misleading.

I'm not sure why you consider it misleading? If there's an error, the
logic thing to do is to error out immediately and not do any further
work?

>> Signed-off-by: David H�rdeman <david@hardeman.nu>
>> ---
>>  drivers/media/rc/lirc_dev.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
>> index 05f600bd6c67..7f13ed479e1c 100644
>> --- a/drivers/media/rc/lirc_dev.c
>> +++ b/drivers/media/rc/lirc_dev.c
>> @@ -431,7 +431,7 @@ EXPORT_SYMBOL(lirc_unregister_driver);
>>  int lirc_dev_fop_open(struct inode *inode, struct file *file)
>>  {
>>  	struct irctl *ir;
>> -	int retval = 0;
>> +	int retval;
>>  
>>  	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
>>  		pr_err("open result for %d is -ENODEV\n", iminor(inode));
>> @@ -475,9 +475,11 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
>>  
>>  	ir->open++;
>>  
>> -error:
>>  	nonseekable_open(inode, file);
>>  
>> +	return 0;
>> +
>> +error:
>>  	return retval;
>>  }
>>  EXPORT_SYMBOL(lirc_dev_fop_open);

-- 
David H�rdeman
