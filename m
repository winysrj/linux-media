Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36402 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbbJLK4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 06:56:16 -0400
Message-ID: <561B915C.20005@xs4all.nl>
Date: Mon, 12 Oct 2015 12:54:20 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Hans Verkuil <hansverk@cisco.com>
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 14/15] cec: s5p-cec: Add s5p-cec driver
References: <cover.1441633456.git.hansverk@cisco.com> <b55a5c1ff9318211aa472b28d03a978aad23770b.1441633456.git.hansverk@cisco.com> <20151005231109.GN21513@n2100.arm.linux.org.uk>
In-Reply-To: <20151005231109.GN21513@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/2015 01:11 AM, Russell King - ARM Linux wrote:
> On Mon, Sep 07, 2015 at 03:44:43PM +0200, Hans Verkuil wrote:
>> +	cec->adap = cec_create_adapter(&s5p_cec_adap_ops, cec,
>> +		CEC_NAME, CEC_CAP_STATE |
>> +		CEC_CAP_PHYS_ADDR | CEC_CAP_LOG_ADDRS | CEC_CAP_IO |
>> +		CEC_CAP_IS_SOURCE,
>> +		0, THIS_MODULE, &pdev->dev);
>> +	ret = PTR_ERR_OR_ZERO(cec->adap);
>> +	if (ret)
>> +		return ret;
>> +	cec->adap->available_log_addrs = 1;
>> +
>> +	platform_set_drvdata(pdev, cec);
>> +	pm_runtime_enable(dev);
> 
> This is really not a good interface.
> 
> "cec_create_adapter" creates and registers the adapter, at which point it
> becomes available to userspace.  However, you haven't finished setting it
> up, so it's possible to nip in here and start using it before the setup
> has completed.  This needs fixing.
> 

Good point, I'll split off the registration part into a separate function.

Regards,

	Hans
