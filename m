Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:59793 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934275AbeAIQyo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 11:54:44 -0500
Date: Tue, 9 Jan 2018 18:54:40 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v4 2/5] media: ov5695: add support for OV5695 sensor
Message-ID: <20180109165440.droexlfysvtyt6kl@tarshish>
References: <1515509304-15941-1-git-send-email-zhengsq@rock-chips.com>
 <1515509304-15941-3-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515509304-15941-3-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shunqian Zheng,

On Tue, Jan 09, 2018 at 10:48:21PM +0800, Shunqian Zheng wrote:
> +static int ov5695_write_array(struct i2c_client *client,
> +			      const struct regval *regs)
> +{
> +	u32 i;
> +	int ret = 0;
> +
> +	for (i = 0; ret == 0 && regs[i].addr != REG_NULL; i++)
> +		ret = ov5695_write_reg(client, regs[i].addr,
> +				       OV5695_REG_VALUE_08BIT, regs[i].val);

This loop should stop on first failure, and return the error value. With 
current code a register write failure is masked by following writes.

> +
> +	return ret;
> +}

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
