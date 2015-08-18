Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:38891 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbbHRKAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 06:00:36 -0400
Date: Tue, 18 Aug 2015 11:00:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCHv8 07/15] cec: add HDMI CEC framework
Message-ID: <20150818100020.GM7557@n2100.arm.linux.org.uk>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
 <87a579ddacf90718a166fbb8a777b5d8cd05200b.1439886203.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a579ddacf90718a166fbb8a777b5d8cd05200b.1439886203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 18, 2015 at 10:26:32AM +0200, Hans Verkuil wrote:
> +	/* Part 2: Initialize and register the character device */
> +	cdev_init(&cecdev->cdev, &cec_devnode_fops);
> +	cecdev->cdev.owner = owner;
> +
> +	ret = cdev_add(&cecdev->cdev, MKDEV(MAJOR(cec_dev_t), cecdev->minor),
> +									1);
> +	if (ret < 0) {
> +		pr_err("%s: cdev_add failed\n", __func__);
> +		goto error;
> +	}
> +
> +	/* Part 3: Register the cec device */
> +	cecdev->dev.bus = &cec_bus_type;
> +	cecdev->dev.devt = MKDEV(MAJOR(cec_dev_t), cecdev->minor);
> +	cecdev->dev.release = cec_devnode_release;
> +	if (cecdev->parent)
> +		cecdev->dev.parent = cecdev->parent;
> +	dev_set_name(&cecdev->dev, "cec%d", cecdev->minor);
> +	ret = device_register(&cecdev->dev);

It's worth pointing out that you can greatly simplify the lifetime
handling (you don't need to get and put cecdev->dev) if you make
the cdev a child of the cecdev->dev.

If you grep for kobj.parent in drivers/ you'll see many drivers are
doing this.

	cecdev->cdev.kobj.parent = &cecdev->dev.kobj;

but you will need to call device_initialize() on cecdev->dev first,
and use device_add() here.

> +	if (ret < 0) {
> +		pr_err("%s: device_register failed\n", __func__);
> +		goto error;
> +	}
> +
> +	/* Part 4: Activate this minor. The char device can now be used. */
> +	set_bit(CEC_FLAG_REGISTERED, &cecdev->flags);

Having flags to indicate whether userspace can open something is racy.
I don't see any other uses of cecdev->flags.  I think you should kill
this, and replace it with a cecdev->dead flag which indicates when the
cecdev is going away, and causes any pre-existing users to fail.


> +
> +	return 0;
> +
> +error:
> +	cdev_del(&cecdev->cdev);
> +	clear_bit(cecdev->minor, cec_devnode_nums);
> +	return ret;
> +}
> +
> +/**
> + * cec_devnode_unregister - unregister a cec device node
> + * @cecdev: the device node to unregister
> + *
> + * This unregisters the passed device. Future open calls will be met with
> + * errors.
> + *
> + * This function can safely be called if the device node has never been
> + * registered or has already been unregistered.
> + */
> +static void cec_devnode_unregister(struct cec_devnode *cecdev)
> +{
> +	/* Check if cecdev was ever registered at all */
> +	if (!cec_devnode_is_registered(cecdev))
> +		return;

Just make it a programming error if someone unregisters something that
they haven't registered... that's pretty standard kernel programming.

> +
> +	mutex_lock(&cec_devnode_lock);
> +	clear_bit(CEC_FLAG_REGISTERED, &cecdev->flags);

This should wake up the poll waitqueue so that users get to hear about
the device going away in a timely manner.

> +	mutex_unlock(&cec_devnode_lock);
> +	device_unregister(&cecdev->dev);
> +}
> +
> +int cec_create_adapter(struct cec_adapter *adap, const char *name, u32 caps,
> +		       u8 ninputs, struct module *owner, struct device *parent)
> +{
> +	int res = 0;
> +
> +	adap->owner = owner;
> +	if (WARN_ON(!owner))
> +		return -ENXIO;
> +	adap->devnode.parent = parent;
> +	if (WARN_ON(!parent))
> +		return -ENXIO;
> +	adap->name = name;
> +	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
> +	adap->capabilities = caps;
> +	adap->ninputs = ninputs;
> +	adap->is_source = caps & CEC_CAP_IS_SOURCE;
> +	if (WARN_ON(!adap->ninputs && !adap->is_source))
> +		return -ENXIO;
> +	adap->cec_version = CEC_OP_CEC_VERSION_2_0;
> +	adap->vendor_id = CEC_VENDOR_ID_NONE;
> +	adap->available_log_addrs = 1;
> +	adap->sequence = 0;
> +	memset(adap->phys_addrs, 0xff, sizeof(adap->phys_addrs));
> +	mutex_init(&adap->lock);
> +	INIT_LIST_HEAD(&adap->transmit_queue);
> +	INIT_LIST_HEAD(&adap->wait_queue);
> +	adap->kthread = kthread_run(cec_thread_func, adap, "cec-%s", name);
> +	init_waitqueue_head(&adap->kthread_waitq);
> +	if (IS_ERR(adap->kthread)) {
> +		pr_err("cec-%s: kernel_thread() failed\n", name);
> +		return PTR_ERR(adap->kthread);
> +	}
> +	if (caps) {
> +		res = cec_devnode_register(&adap->devnode, adap->owner);

Okay, so adap->devnode contains a struct device.  That struct device
controls the lifetime of adap->devnode, and because adap->devnode is
part of adap, this also defines the lifetime of adap as well.  adap
must _never_ be freed until cec_devnode_release() has been called.

Looking at patch 15, the adapter structure is part of the cobalt
streams.  This makes that structure also have a lifetime controlled
by this struct device.  There is no release method implemented in
there, and indeed cec_devnode_release() shows that the release node is
optional, which suggests a misunderstanding in this area.

Far too many nested data structures are involved here.  This needs fixing
- with the code in its present form, it contains serious data structure
lifetime issues, and therefore is not ready for merging, sorry.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
