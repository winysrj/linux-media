Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42223 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbcFYM1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 08:27:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCHv16 04/13] cec: add HDMI CEC framework
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
 <1461937948-22936-5-git-send-email-hverkuil@xs4all.nl>
 <20160616130037.67ceccba@recife.lan>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>
Message-ID: <74b0e9a3-a171-b738-878a-9ae5a66dcb43@xs4all.nl>
Date: Sat, 25 Jun 2016 14:27:31 +0200
MIME-Version: 1.0
In-Reply-To: <20160616130037.67ceccba@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 06:00 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 29 Apr 2016 15:52:19 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hansverk@cisco.com>
>>
>> The added HDMI CEC framework provides a generic kernel interface for
>> HDMI CEC devices.
>>
>> Besides the cec module itself it also adds a cec-edid module that
>> contains helper functions to find and manipulate the CEC physical
>> address inside an EDID. Even if the CEC support itself is disabled,
>> drivers will still need these functions.
>>
>> Note that the CEC framework is added to staging/media and that the
>> cec.h and cec-funcs.h headers are not exported yet. While the kABI
>> is mature, I would prefer to allow the uABI some more time before
>> it is mainlined in case it needs more tweaks.
> 
> As pointed via IRC, it sounds like checkpatch were never used
> on this patch series. Just this one got more than 100 errors/warnings:
> 
> total: 6 errors, 107 warnings, 5895 lines checked
> 
> NOTE: For some of the reported defects, checkpatch may be able to
>       mechanically convert to the typical style using --fix or --fix-inplace.
> 
> Please fix, except if you have a good reason why not follow the
> CodingStyle.

When I saw this reply the first time I thought you gave up reviewing at
this point and I missed all the review comments below.

Apologies for that!

<snip>

>> +static unsigned cec_get_edid_spa_location(const u8 *edid, unsigned size)
>> +{
>> +	u8 d;
>> +
>> +	if (size < 256)
>> +		return 0;
>> +
>> +	if (edid[0x7e] != 1 || edid[0x80] != 0x02 || edid[0x81] != 0x03)
>> +		return 0;
> 
> Hmm... looking at E-EDID spec:
> 	http://read.pudn.com/downloads110/ebook/456020/E-EDID%20Standard.pdf
> 
> you're expecting that EDID will have just *one* extension? If so, please
> state so, adding a FIXME to warn about future needs to change the code
> to support bigger EDID data. Also, in such case, the EDID size should
> always be 256.

I've improved the code to accept more than one extension block. Note that
any device that puts the CEA-861 block in a different position is unlikely
to work. Most HDMI receivers only support one extension block.

> I would also check the checksum, to be sure that the vendor specific
> data block is not pointing to some invalid location.

This should not happen. I think it is safe to assume that the EDID is
correct when this function is called. Invalid EDIDs should be rejected
when they are read.

> 
>> +
>> +	/* search Vendor Specific Data Block (tag 3) */
>> +	d = edid[0x82] & 0x7f;
>> +	if (d > 4) {
>> +		int i = 0x84;
>> +		int end = 0x80 + d;
>> +
>> +		do {
>> +			u8 tag = edid[i] >> 5;
>> +			u8 len = edid[i] & 0x1f;
>> +
>> +			if (tag == 3 && len >= 5)
>> +				return i + 4;
>> +			i += len + 1;
>> +		} while (i < end);
>> +	}
> 
> It looked weird that check for size at the beginning, since the size
> is not being used in the routine itself. Ok, after looking at the
> code 3 or 4 times, I understood that you're implicitly using the
> size at the "end" variable, as you're doing a loop between
> 	'd', with ranges from 0 to 0x7f
> 	'end', with ranges from 0x85 to 0xff.
> 	'i', ranging from 0x84 to 0xfe.
> 	return value, ranging from 0x88 to 0x102 (i + 4)
> 
> As the code seems to rely on having just one extension, allowing to go
> past 0xff seems a mistake.
> 
> I guess the loop should be checking if it won't return a value
> past of the EDID array.

I've made the code more robust to safeguard against broken EDIDs (intentionally
or not).

