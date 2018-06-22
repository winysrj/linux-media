Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:38200 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934267AbeFVDI7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 23:08:59 -0400
Subject: Re: [PATCH v5 2/2] media: ak7375: Add ak7375 lens voice coil driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>, bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        tfiga@google.com, jacopo@jmondi.org, rajmohan.mani@intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com
References: <1529388107-14308-1-git-send-email-bingbu.cao@intel.com>
 <1529388107-14308-2-git-send-email-bingbu.cao@intel.com>
 <20180621112516.mwlph7u6et65gbh6@paasikivi.fi.intel.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <6e2fa794-b711-eb55-a72f-02e310ac5e96@linux.intel.com>
Date: Fri, 22 Jun 2018 11:11:54 +0800
MIME-Version: 1.0
In-Reply-To: <20180621112516.mwlph7u6et65gbh6@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2018年06月21日 19:25, Sakari Ailus wrote:
> On Tue, Jun 19, 2018 at 02:01:47PM +0800, bingbu.cao@intel.com wrote:
>> +static int ak7375_probe(struct i2c_client *client)
>> +{
>> +	struct ak7375_device *ak7375_dev;
>> +	int val;
>> +
>> +	ak7375_dev = devm_kzalloc(&client->dev, sizeof(*ak7375_dev),
>> +				  GFP_KERNEL);
>> +	if (!ak7375_dev)
>> +		return -ENOMEM;
>> +
>> +	v4l2_i2c_subdev_init(&ak7375_dev->sd, client, &ak7375_ops);
>> +	ak7375_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	ak7375_dev->sd.internal_ops = &ak7375_int_ops;
>> +	ak7375_dev->sd.entity.function = MEDIA_ENT_F_LENS;
>> +
>> +	val = ak7375_init_controls(ak7375_dev);
>> +	if (val)
>> +		goto err_cleanup;
>> +
>> +	val = media_entity_pads_init(&ak7375_dev->sd.entity, 0, NULL);
>> +	if (val < 0)
>> +		goto err_cleanup;
>> +
>> +	val = v4l2_async_register_subdev(&ak7375_dev->sd);
>> +	if (val < 0)
>> +		goto err_cleanup;
>> +
>> +	pm_runtime_set_active(&client->dev);
>> +	pm_runtime_enable(&client->dev);
>> +	pm_runtime_idle(&client->dev);
>> +
>> +	return 0;
>> +
>> +err_cleanup:
>> +	v4l2_ctrl_handler_free(&ak7375_dev->ctrls_vcm);
>> +	media_entity_cleanup(&ak7375_dev->sd.entity);
>> +	dev_err(&client->dev, "Probe failed: %d\n", val);
> This line is redundant, too: the kernel already prints the error value.
Ack.
Sakari, please help apply patch with this change, thanks!
>> +
>> +	return val;
>> +}
