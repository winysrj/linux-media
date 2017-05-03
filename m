Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbdECNqM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 May 2017 09:46:12 -0400
Date: Wed, 3 May 2017 07:46:08 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 05/10] media: venus: adding core part and helper
 functions
Message-ID: <20170503134607.GA18391@jcrouse-lnx.qualcomm.com>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <1493370837-19793-6-git-send-email-stanimir.varbanov@linaro.org>
 <20170428220245.GA3283@jcrouse-lnx.qualcomm.com>
 <20170429202247.GV15143@minitux>
 <5840407a-8812-65a9-5716-f3a64427649b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5840407a-8812-65a9-5716-f3a64427649b@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 02, 2017 at 12:17:20PM +0300, Stanimir Varbanov wrote:
> Hi,
> 
> On 04/29/2017 11:22 PM, Bjorn Andersson wrote:
> > On Fri 28 Apr 15:02 PDT 2017, Jordan Crouse wrote:
> > 
> >> On Fri, Apr 28, 2017 at 12:13:52PM +0300, Stanimir Varbanov wrote:
> >>> +int venus_boot(struct device *parent, struct device *fw_dev)
> >>> +{
> >>> +	const struct firmware *mdt;
> >>> +	phys_addr_t mem_phys;
> >>> +	ssize_t fw_size;
> >>> +	size_t mem_size;
> >>> +	void *mem_va;
> >>> +	int ret;
> >>> +
> >>> +	if (!qcom_scm_is_available())
> >>> +		return -EPROBE_DEFER;
> >>> +
> >>> +	fw_dev->parent = parent;
> >>> +	fw_dev->release = device_release_dummy;
> >>> +
> >>> +	ret = dev_set_name(fw_dev, "%s:%s", dev_name(parent), "firmware");
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >>> +	ret = device_register(fw_dev);
> >>> +	if (ret < 0)
> >>> +		return ret;
> >>> +
> >>> +	ret = of_reserved_mem_device_init_by_idx(fw_dev, parent->of_node, 0);
> >>> +	if (ret)
> >>> +		goto err_unreg_device;
> >>> +
> >>> +	mem_size = VENUS_FW_MEM_SIZE;
> >>> +
> >>> +	mem_va = dmam_alloc_coherent(fw_dev, mem_size, &mem_phys, GFP_KERNEL);
> >>> +	if (!mem_va) {
> >>> +		ret = -ENOMEM;
> >>> +		goto err_unreg_device;
> >>> +	}
> >>> +
> >>> +	ret = request_firmware(&mdt, VENUS_FIRMWARE_NAME, fw_dev);
> >>> +	if (ret < 0)
> >>> +		goto err_unreg_device;
> >>> +
> >>> +	fw_size = qcom_mdt_get_size(mdt);
> >>> +	if (fw_size < 0) {
> >>> +		ret = fw_size;
> >>> +		release_firmware(mdt);
> >>> +		goto err_unreg_device;
> >>> +	}
> >>> +
> >>> +	ret = qcom_mdt_load(fw_dev, mdt, VENUS_FIRMWARE_NAME, VENUS_PAS_ID,
> >>> +			    mem_va, mem_phys, mem_size);
> >>> +
> >>> +	release_firmware(mdt);
> >>> +
> >>> +	if (ret)
> >>> +		goto err_unreg_device;
> >>> +
> >>> +	ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> >>> +	if (ret)
> >>> +		goto err_unreg_device;
> >>> +
> >>> +	return 0;
> >>> +
> >>> +err_unreg_device:
> >>> +	device_unregister(fw_dev);
> >>> +	return ret;
> >>> +}
> >>
> >> Hey, this looks familiar - almost line for line identical to what we'll need to
> >> do for GPU.
> >>
> >> Bjorn - Is this enough to qualify for generic status in the mdt_loader code?
> >> I know its just two consumers, but it would save 50 or 60 lines of code between
> >> the two drivers and be easier to maintain.
> >>
> > 
> > I think the code setting up the struct device for memory allocation
> > should be done during probe of the parent, so that I don't think should
> > be shared.
> > 
> > The part that allocates memory from a device, loads the mdt into that
> > memory and calls auth_and_reset() sounds like a useful thing to move to
> > the mdt_loader.c
> 
> I agree, who is going to do that?

I'll volunteer with the caveat that sometimes I'm not as fast on turning around
code as I would like to be given then organization I'm affiliated with. 

That said I do have a stack with my zap shader code pending so it would make
sense to stick it in there.

If the worst happens we can alway merge separately and then consolidate.

Jordan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
