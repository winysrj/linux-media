Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58788 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751229AbdHEIBn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 04:01:43 -0400
Subject: Re: [PATCH v3 10/23] media: camss: Add VFE files
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-11-git-send-email-todor.tomov@linaro.org>
 <20170720145949.grndikq744zq7ejg@valkosipuli.retiisi.org.uk>
 <cdcdda84-56d3-56cb-969c-a7dde7c6a12b@linaro.org>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <33862f4e-6608-32d9-1759-4bd371d5b1dc@iki.fi>
Date: Fri, 4 Aug 2017 21:02:54 +0300
MIME-Version: 1.0
In-Reply-To: <cdcdda84-56d3-56cb-969c-a7dde7c6a12b@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

Todor Tomov wrote:
> Hi Sakari,
> 
> Thank you for the review.
> 
> On 20.07.2017 17:59, Sakari Ailus wrote:
>> Hi Todor,
>>
>> On Mon, Jul 17, 2017 at 01:33:36PM +0300, Todor Tomov wrote:
>>> These files control the VFE module. The VFE has different input interfaces.
>>> The PIX input interface feeds the input data to an image processing pipeline.
>>> Three RDI input interfaces bypass the image processing pipeline. The VFE also
>>> contains the AXI bus interface which writes the output data to memory.
>>>
>>> RDI interfaces are supported in this version. PIX interface is not supported.
>>>
>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>> ---
>>>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 1913 ++++++++++++++++++++
>>>  drivers/media/platform/qcom/camss-8x16/camss-vfe.h |  114 ++
>>>  2 files changed, 2027 insertions(+)
>>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.h
>>>
>>> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>>> new file mode 100644
>>> index 0000000..b6dd29b
>>> --- /dev/null
>>> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>>> @@ -0,0 +1,1913 @@
> 
> <snip>
> 
>>> +
>>> +static void vfe_set_qos(struct vfe_device *vfe)
>>> +{
>>> +	u32 val = 0xaaa5aaa5;
>>> +	u32 val7 = 0x0001aaa5;
>>
>> Huh. What do these mean? :-)
> 
> For these here I don't have understanding of the values. I'll remove the magic
> values here and on all the other places but these here I'll just move to a #define.

If there is no documentation then I guess that's all that can be done.
Works for me.

> 
>>
>>> +
>>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_0);
>>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_1);
>>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_2);
>>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_3);
>>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_4);
>>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_5);
>>> +	writel_relaxed(val, vfe->base + VFE_0_BUS_BDG_QOS_CFG_6);
>>> +	writel_relaxed(val7, vfe->base + VFE_0_BUS_BDG_QOS_CFG_7);
>>> +}
>>> +
> 
> <snip>
> 
>>> +
>>> +/*
>>> + * msm_vfe_subdev_init - Initialize VFE device structure and resources
>>> + * @vfe: VFE device
>>> + * @res: VFE module resources table
>>> + *
>>> + * Return 0 on success or a negative error code otherwise
>>> + */
>>> +int msm_vfe_subdev_init(struct vfe_device *vfe, const struct resources *res)
>>> +{
>>> +	struct device *dev = to_device(vfe);
>>> +	struct platform_device *pdev = to_platform_device(dev);
>>> +	struct resource *r;
>>> +	struct camss *camss = to_camss(vfe);
>>> +
>>> +	int i;
>>> +	int ret;
>>> +
>>> +	mutex_init(&vfe->power_lock);
>>> +	vfe->power_count = 0;
>>> +
>>> +	mutex_init(&vfe->stream_lock);
>>> +	vfe->stream_count = 0;
>>> +
>>> +	spin_lock_init(&vfe->output_lock);
>>> +
>>> +	vfe->id = 0;
>>> +	vfe->reg_update = 0;
>>> +
>>> +	for (i = VFE_LINE_RDI0; i <= VFE_LINE_RDI2; i++) {
>>> +		vfe->line[i].video_out.type =
>>> +					V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>>> +		vfe->line[i].video_out.camss = camss;
>>> +		vfe->line[i].id = i;
>>> +	}
>>> +
>>> +	/* Memory */
>>> +
>>> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[0]);
>>> +	vfe->base = devm_ioremap_resource(dev, r);
>>> +	if (IS_ERR(vfe->base)) {
>>> +		dev_err(dev, "could not map memory\n");
>>
>> mutex_destroy() for bothof the mutexes. The same below.
>>
>> Do you have a corresponding cleanup function?
> 
> msm_vfe_subdev_init() and msm_vfe_register_entities() are called on probe().
> msm_vfe_unregister_entities() is called on remove() - this is the cleanup
> function. The mutexes are destroyed there. Is there something else that you
> are concerned about?

What about the error case above then? Where are the mutexes destroyed?

-- 
Sakari Ailus
sakari.ailus@iki.fi