> 
>> +	return 0;
>> +}
>> +
>> +u16 cec_get_edid_phys_addr(const u8 *edid, unsigned size, unsigned *offset)
>> +{
>> +	unsigned loc = cec_get_edid_spa_location(edid, size);
>> +
>> +	if (offset)
>> +		*offset = loc;
>> +	if (loc == 0)
>> +		return CEC_PHYS_ADDR_INVALID;
>> +	return (edid[loc] << 8) | edid[loc + 1];
> 
> Yeah, if I'm not mistaken, you may be reading past the EDID
> array here, if loc > 0xfe, and size = 256.

With the more robust location code this is now guaranteed to be safe.

> 
>> +}
>> +EXPORT_SYMBOL_GPL(cec_get_edid_phys_addr);
>> +
>> +void cec_set_edid_phys_addr(u8 *edid, unsigned size, u16 phys_addr)
>> +{
>> +	unsigned loc = cec_get_edid_spa_location(edid, size);
>> +	u8 sum = 0;
>> +	unsigned i;
>> +
>> +	if (loc == 0)
>> +		return;
>> +	edid[loc] = phys_addr >> 8;
>> +	edid[loc + 1] = phys_addr & 0xff;
>> +	loc &= ~0x7f;
>> +
>> +	/* update the checksum */
>> +	for (i = loc; i < loc + 127; i++)
>> +		sum += edid[i];
>> +	edid[i] = 256 - sum;
> 
> Here, you can also go past the EDID array, as you're not checking the
> size inside the for loop.

With the more robust location code this is now correct (if loc != 0, then
the size is guaranteed to be a multiple of 128).

> 
>> +}
>> +EXPORT_SYMBOL_GPL(cec_set_edid_phys_addr);
>> +
>> +u16 cec_phys_addr_for_input(u16 phys_addr, u8 input)
>> +{
>> +	/* Check if input is sane */
>> +	if (WARN_ON(input == 0 || input > 0xf))
>> +		return CEC_PHYS_ADDR_INVALID;
>> +
>> +	if (phys_addr == 0)
>> +		return input << 12;
>> +
>> +	if ((phys_addr & 0x0fff) == 0)
>> +		return phys_addr | (input << 8);
>> +
>> +	if ((phys_addr & 0x00ff) == 0)
>> +		return phys_addr | (input << 4);
>> +
>> +	if ((phys_addr & 0x000f) == 0)
>> +		return phys_addr | input;
>> +
>> +	/*
>> +	 * All nibbles are used so no valid physical addresses can be assigned
>> +	 * to the input.
>> +	 */
>> +	return CEC_PHYS_ADDR_INVALID;
>> +}
>> +EXPORT_SYMBOL_GPL(cec_phys_addr_for_input);
>> +
>> +int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
>> +{
>> +	int i;
>> +
>> +	if (parent)
>> +		*parent = phys_addr;
>> +	if (port)
>> +		*port = 0;
>> +	if (phys_addr == CEC_PHYS_ADDR_INVALID)
>> +		return 0;
>> +	for (i = 0; i < 16; i += 4)
>> +		if (phys_addr & (0xf << i))
>> +			break;
>> +	if (i == 16)
>> +		return 0;
>> +	if (parent)
>> +		*parent = phys_addr & (0xfff0 << i);
>> +	if (port)
>> +		*port = (phys_addr >> i) & 0xf;
>> +	for (i += 4; i < 16; i += 4)
>> +		if ((phys_addr & (0xf << i)) == 0)
>> +			return -EINVAL;
> 
> I guess you should be checking the size of the arrays here too.

Huh? phys_addr is a u16. No arrays here.

> 
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(cec_phys_addr_validate);
>> +
>> +MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
>> +MODULE_DESCRIPTION("CEC EDID helper functions");
>> +MODULE_LICENSE("GPL");

<snip>

>> +/* Initialize the event queues for the filehandle. */
>> +static int cec_queue_event_init(struct cec_fh *fh)
>> +{
>> +	/* This has the size of the event queue for each event type. */
>> +	static const unsigned queue_sizes[CEC_NUM_EVENTS] = {
>> +		2,	/* CEC_EVENT_STATE_CHANGE */
>> +		1,	/* CEC_EVENT_LOST_MSGS */
>> +	};
> 
> Why didn't you use, instead, a c99 designated initializer at the array?

This code has now been removed. See below for more information.

> 
>> +	unsigned i;
>> +
>> +	for (i = 0; i < CEC_NUM_EVENTS; i++) {
>> +		fh->evqueue[i].events = kcalloc(queue_sizes[i],
>> +				sizeof(struct cec_event), GFP_KERNEL);
>> +		if (fh->evqueue[i].events == NULL) {
>> +			while (i--) {
>> +				kfree(fh->evqueue[i].events);
>> +				fh->evqueue[i].events = NULL;
>> +				fh->evqueue[i].elems = 0;
>> +			}
>> +			return -ENOMEM;
>> +		}
>> +		fh->evqueue[i].elems = queue_sizes[i];
>> +	}
>> +	return 0;
>> +}
>> +
>> +static void cec_queue_event_free(struct cec_fh *fh)
>> +{
>> +	unsigned i;
>> +
>> +	for (i = 0; i < CEC_NUM_EVENTS; i++)
>> +		kfree(fh->evqueue[i].events);
>> +}
>> +
>> +/*
>> + * Queue a new event for this filehandle. If ts == 0, then set it
>> + * to the current time.
>> + */
>> +static void cec_queue_event_fh(struct cec_fh *fh,
>> +			       const struct cec_event *new_ev, u64 ts)
>> +{
>> +	struct cec_event_queue *evq = &fh->evqueue[new_ev->event - 1];
> 
> Shouldn't it be checking if event > 0 before instantiating event-1?

The event comes from the kernel code, not from userspace. In fact, it's just
this source that uses it. I don't see a need to check IMHO.

> 
>> +	struct cec_event *ev;
>> +
>> +	if (ts == 0)
>> +		ts = ktime_get_ns();
>> +
>> +	mutex_lock(&fh->lock);
>> +	ev = evq->events + evq->num_events;
>> +	/* Overwrite the last event if there is no more room for the new event */
>> +	if (evq->num_events == evq->elems) {
>> +		ev--;
> 
> Wouldn't be better to make it a circular buffer and override the
> oldest queued event? 
> 
> Also, the loss of an event should be signaled to the users, for them
> to know that a problem happened.

This comment caused me to take another look at the event code, and in the end
I've dropped the whole cec_event_queue. The framework has just two events and
intermediate events are of no interest to the application (at least, that's
the case for these two events. It might change in the future if new events
are added).

For the lost_msg event all you need to do if a lost_msg event is added when
there is already such an event pending is to add the lost_msg value from
the new event to the existing event. All userspace has to know is that
messages were lost. This should never happen since the message queue
stores for up to 10 seconds of messages, and in a production environment
messages should be replied to within 1 second. In fact, I decreased the
queue size to store 3 seconds of messages, since 10 seconds is pointlessly
large.

For the state_change event you just overwrite the old event. Intermediate
events are useless to the application since it can't do anything with a
state that doesn't exist anymore.

A flag to tell that an event was missed doesn't seem useful to me since no
useful information was lost.

Now, if we have events in the future where missing intermediate results is
actually important, then such a flag can be introduced.

We never needed such a flag for V4L2, and that uses events a lot more.

> 
>> +	} else {
>> +		evq->num_events++;
>> +		fh->events++;
>> +	}
>> +	*ev = *new_ev;
>> +	ev->ts = ts;
>> +	mutex_unlock(&fh->lock);
>> +	wake_up_interruptible(&fh->wait);
>> +}
>> +
>> +/* Queue a new event for all open filehandles. */
>> +static void cec_queue_event(struct cec_adapter *adap,
>> +			    const struct cec_event *ev)
>> +{
>> +	u64 ts = ktime_get_ns();
>> +	struct cec_fh *fh;
>> +
>> +	mutex_lock(&adap->devnode.fhs_lock);
>> +	list_for_each_entry(fh, &adap->devnode.fhs, list)
>> +		cec_queue_event_fh(fh, ev, ts);
>> +	mutex_unlock(&adap->devnode.fhs_lock);
>> +}
>> +
>> +/*
>> + * Queue a new message for this filehandle. If there is no more room
>> + * in the queue, then send the LOST_MSGS event instead.
>> + */
>> +static void cec_queue_msg_fh(struct cec_fh *fh, const struct cec_msg *msg)
>> +{
>> +	struct cec_event ev_lost_msg = {
>> +		.event = CEC_EVENT_LOST_MSGS,
>> +	};
>> +	struct cec_msg_entry *entry;
>> +
>> +	mutex_lock(&fh->lock);
>> +	if (fh->queued_msgs == CEC_MAX_MSG_QUEUE_SZ)
>> +		goto lost_msgs;
>> +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
>> +	if (entry == NULL)
>> +		goto lost_msgs;
>> +
>> +	entry->msg = *msg;
>> +	list_add(&entry->list, &fh->msgs);
>> +	fh->queued_msgs++;
>> +	mutex_unlock(&fh->lock);
>> +	wake_up_interruptible(&fh->wait);
>> +	return;
>> +
>> +lost_msgs:
>> +	ev_lost_msg.lost_msgs.lost_msgs = ++fh->lost_msgs;
>> +	mutex_unlock(&fh->lock);
>> +	cec_queue_event_fh(fh, &ev_lost_msg, 0);
>> +}
>> +
>> +/*
>> + * Queue the message for those filehandles that are in monitor mode.
>> + * If valid_la is true (this message is for us or was sent by us),
>> + * then pass it on to any monitoring filehandle. If this message
>> + * isn't for us or from us, then only give it to filehandles that
>> + * are in MONITOR_ALL mode.
>> + *
>> + * This can only happen if the CEC_CAP_MONITOR_ALL capability is
>> + * set and the CEC adapter was placed in 'monitor all' mode.
>> + */
>> +static void cec_queue_msg_monitor(struct cec_adapter *adap,
>> +				  const struct cec_msg *msg,
>> +				  bool valid_la)
>> +{
>> +	struct cec_fh *fh;
>> +	u32 monitor_mode = valid_la ? CEC_MODE_MONITOR :
>> +				      CEC_MODE_MONITOR_ALL;
>> +
>> +	mutex_lock(&adap->devnode.fhs_lock);
>> +	list_for_each_entry(fh, &adap->devnode.fhs, list) {
>> +		if (fh->mode_follower >= monitor_mode)
>> +			cec_queue_msg_fh(fh, msg);
>> +	}
>> +	mutex_unlock(&adap->devnode.fhs_lock);
>> +}
>> +
>> +/*
>> + * Queue the message for follower filehandles.
>> + */
>> +static void cec_queue_msg_followers(struct cec_adapter *adap,
>> +				    const struct cec_msg *msg)
>> +{
>> +	struct cec_fh *fh;
>> +
>> +	mutex_lock(&adap->devnode.fhs_lock);
>> +	list_for_each_entry(fh, &adap->devnode.fhs, list) {
>> +		if (fh->mode_follower == CEC_MODE_FOLLOWER)
>> +			cec_queue_msg_fh(fh, msg);
>> +	}
>> +	mutex_unlock(&adap->devnode.fhs_lock);
>> +}
>> +
>> +/* Notify userspace of an adapter state change. */
>> +static void cec_post_state_event(struct cec_adapter *adap)
>> +{
>> +	struct cec_event ev = {
>> +		.event = CEC_EVENT_STATE_CHANGE,
>> +	};
>> +
>> +	ev.state_change.phys_addr = adap->phys_addr;
>> +	ev.state_change.log_addr_mask = adap->log_addrs.log_addr_mask;
>> +	cec_queue_event(adap, &ev);
>> +}

<snip>

>> +/* High-level core CEC message handling */
>> +
>> +/* Transmit the Report Features message */
>> +static int cec_report_features(struct cec_adapter *adap, unsigned la_idx)
>> +{
>> +	struct cec_msg msg = { };
>> +	const struct cec_log_addrs *las = &adap->log_addrs;
>> +	const u8 *features = las->features[la_idx];
>> +	bool op_is_dev_features = false;
>> +	unsigned idx;
>> +
>> +	/* This is 2.0 and up only */
>> +	if (adap->log_addrs.cec_version < CEC_OP_CEC_VERSION_2_0)
>> +		return 0;
>> +
>> +	/* Report Features */
>> +	msg.msg[0] = (las->log_addr[la_idx] << 4) | 0x0f;
>> +	msg.len = 4;
>> +	msg.msg[1] = CEC_MSG_REPORT_FEATURES;
>> +	msg.msg[2] = adap->log_addrs.cec_version;
>> +	msg.msg[3] = las->all_device_types[la_idx];
>> +
>> +	/* Write RC Profiles first, then Device Features */
>> +	for (idx = 0; idx < sizeof(las->features[0]); idx++) {
> 
> shouldn't it be, instead, ARRAY_SIZE()?

Done.

> 
>> +		msg.msg[msg.len++] = features[idx];
>> +		if ((features[idx] & CEC_OP_FEAT_EXT) == 0) {
>> +			if (op_is_dev_features)
>> +				break;
>> +			op_is_dev_features = true;
>> +		}
>> +	}
>> +	return cec_transmit_msg(adap, &msg, false);
>> +}
>> +
>> +/* Transmit the Report Physical Address message */
>> +static int cec_report_phys_addr(struct cec_adapter *adap, unsigned la_idx)
>> +{
>> +	const struct cec_log_addrs *las = &adap->log_addrs;
>> +	struct cec_msg msg = { };
>> +
>> +	/* Report Physical Address */
>> +	msg.msg[0] = (las->log_addr[la_idx] << 4) | 0x0f;
>> +	cec_msg_report_physical_addr(&msg, adap->phys_addr,
>> +				     las->primary_device_type[la_idx]);
>> +	dprintk(2, "config: la %d pa %x.%x.%x.%x\n",
>> +			las->log_addr[la_idx],
>> +			cec_phys_addr_exp(adap->phys_addr));
> 
> Am I missing something or are there some parameters missing? you're
> printing 5 parameters, but I'm only seeing two arguments after the
> format string.

cec_phys_addr_exp expands to:

#define cec_phys_addr_exp(pa) \
        ((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf

It was quite painful to write this manually every time.

I am actually thinking of adding a printk extension for this once this
framework is out of staging. That would be much cleaner.

> 
>> +	return cec_transmit_msg(adap, &msg, false);
>> +}

<snip>

>> +/*
>> + * Log the current state of the CEC adapter.
>> + * Very useful for debugging.
>> + */
>> +static int cec_status(struct seq_file *file, void *priv)
> 
> As I briefly commented on IRC, the amount of stuff on this
> single patch/file is huge, making hard to review.
> 
> I would split it into at least 3 or 4 parts:
> 	- low-level code;
> 	- high-level code;
> 	- userspace interface;
> 	- debugfs stuff.
> 
> And put each part on a separate patch. That would easy review
> the code, as it is easy to lose the track on the logic
> due to its complexity.

I was planning to do something like that. I'm not sure if I agree about
splitting off the debugfs stuff though. It's really small.

> 
> 
>> +{
>> +	struct cec_adapter *adap = dev_get_drvdata(file->private);
>> +	struct cec_data *data;
>> +
>> +	mutex_lock(&adap->lock);
>> +	seq_printf(file, "configured: %d\n", adap->is_configured);
>> +	seq_printf(file, "configuring: %d\n", adap->is_configuring);
>> +	seq_printf(file, "phys_addr: %x.%x.%x.%x\n",
>> +		cec_phys_addr_exp(adap->phys_addr));
>> +	seq_printf(file, "number of LAs: %d\n", adap->log_addrs.num_log_addrs);
>> +	seq_printf(file, "LA mask: 0x%04x\n", adap->log_addrs.log_addr_mask);
>> +	if (adap->cec_follower)
>> +		seq_printf(file, "has CEC follower%s\n",
>> +			adap->passthrough ? " (in passthrough mode)" : "");
>> +	if (adap->cec_initiator)
>> +		seq_puts(file, "has CEC initiator\n");
>> +	if (adap->monitor_all_cnt)
>> +		seq_printf(file, "file handles in Monitor All mode: %u\n",
>> +			adap->monitor_all_cnt);
>> +	data = adap->transmitting;
>> +	if (data)
>> +		seq_printf(file, "transmitting message: %*ph (reply: %02x)\n",
>> +			data->msg.len, data->msg.msg, data->msg.reply);
>> +	list_for_each_entry(data, &adap->transmit_queue, list) {
>> +		seq_printf(file, "queued tx message: %*ph (reply: %02x)\n",
>> +			data->msg.len, data->msg.msg, data->msg.reply);
>> +	}
>> +	list_for_each_entry(data, &adap->wait_queue, list) {
>> +		seq_printf(file, "message waiting for reply: %*ph (reply: %02x)\n",
>> +			data->msg.len, data->msg.msg, data->msg.reply);
>> +	}
>> +
>> +	call_void_op(adap, adap_status, file);
>> +	mutex_unlock(&adap->lock);
>> +	return 0;
>> +}

<snip>

>> +/* Called by CEC_RECEIVE: wait for a message to arrive */
>> +static int cec_receive_msg(struct cec_fh *fh, struct cec_msg *msg, bool block)
>> +{
>> +	int res;
>> +
>> +	do {
>> +		mutex_lock(&fh->lock);
>> +		/* Are there received messages queued up? */
>> +		if (fh->queued_msgs) {
>> +			/* Yes, return the first one */
>> +			struct cec_msg_entry *entry =
>> +				list_first_entry(&fh->msgs,
>> +						 struct cec_msg_entry, list);
>> +
>> +			list_del(&entry->list);
>> +			*msg = entry->msg;
>> +			kfree(entry);
>> +			fh->queued_msgs--;
>> +			res = 0;
>> +		} else {
>> +			/* No, return EAGAIN in non-blocking mode or wait */
>> +			res = -EAGAIN;
> 
> IMHO, it will be better if you revert the if logic:
> 
> 	mutex_lock()
> 	if (!block || !fh->queued_msgs) {
> 		mutex_unlock();
> 		return -EAGAIN;
> 	}
> 
> 	// the code that handles queues message
> 
> 	That eliminates one indentation and reduce the code complexity.

I've rewritten it a bit to reduce code complexity. Your suggestion won't
work, BTW. But it is a clear indication that the code was hard to understand.

> 
>> +		}
>> +		mutex_unlock(&fh->lock);
>> +		/* Return when in non-blocking mode or if we have a message */
>> +		if (!block || !res)
>> +			break;
>> +
>> +		if (msg->timeout) {
>> +			/* The user specified a timeout */
>> +			res = wait_event_interruptible_timeout(fh->wait,
>> +				fh->queued_msgs,
>> +				msecs_to_jiffies(msg->timeout));
>> +			if (res == 0)
>> +				res = -ETIMEDOUT;
>> +			else if (res > 0)
>> +				res = 0;
>> +		} else {
>> +			/* Wait indefinitely */
>> +			res = wait_event_interruptible(fh->wait,
>> +				fh->queued_msgs);
>> +		}
>> +		/* Exit on error, otherwise loop to get the new message */
>> +	} while (!res);
>> +	return res;
>> +}
>> +
>> +static bool cec_is_busy(const struct cec_adapter *adap,
>> +			const struct cec_fh *fh)
>> +{
>> +	bool valid_initiator = adap->cec_initiator && adap->cec_initiator == fh;
>> +	bool valid_follower = adap->cec_follower && adap->cec_follower == fh;
>> +
>> +	/*
>> +	 * Exclusive initiators and followers can always access the CEC adapter
>> +	 */
>> +	if (valid_initiator || valid_follower)
>> +		return false;
>> +	/*
>> +	 * All others can only access the CEC adapter if there is no
>> +	 * exclusive initiator and they are in INITIATOR mode.
>> +	 */
>> +	return adap->cec_initiator != NULL ||
>> +	       fh->mode_initiator == CEC_MODE_NO_INITIATOR;
>> +}
>> +
>> +static long cec_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
>> +{
>> +	struct cec_devnode *devnode = cec_devnode_data(filp);
>> +	struct cec_fh *fh = filp->private_data;
>> +	struct cec_adapter *adap = fh->adap;
>> +	bool block = !(filp->f_flags & O_NONBLOCK);
>> +	void __user *parg = (void __user *)arg;
>> +	int err = 0;
>> +
>> +	if (!devnode->registered)
>> +		return -EIO;
>> +
>> +	switch (cmd) {
>> +	case CEC_ADAP_G_CAPS: {
> 
> I don't like very much handling the ioctl code directly inside a switch.
> That makes the code complex. It is usually better to have one function
> per each ioctl and use the switch (or some other structure) to call the
> function for each ioctl.

Yeah, I'll do that.

> 
>> +		struct cec_caps caps = {};
>> +
>> +		strlcpy(caps.driver, adap->devnode.parent->driver->name,
>> +			sizeof(caps.driver));
>> +		strlcpy(caps.name, adap->name, sizeof(caps.name));
>> +		caps.available_log_addrs = adap->available_log_addrs;
>> +		caps.capabilities = adap->capabilities;
>> +		caps.version = LINUX_VERSION_CODE;
>> +		if (copy_to_user(parg, &caps, sizeof(caps)))
>> +			return -EFAULT;
> 
> Shouldn't it return an error here if !adap->is_configured?
> 
>> +		break;
>> +	}
>> +
>> +	case CEC_TRANSMIT: {
>> +		struct cec_msg msg = {};
>> +
>> +		if (!(adap->capabilities & CEC_CAP_TRANSMIT))
>> +			return -ENOTTY;
>> +		if (copy_from_user(&msg, parg, sizeof(msg)))
>> +			return -EFAULT;
>> +		mutex_lock(&adap->lock);
>> +		if (!adap->is_configured) {
>> +			err = -ENONET;
>> +		} else if (cec_is_busy(adap, fh)) {
>> +			err = -EBUSY;
> 
> Better to use gotos here, instead of all those nested ifs for the
> error conditions, or to just do:
> 	mutex_unlock()
> 	return errorcode;
> 
> I don't like very much to copy_from_user() if it won't use
> the data copied. So, maybe we could first test everything
> and only then copy the data. The side effect is that it would
> copy with the mutex locked. Not sure about the impacts, if any.
> 
> Of course, if we change it here, we'll need to do the same
> changes for all ioctls.
> 
> 
>> +		} else {
>> +			if (block || !msg.reply)
>> +				fh = NULL;
>> +			err = cec_transmit_msg_fh(adap, &msg, fh, block);
>> +		}
>> +		mutex_unlock(&adap->lock);
>> +		if (err)
>> +			return err;
>> +		if (copy_to_user(parg, &msg, sizeof(msg)))
>> +			return -EFAULT;
>> +		break;
>> +	}
>> +
>> +	case CEC_RECEIVE: {
>> +		struct cec_msg msg = {};
>> +
>> +		if (copy_from_user(&msg, parg, sizeof(msg)))
>> +			return -EFAULT;
>> +		mutex_lock(&adap->lock);
>> +		if (!adap->is_configured)
>> +			err = -ENONET;
>> +		mutex_unlock(&adap->lock);
>> +		if (err)
>> +			return err;
>> +
>> +		err = cec_receive_msg(fh, &msg, block);
>> +		if (err)
>> +			return err;
>> +		if (copy_to_user(parg, &msg, sizeof(msg)))
>> +			return -EFAULT;
>> +		break;
>> +	}
>> +
>> +	case CEC_DQEVENT: {
>> +		struct cec_event_queue *evq = NULL;
>> +		struct cec_event *ev = NULL;
>> +		u64 ts = ~0ULL;
>> +		unsigned i;
>> +
>> +		mutex_lock(&fh->lock);
>> +		/* Find the oldest event */
>> +		for (i = 0; i < CEC_NUM_EVENTS; i++) {
>> +			struct cec_event_queue *q = fh->evqueue + i;
>> +
>> +			if (q->num_events && q->events->ts <= ts) {
>> +				evq = q;
>> +				ev = q->events;
>> +				ts = ev->ts;
>> +			}
>> +		}
>> +		err = -EAGAIN;
>> +		if (ev) {
>> +			if (copy_to_user(parg, ev, sizeof(*ev))) {
>> +				err = -EFAULT;
>> +			} else {
>> +				unsigned j;
>> +
>> +				evq->num_events--;
>> +				fh->events--;
>> +				/*
>> +				 * Reset lost message counter after returning
>> +				 * this event.
>> +				 */
>> +				if (ev->event == CEC_EVENT_LOST_MSGS)
>> +					fh->lost_msgs = 0;
>> +				for (j = 0; j < evq->num_events; j++)
>> +					evq->events[j] = evq->events[j + 1];
>> +				err = 0;
> 
> IMHO, it would be better to mass-pass all events to userspace
> and just empty the queue here. As mentioned before, I would also
> flag the user if there were event overflows and some events got
> discarded.

That would make it more complicated than it needs to be. Remember that we
are talking about a bus doing 36 bytes per second at best. And events
only happen on connect/disconnect or if the application is really, really
slow in processing messages.

> 
>> +			}
>> +		}
>> +		mutex_unlock(&fh->lock);
>> +		return err;
>> +	}

<snip>

>> +/* Called when the last user of the cec device exits. */
>> +static void cec_devnode_release(struct device *cd)
>> +{
>> +	struct cec_devnode *devnode = to_cec_devnode(cd);
>> +
>> +	mutex_lock(&cec_devnode_lock);
>> +
>> +	/* Mark device node number as free */
>> +	clear_bit(devnode->minor, cec_devnode_nums);
>> +
>> +	mutex_unlock(&cec_devnode_lock);
>> +	cec_delete_adapter(to_cec_adapter(devnode));
>> +}
>> +
>> +static struct bus_type cec_bus_type = {
>> +	.name = CEC_NAME,
>> +};
>> +
>> +/**
>> + * cec_devnode_register - register a cec device node
>> + * @devnode: cec device node structure we want to register
>> + *
>> + * The registration code assigns minor numbers and registers the new device node
>> + * with the kernel. An error is returned if no free minor number can be found,
>> + * or if the registration of the device node fails.
>> + *
>> + * Zero is returned on success.
>> + *
>> + * Note that if the cec_devnode_register call fails, the release() callback of
>> + * the cec_devnode structure is *not* called, so the caller is responsible for
>> + * freeing any data.
>> + */
> 
> This is a matter of taste, but I very much prefer to have the
> comments at the header files, and for all functions exported
> with EXPORT_SYMBOL_GPL(). I don't mind if you're willing to
> document non-exported functions like the one below, provided that
> all exported ones are documented, and the CEC header added to
> device-driver.tmpl.

Oops, this should be a regular comment. This is a static function only used in this
source.

> 
>> +static int __must_check cec_devnode_register(struct cec_devnode *devnode,
>> +		struct module *owner)
>> +{
>> +	int minor;
>> +	int ret;
>> +
>> +	/* Initialization */
>> +	INIT_LIST_HEAD(&devnode->fhs);
>> +	mutex_init(&devnode->fhs_lock);
>> +
>> +	/* Part 1: Find a free minor number */
>> +	mutex_lock(&cec_devnode_lock);
>> +	minor = find_next_zero_bit(cec_devnode_nums, CEC_NUM_DEVICES, 0);
>> +	if (minor == CEC_NUM_DEVICES) {
>> +		mutex_unlock(&cec_devnode_lock);
>> +		pr_err("could not get a free minor\n");
>> +		return -ENFILE;
>> +	}
>> +
>> +	set_bit(minor, cec_devnode_nums);
>> +	mutex_unlock(&cec_devnode_lock);
>> +
>> +	devnode->minor = minor;
>> +	devnode->dev.bus = &cec_bus_type;
>> +	devnode->dev.devt = MKDEV(MAJOR(cec_dev_t), minor);
>> +	devnode->dev.release = cec_devnode_release;
>> +	devnode->dev.parent = devnode->parent;
>> +	dev_set_name(&devnode->dev, "cec%d", devnode->minor);
>> +	device_initialize(&devnode->dev);
>> +
>> +	/* Part 2: Initialize and register the character device */
>> +	cdev_init(&devnode->cdev, &cec_devnode_fops);
>> +	devnode->cdev.kobj.parent = &devnode->dev.kobj;
>> +	devnode->cdev.owner = owner;
>> +
>> +	ret = cdev_add(&devnode->cdev, devnode->dev.devt, 1);
>> +	if (ret < 0) {
>> +		pr_err("%s: cdev_add failed\n", __func__);
>> +		goto clr_bit;
>> +	}
>> +
>> +	ret = device_add(&devnode->dev);
>> +	if (ret)
>> +		goto cdev_del;
>> +
>> +	devnode->registered = true;
>> +	return 0;
>> +
>> +cdev_del:
>> +	cdev_del(&devnode->cdev);
>> +clr_bit:
>> +	clear_bit(devnode->minor, cec_devnode_nums);
>> +	put_device(&devnode->dev);
>> +	return ret;
>> +}
> 
> Hmm... not sure how you're freeing the memory allocated
> for cec_devnode. Drivers can't free it directly, as a file
> descriptor may be opened. I would expect to se a kref()
> or some similar mechanism to control its lifecycle.

Oops, this cleanup path is wrong. put_device should be removed here.
Drivers will call cec_delete_adapter if cec_register_adapter fails, and
that will call kfree(adap). But see below for another related bug.

I've tested this with the fix by forcing errors from cdev_add and
device_add.

If cec_register_devnode succeeds, then everything will be cleaned up
via the cec_devnode_release callback once a driver calls cec_unregister_adapter
and the last devnode user goes away (the devnode->dev refcount goes to 0).

<snip>

>> +int cec_register_adapter(struct cec_adapter *adap)
>> +{
>> +	int res;
>> +
>> +	if (IS_ERR_OR_NULL(adap))
>> +		return 0;
>> +
>> +#if IS_ENABLED(CONFIG_RC_CORE)
>> +	if (adap->capabilities & CEC_CAP_RC) {
>> +		res = rc_register_device(adap->rc);
>> +
>> +		if (res) {
>> +			pr_err("cec-%s: failed to prepare input device\n",
>> +			       adap->name);
>> +			rc_free_device(adap->rc);
>> +			adap->rc = NULL;
>> +			return res;
>> +		}
>> +	}
>> +#endif
>> +
>> +	res = cec_devnode_register(&adap->devnode, adap->owner);
>> +#if IS_ENABLED(CONFIG_RC_CORE)

This should be inside the if. Otherwise an error from cec_devnode_register
would be ignored if CONFIG_RC_CORE would be disabled.

>> +	if (res) {
>> +		/* Note: rc_unregister also calls rc_free */
>> +		rc_unregister_device(adap->rc);
>> +		adap->rc = NULL;
>> +		return res;
>> +	}
>> +#endif

And this endif moves up to before the 'return res' line.

>> +
>> +	dev_set_drvdata(&adap->devnode.dev, adap);
>> +	if (top_cec_dir == NULL)
>> +		return 0;
>> +
>> +	adap->cec_dir = debugfs_create_dir(dev_name(&adap->devnode.dev), top_cec_dir);
>> +	if (IS_ERR_OR_NULL(adap->cec_dir)) {
>> +		pr_warn("cec-%s: Failed to create debugfs dir\n", adap->name);
>> +		return 0;
>> +	}
>> +	adap->status_file = debugfs_create_devm_seqfile(&adap->devnode.dev,
>> +		"status", adap->cec_dir, cec_status);
>> +	if (IS_ERR_OR_NULL(adap->status_file)) {
>> +		pr_warn("cec-%s: Failed to create status file\n", adap->name);
>> +		debugfs_remove_recursive(adap->cec_dir);
>> +		adap->cec_dir = NULL;
>> +	}
> 
> Hmm... shouldn't the above check if CONFIG_DEBUG_FS? Also, IMHO,
> this should be an optional feature, as people may not want it on
> production systems.

Strictly speaking it would still work if CONFIG_DEBUG_FS isn't set, but
you would get a warning that it couldn't create the debugfs dir.

Which is rather ugly. So I've added the #ifdef.

Also made a config option for this.

<snip>

>> +struct cec_op_record_src {
>> +	__u8 type;
>> +	union {
>> +		struct cec_op_digital_service_id digital;
>> +		struct {
>> +			__u8 ana_bcast_type;
>> +			__u16 ana_freq;
>> +			__u8 bcast_system;
>> +		} analog;
>> +		struct {
>> +			__u8 plug;
>> +		} ext_plug;
>> +		struct {
>> +			__u16 phys_addr;
>> +		} ext_phys_addr;
>> +	};
>> +};
> 
> Shouldn't the above be using __le or __be annotations (and the code
> below using the endiannes functions to read/write the data)?

These structs use the endianness of the host cpu, so __le or __be makes
no sense.

I don't see any advantage in using be16_to_cpu. There aren't all that many
places where there is a 16 bit number like that, and half the time it is
aligned to an odd address. I don't think it improves either readability nor
performance.

<snip>

>> diff --git a/include/linux/cec.h b/include/linux/cec.h
>> new file mode 100644
>> index 0000000..521b07cb
>> --- /dev/null
>> +++ b/include/linux/cec.h
>> @@ -0,0 +1,985 @@
>> +/*
>> + * cec - HDMI Consumer Electronics Control public header
>> + *
>> + * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifndef _CEC_UAPI_H
>> +#define _CEC_UAPI_H
> 
> Is this UAPI? If so, why it is at include/linux, instead of
> include/uapi/linux?

As we discussed on irc: this framework is still staging

I've added comments to cec.h and cec-funcs.h mentioning that the API is
likely to change before it goes out of staging.

<snip>

>> +/* Events */
>> +
>> +/* Event that occurs when the adapter state changes */
>> +#define CEC_EVENT_STATE_CHANGE		1
> 
> Are there any reason why not start with zero?

I like to keep zero unused. If userspace just zeroes a struct containing an
event ID (or if that happens accidentally in the kernel), then 0 is actually
an invalid event. Since there is no particular requirement that event IDs
start with 0 (these are really arbitrary numbers) I prefer to start counting
at 1.

Regards,

	Hans
