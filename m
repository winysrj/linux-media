Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35750 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932146AbdDDQfK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 12:35:10 -0400
Date: Tue, 4 Apr 2017 17:34:55 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        benjamin.gaignard@st.com, patrice.chotard@st.com,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] cec: Handle RC capability more elegantly
Message-ID: <20170404163455.GD7909@n2100.armlinux.org.uk>
References: <20170404161005.20884-1-lee.jones@linaro.org>
 <20170404161005.20884-2-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170404161005.20884-2-lee.jones@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 04, 2017 at 05:10:05PM +0100, Lee Jones wrote:
> @@ -237,7 +241,6 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
>  	if (!(caps & CEC_CAP_RC))
>  		return adap;
>  
> -#if IS_REACHABLE(CONFIG_RC_CORE)
>  	/* Prepare the RC input device */
>  	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
>  	if (!adap->rc) {

The above, coupled with patch 1:

+#ifdef CONFIG_RC_CORE
 struct rc_dev *rc_allocate_device(enum rc_driver_type);
+#else
+static inline struct rc_dev *rc_allocate_device(int unused)
+{
+       return ERR_PTR(-EOPNOTSUPP);
+}
+#endif

is really not nice.  You claim that this is how stuff is done elsewhere
in the kernel, but no, it isn't.  Look at debugfs.

You're right that debugfs returns an error pointer when it's not
configured.  However, the debugfs dentry is only ever passed back into
the debugfs APIs, it is never dereferenced by the caller.

That is not the case here.  The effect if your change is that the
following dereferences will oops the kernel.  This is unacceptable for
a feature that is deconfigured.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
