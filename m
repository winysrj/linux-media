Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE40CC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B06920656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfAOImm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:42:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:32575 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfAOImm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 03:42:42 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2019 00:42:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,481,1539673200"; 
   d="scan'208";a="134701471"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jan 2019 00:42:40 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 3C7462050A; Tue, 15 Jan 2019 10:42:39 +0200 (EET)
Date:   Tue, 15 Jan 2019 10:42:39 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Ben Kao <ben.kao@intel.com>
Cc:     linux-media@vger.kernel.org, andy.yeh@intel.com, tfiga@chromium.org
Subject: Re: [PATCH v3] media: ov8856: Add support for OV8856 sensor
Message-ID: <20190115084238.zjcx6a2ketc5bzvc@paasikivi.fi.intel.com>
References: <1547541029-29492-1-git-send-email-ben.kao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547541029-29492-1-git-send-email-ben.kao@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ben,

Thanks for the update! I've applied the patch, but please see the comments
below.

On Tue, Jan 15, 2019 at 04:30:29PM +0800, Ben Kao wrote:
...
> +static int ov8856_read_reg(struct ov8856 *ov8856, u16 reg, u16 len, u32 *val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
> +	struct i2c_msg msgs[2];
> +	u8 addr_buf[2] = {reg >> 8, reg & 0xff};

You could use put_unaligned_be16() for doing this, as you do below.

> +	u8 data_buf[4] = {0, };
> +	int ret;
> +
> +	if (len > 4)
> +		return -EINVAL;
> +
> +	msgs[0].addr = client->addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = ARRAY_SIZE(addr_buf);

sizeof() would be better suited for the purpose: the length is in bytes.

Could you send a follow-up patch on top of this one?

> +	msgs[0].buf = addr_buf;
> +	msgs[1].addr = client->addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = len;
> +	msgs[1].buf = &data_buf[4 - len];
> +
> +	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> +	if (ret != ARRAY_SIZE(msgs))
> +		return -EIO;
> +
> +	*val = get_unaligned_be32(data_buf);
> +
> +	return 0;
> +}

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
