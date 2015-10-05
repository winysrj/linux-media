Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41305 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbJEXLT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 19:11:19 -0400
Date: Tue, 6 Oct 2015 00:11:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 14/15] cec: s5p-cec: Add s5p-cec driver
Message-ID: <20151005231109.GN21513@n2100.arm.linux.org.uk>
References: <cover.1441633456.git.hansverk@cisco.com>
 <b55a5c1ff9318211aa472b28d03a978aad23770b.1441633456.git.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b55a5c1ff9318211aa472b28d03a978aad23770b.1441633456.git.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 07, 2015 at 03:44:43PM +0200, Hans Verkuil wrote:
> +	cec->adap = cec_create_adapter(&s5p_cec_adap_ops, cec,
> +		CEC_NAME, CEC_CAP_STATE |
> +		CEC_CAP_PHYS_ADDR | CEC_CAP_LOG_ADDRS | CEC_CAP_IO |
> +		CEC_CAP_IS_SOURCE,
> +		0, THIS_MODULE, &pdev->dev);
> +	ret = PTR_ERR_OR_ZERO(cec->adap);
> +	if (ret)
> +		return ret;
> +	cec->adap->available_log_addrs = 1;
> +
> +	platform_set_drvdata(pdev, cec);
> +	pm_runtime_enable(dev);

This is really not a good interface.

"cec_create_adapter" creates and registers the adapter, at which point it
becomes available to userspace.  However, you haven't finished setting it
up, so it's possible to nip in here and start using it before the setup
has completed.  This needs fixing.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
