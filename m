Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:33857 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423929AbdD2UWv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 16:22:51 -0400
Received: by mail-pg0-f44.google.com with SMTP id v1so29759364pgv.1
        for <linux-media@vger.kernel.org>; Sat, 29 Apr 2017 13:22:51 -0700 (PDT)
Date: Sat, 29 Apr 2017 13:22:47 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 05/10] media: venus: adding core part and helper
 functions
Message-ID: <20170429202247.GV15143@minitux>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <1493370837-19793-6-git-send-email-stanimir.varbanov@linaro.org>
 <20170428220245.GA3283@jcrouse-lnx.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170428220245.GA3283@jcrouse-lnx.qualcomm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 28 Apr 15:02 PDT 2017, Jordan Crouse wrote:

> On Fri, Apr 28, 2017 at 12:13:52PM +0300, Stanimir Varbanov wrote:
> > +int venus_boot(struct device *parent, struct device *fw_dev)
> > +{
> > +	const struct firmware *mdt;
> > +	phys_addr_t mem_phys;
> > +	ssize_t fw_size;
> > +	size_t mem_size;
> > +	void *mem_va;
> > +	int ret;
> > +
> > +	if (!qcom_scm_is_available())
> > +		return -EPROBE_DEFER;
> > +
> > +	fw_dev->parent = parent;
> > +	fw_dev->release = device_release_dummy;
> > +
> > +	ret = dev_set_name(fw_dev, "%s:%s", dev_name(parent), "firmware");
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = device_register(fw_dev);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = of_reserved_mem_device_init_by_idx(fw_dev, parent->of_node, 0);
> > +	if (ret)
> > +		goto err_unreg_device;
> > +
> > +	mem_size = VENUS_FW_MEM_SIZE;
> > +
> > +	mem_va = dmam_alloc_coherent(fw_dev, mem_size, &mem_phys, GFP_KERNEL);
> > +	if (!mem_va) {
> > +		ret = -ENOMEM;
> > +		goto err_unreg_device;
> > +	}
> > +
> > +	ret = request_firmware(&mdt, VENUS_FIRMWARE_NAME, fw_dev);
> > +	if (ret < 0)
> > +		goto err_unreg_device;
> > +
> > +	fw_size = qcom_mdt_get_size(mdt);
> > +	if (fw_size < 0) {
> > +		ret = fw_size;
> > +		release_firmware(mdt);
> > +		goto err_unreg_device;
> > +	}
> > +
> > +	ret = qcom_mdt_load(fw_dev, mdt, VENUS_FIRMWARE_NAME, VENUS_PAS_ID,
> > +			    mem_va, mem_phys, mem_size);
> > +
> > +	release_firmware(mdt);
> > +
> > +	if (ret)
> > +		goto err_unreg_device;
> > +
> > +	ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> > +	if (ret)
> > +		goto err_unreg_device;
> > +
> > +	return 0;
> > +
> > +err_unreg_device:
> > +	device_unregister(fw_dev);
> > +	return ret;
> > +}
> 
> Hey, this looks familiar - almost line for line identical to what we'll need to
> do for GPU.
> 
> Bjorn - Is this enough to qualify for generic status in the mdt_loader code?
> I know its just two consumers, but it would save 50 or 60 lines of code between
> the two drivers and be easier to maintain.
> 

I think the code setting up the struct device for memory allocation
should be done during probe of the parent, so that I don't think should
be shared.

The part that allocates memory from a device, loads the mdt into that
memory and calls auth_and_reset() sounds like a useful thing to move to
the mdt_loader.c

Regards,
Bjorn
