Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50633 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2FZUi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 16:38:57 -0400
Received: by pbbrp8 with SMTP id rp8so562268pbb.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 13:38:57 -0700 (PDT)
Date: Tue, 26 Jun 2012 13:38:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 1/4] kmod: add a routine to return if usermode is
 disabled
Message-ID: <20120626203852.GA3885@kroah.com>
References: <4FE9169D.5020300@redhat.com>
 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
 <1340739262-13747-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340739262-13747-2-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2012 at 04:34:19PM -0300, Mauro Carvalho Chehab wrote:
> Several media devices are only capable of probing the device if
> the firmware load is enabled, e. g. when the usermode var is not
> disabled.
> 
> Add a routine to allow those drivers to test if probe can continue
> or need to be deferred.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  include/linux/firmware.h |    6 ++++++
>  kernel/kmod.c            |    6 ++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index 1e7c011..cacf27e 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -35,6 +35,12 @@ struct builtin_fw {
>  	static const struct builtin_fw __fw_concat(__builtin_fw,__COUNTER__) \
>  	__used __section(.builtin_fw) = { name, blob, size }
>  
> +/**
> + * is_usermodehelp_disabled - returns true if firmware usermode is disabled
> + *			      false otherwise.
> + */
> +bool is_usermodehelp_disabled(void);
> +
>  #if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
>  int request_firmware(const struct firmware **fw, const char *name,
>  		     struct device *device);
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 05698a7..68901308 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -339,6 +339,12 @@ static DECLARE_WAIT_QUEUE_HEAD(running_helpers_waitq);
>   */
>  static DECLARE_WAIT_QUEUE_HEAD(usermodehelper_disabled_waitq);
>  
> +bool is_usermodehelp_disabled(void)
> +{
> +	return usermodehelper_disabled ? true : false;
> +}
> +EXPORT_SYMBOL_GPL(is_usermodehelp_disabled);

usermodehelper_disabled is an enum, and the 0 value is UMH_ENABLED, so I
think you need to explicitly test for the correct value here, you don't
want to return something incorrectly for UMH_FREEZING, right?

greg k-h
