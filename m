Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51271 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751906AbdJKVCj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 17:02:39 -0400
Date: Wed, 11 Oct 2017 22:02:37 +0100
From: Sean Young <sean@mess.org>
To: Andy Walls <awalls.cx18@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 04/26] media: lirc_zilog: remove receiver
Message-ID: <20171011210237.bpbfuhpf7om26ldi@gofer.mess.org>
References: <cover.1507618840.git.sean@mess.org>
 <176506027db4255239dc8ce192dc6652af75bd52.1507618840.git.sean@mess.org>
 <1507750996.2479.11.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507750996.2479.11.camel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 11, 2017 at 03:43:16PM -0400, Andy Walls wrote:
> On Tue, 2017-10-10 at 08:17 +0100, Sean Young wrote:
> > The ir-kbd-i2c module already handles this very well.
> 
> Hi Sean:
> 
> It's been years, but my recollection is that although ir-kdb-i2c might
> handle receive well, but since the 4 i2c addresses (1 Rx, 1 Tx, 1 IR Tx
> code learning, 1 custom Tx code) are all handled by the same Zilog
> microcontroller internally, that splitting the Rx and Tx functionality
> between two modules became problematic.
> 
> Believe me, if i could have leveraged ir-kdb-i2c back when I ported
> this, I would have.  I think it's a very bad idea to remove the
> receiver from lirc_zilog.
> 
> The cx18 and ivtv drivers both use lirc_zilog IIRC.  Have you looked at
> the changes required to have the first I2C address used by one i2c
> module, and the next one (or three) I2C addresses used by another i2c
> module?

This is already the case.

In current kernels you can use ir-kbd-i2c for Rx and lirc_zilog for Tx,
this works fine. In fact, the lirc_zilog Rx code produces lirccodes,
(not mode2) and ir-kbd-i2c produces keycodes through rc-core, so ir-kbd-i2c
(also mainline, not staging) is much more likely to be used for Rx. For Tx
you have to use lirc_zilog.

I haven't heard of any reports of problems (or observed this myself) when
using these two modules together.

As you point out, both drivers sending i2c commands to the same z8f0811 
with its z8 encore hand-coded i2c implementation. But they're using different
addresses.

So removing the lirc_zilog Rx doesn't make things worse, in fact, it just
removes some code which is unlikely to be used.

It's the hdpvr, ivtv, cx18 and pvrusb2 drivers which have a Tx interface. I
have hdpvr and ivtv hardware to test.


Sean

> 
> -Andy
> 
> 
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/staging/media/lirc/lirc_zilog.c | 901 +++-------------------
> > ----------
> >  1 file changed, 76 insertions(+), 825 deletions(-)
> > 
> > diff --git a/drivers/staging/media/lirc/lirc_zilog.c
> > b/drivers/staging/media/lirc/lirc_zilog.c
> > index 6bd0717bf76e..757b3fc247ac 100644
> > --- a/drivers/staging/media/lirc/lirc_zilog.c
> > +++ b/drivers/staging/media/lirc/lirc_zilog.c
> > @@ -64,28 +64,7 @@
> >  /* Max transfer size done by I2C transfer functions */
> >  #define MAX_XFER_SIZE  64
> >  
> > -struct IR;
> > -
> > -struct IR_rx {
> > -	struct kref ref;
> > -	struct IR *ir;
> > -
> > -	/* RX device */
> > -	struct mutex client_lock;
> > -	struct i2c_client *c;
> > -
> > -	/* RX polling thread data */
> > -	struct task_struct *task;
> > -
> > -	/* RX read data */
> > -	unsigned char b[3];
> > -	bool hdpvr_data_fmt;
> > -};
> > -
> >  struct IR_tx {
> > -	struct kref ref;
> > -	struct IR *ir;
> > -
> >  	/* TX device */
> >  	struct mutex client_lock;
> >  	struct i2c_client *c;
> > @@ -93,39 +72,9 @@ struct IR_tx {
> >  	/* TX additional actions needed */
> >  	int need_boot;
> >  	bool post_tx_ready_poll;
> > -};
> > -
> > -struct IR {
> > -	struct kref ref;
> > -	struct list_head list;
> > -
> > -	/* FIXME spinlock access to l->features */
> >  	struct lirc_dev *l;
> > -	struct lirc_buffer rbuf;
> > -
> > -	struct mutex ir_lock;
> > -	atomic_t open_count;
> > -
> > -	struct device *dev;
> > -	struct i2c_adapter *adapter;
> > -
> > -	spinlock_t rx_ref_lock; /* struct IR_rx kref get()/put() */
> > -	struct IR_rx *rx;
> > -
> > -	spinlock_t tx_ref_lock; /* struct IR_tx kref get()/put() */
> > -	struct IR_tx *tx;
> >  };
> >  
> > -/* IR transceiver instance object list */
> > -/*
> > - * This lock is used for the following:
> > - * a. ir_devices_list access, insertions, deletions
> > - * b. struct IR kref get()s and put()s
> > - * c. serialization of ir_probe() for the two i2c_clients for a Z8
> > - */
> > -static DEFINE_MUTEX(ir_devices_lock);
> > -static LIST_HEAD(ir_devices_list);
> > -
> >  /* Block size for IR transmitter */
> >  #define TX_BLOCK_SIZE	99
> >  
> > @@ -153,348 +102,8 @@ struct tx_data_struct {
> >  static struct tx_data_struct *tx_data;
> >  static struct mutex tx_data_lock;
> >  
> > -
> >  /* module parameters */
> >  static bool debug;	/* debug output */
> > -static bool tx_only;	/* only handle the IR Tx function */
> > -
> > -
> > -/* struct IR reference counting */
> > -static struct IR *get_ir_device(struct IR *ir, bool
> > ir_devices_lock_held)
> > -{
> > -	if (ir_devices_lock_held) {
> > -		kref_get(&ir->ref);
> > -	} else {
> > -		mutex_lock(&ir_devices_lock);
> > -		kref_get(&ir->ref);
> > -		mutex_unlock(&ir_devices_lock);
> > -	}
> > -	return ir;
> > -}
> > -
> > -static void release_ir_device(struct kref *ref)
> > -{
> > -	struct IR *ir = container_of(ref, struct IR, ref);
> > -
> > -	/*
> > -	 * Things should be in this state by now:
> > -	 * ir->rx set to NULL and deallocated - happens before ir-
> > >rx->ir put()
> > -	 * ir->rx->task kthread stopped - happens before ir->rx->ir
> > put()
> > -	 * ir->tx set to NULL and deallocated - happens before ir-
> > >tx->ir put()
> > -	 * ir->open_count ==  0 - happens on final close()
> > -	 * ir_lock, tx_ref_lock, rx_ref_lock, all released
> > -	 */
> > -	if (ir->l)
> > -		lirc_unregister_device(ir->l);
> > -
> > -	if (kfifo_initialized(&ir->rbuf.fifo))
> > -		lirc_buffer_free(&ir->rbuf);
> > -	list_del(&ir->list);
> > -	kfree(ir);
> > -}
> > -
> > -static int put_ir_device(struct IR *ir, bool ir_devices_lock_held)
> > -{
> > -	int released;
> > -
> > -	if (ir_devices_lock_held)
> > -		return kref_put(&ir->ref, release_ir_device);
> > -
> > -	mutex_lock(&ir_devices_lock);
> > -	released = kref_put(&ir->ref, release_ir_device);
> > -	mutex_unlock(&ir_devices_lock);
> > -
> > -	return released;
> > -}
> > -
> > -/* struct IR_rx reference counting */
> > -static struct IR_rx *get_ir_rx(struct IR *ir)
> > -{
> > -	struct IR_rx *rx;
> > -
> > -	spin_lock(&ir->rx_ref_lock);
> > -	rx = ir->rx;
> > -	if (rx)
> > -		kref_get(&rx->ref);
> > -	spin_unlock(&ir->rx_ref_lock);
> > -	return rx;
> > -}
> > -
> > -static void destroy_rx_kthread(struct IR_rx *rx, bool
> > ir_devices_lock_held)
> > -{
> > -	/* end up polling thread */
> > -	if (!IS_ERR_OR_NULL(rx->task)) {
> > -		kthread_stop(rx->task);
> > -		rx->task = NULL;
> > -		/* Put the ir ptr that ir_probe() gave to the rx
> > poll thread */
> > -		put_ir_device(rx->ir, ir_devices_lock_held);
> > -	}
> > -}
> > -
> > -static void release_ir_rx(struct kref *ref)
> > -{
> > -	struct IR_rx *rx = container_of(ref, struct IR_rx, ref);
> > -	struct IR *ir = rx->ir;
> > -
> > -	/*
> > -	 * This release function can't do all the work, as we want
> > -	 * to keep the rx_ref_lock a spinlock, and killing the poll
> > thread
> > -	 * and releasing the ir reference can cause a sleep.  That
> > work is
> > -	 * performed by put_ir_rx()
> > -	 */
> > -	ir->l->features &= ~LIRC_CAN_REC_LIRCCODE;
> > -	/* Don't put_ir_device(rx->ir) here; lock can't be freed yet
> > */
> > -	ir->rx = NULL;
> > -	/* Don't do the kfree(rx) here; we still need to kill the
> > poll thread */
> > -}
> > -
> > -static int put_ir_rx(struct IR_rx *rx, bool ir_devices_lock_held)
> > -{
> > -	int released;
> > -	struct IR *ir = rx->ir;
> > -
> > -	spin_lock(&ir->rx_ref_lock);
> > -	released = kref_put(&rx->ref, release_ir_rx);
> > -	spin_unlock(&ir->rx_ref_lock);
> > -	/* Destroy the rx kthread while not holding the spinlock */
> > -	if (released) {
> > -		destroy_rx_kthread(rx, ir_devices_lock_held);
> > -		kfree(rx);
> > -		/* Make sure we're not still in a poll_table
> > somewhere */
> > -		wake_up_interruptible(&ir->rbuf.wait_poll);
> > -	}
> > -	/* Do a reference put() for the rx->ir reference, if we
> > released rx */
> > -	if (released)
> > -		put_ir_device(ir, ir_devices_lock_held);
> > -	return released;
> > -}
> > -
> > -/* struct IR_tx reference counting */
> > -static struct IR_tx *get_ir_tx(struct IR *ir)
> > -{
> > -	struct IR_tx *tx;
> > -
> > -	spin_lock(&ir->tx_ref_lock);
> > -	tx = ir->tx;
> > -	if (tx)
> > -		kref_get(&tx->ref);
> > -	spin_unlock(&ir->tx_ref_lock);
> > -	return tx;
> > -}
> > -
> > -static void release_ir_tx(struct kref *ref)
> > -{
> > -	struct IR_tx *tx = container_of(ref, struct IR_tx, ref);
> > -	struct IR *ir = tx->ir;
> > -
> > -	ir->l->features &= ~LIRC_CAN_SEND_LIRCCODE;
> > -	/* Don't put_ir_device(tx->ir) here, so our lock doesn't get
> > freed */
> > -	ir->tx = NULL;
> > -	kfree(tx);
> > -}
> > -
> > -static int put_ir_tx(struct IR_tx *tx, bool ir_devices_lock_held)
> > -{
> > -	int released;
> > -	struct IR *ir = tx->ir;
> > -
> > -	spin_lock(&ir->tx_ref_lock);
> > -	released = kref_put(&tx->ref, release_ir_tx);
> > -	spin_unlock(&ir->tx_ref_lock);
> > -	/* Do a reference put() for the tx->ir reference, if we
> > released tx */
> > -	if (released)
> > -		put_ir_device(ir, ir_devices_lock_held);
> > -	return released;
> > -}
> > -
> > -static int add_to_buf(struct IR *ir)
> > -{
> > -	__u16 code;
> > -	unsigned char codes[2];
> > -	unsigned char keybuf[6];
> > -	int got_data = 0;
> > -	int ret;
> > -	int failures = 0;
> > -	unsigned char sendbuf[1] = { 0 };
> > -	struct lirc_buffer *rbuf = ir->l->buf;
> > -	struct IR_rx *rx;
> > -	struct IR_tx *tx;
> > -
> > -	if (lirc_buffer_full(rbuf)) {
> > -		dev_dbg(ir->dev, "buffer overflow\n");
> > -		return -EOVERFLOW;
> > -	}
> > -
> > -	rx = get_ir_rx(ir);
> > -	if (!rx)
> > -		return -ENXIO;
> > -
> > -	/* Ensure our rx->c i2c_client remains valid for the
> > duration */
> > -	mutex_lock(&rx->client_lock);
> > -	if (!rx->c) {
> > -		mutex_unlock(&rx->client_lock);
> > -		put_ir_rx(rx, false);
> > -		return -ENXIO;
> > -	}
> > -
> > -	tx = get_ir_tx(ir);
> > -
> > -	/*
> > -	 * service the device as long as it is returning
> > -	 * data and we have space
> > -	 */
> > -	do {
> > -		if (kthread_should_stop()) {
> > -			ret = -ENODATA;
> > -			break;
> > -		}
> > -
> > -		/*
> > -		 * Lock i2c bus for the duration.  RX/TX chips
> > interfere so
> > -		 * this is worth it
> > -		 */
> > -		mutex_lock(&ir->ir_lock);
> > -
> > -		if (kthread_should_stop()) {
> > -			mutex_unlock(&ir->ir_lock);
> > -			ret = -ENODATA;
> > -			break;
> > -		}
> > -
> > -		/*
> > -		 * Send random "poll command" (?)  Windows driver
> > does this
> > -		 * and it is a good point to detect chip failure.
> > -		 */
> > -		ret = i2c_master_send(rx->c, sendbuf, 1);
> > -		if (ret != 1) {
> > -			dev_err(ir->dev, "i2c_master_send failed
> > with %d\n",
> > -				ret);
> > -			if (failures >= 3) {
> > -				mutex_unlock(&ir->ir_lock);
> > -				dev_err(ir->dev,
> > -					"unable to read from the IR
> > chip after 3 resets, giving up\n");
> > -				break;
> > -			}
> > -
> > -			/* Looks like the chip crashed, reset it */
> > -			dev_err(ir->dev,
> > -				"polling the IR receiver chip
> > failed, trying reset\n");
> > -
> > -			set_current_state(TASK_UNINTERRUPTIBLE);
> > -			if (kthread_should_stop()) {
> > -				mutex_unlock(&ir->ir_lock);
> > -				ret = -ENODATA;
> > -				break;
> > -			}
> > -			schedule_timeout((100 * HZ + 999) / 1000);
> > -			if (tx)
> > -				tx->need_boot = 1;
> > -
> > -			++failures;
> > -			mutex_unlock(&ir->ir_lock);
> > -			ret = 0;
> > -			continue;
> > -		}
> > -
> > -		if (kthread_should_stop()) {
> > -			mutex_unlock(&ir->ir_lock);
> > -			ret = -ENODATA;
> > -			break;
> > -		}
> > -		ret = i2c_master_recv(rx->c, keybuf,
> > sizeof(keybuf));
> > -		mutex_unlock(&ir->ir_lock);
> > -		if (ret != sizeof(keybuf)) {
> > -			dev_err(ir->dev,
> > -				"i2c_master_recv failed with %d --
> > keeping last read buffer\n",
> > -				ret);
> > -		} else {
> > -			rx->b[0] = keybuf[3];
> > -			rx->b[1] = keybuf[4];
> > -			rx->b[2] = keybuf[5];
> > -			dev_dbg(ir->dev,
> > -				"key (0x%02x/0x%02x)\n",
> > -				rx->b[0], rx->b[1]);
> > -		}
> > -
> > -		/* key pressed ? */
> > -		if (rx->hdpvr_data_fmt) {
> > -			if (got_data && (keybuf[0] == 0x80)) {
> > -				ret = 0;
> > -				break;
> > -			} else if (got_data && (keybuf[0] == 0x00))
> > {
> > -				ret = -ENODATA;
> > -				break;
> > -			}
> > -		} else if ((rx->b[0] & 0x80) == 0) {
> > -			ret = got_data ? 0 : -ENODATA;
> > -			break;
> > -		}
> > -
> > -		/* look what we have */
> > -		code = (((__u16)rx->b[0] & 0x7f) << 6) | (rx->b[1]
> > >> 2);
> > -
> > -		codes[0] = (code >> 8) & 0xff;
> > -		codes[1] = code & 0xff;
> > -
> > -		/* return it */
> > -		lirc_buffer_write(rbuf, codes);
> > -		++got_data;
> > -		ret = 0;
> > -	} while (!lirc_buffer_full(rbuf));
> > -
> > -	mutex_unlock(&rx->client_lock);
> > -	if (tx)
> > -		put_ir_tx(tx, false);
> > -	put_ir_rx(rx, false);
> > -	return ret;
> > -}
> > -
> > -/*
> > - * Main function of the polling thread -- from lirc_dev.
> > - * We don't fit the LIRC model at all anymore.  This is horrible,
> > but
> > - * basically we have a single RX/TX device with a nasty failure mode
> > - * that needs to be accounted for across the pair.  lirc lets us
> > provide
> > - * fops, but prevents us from using the internal polling, etc. if we
> > do
> > - * so.  Hence the replication.  Might be neater to extend the LIRC
> > model
> > - * to account for this but I'd think it's a very special case of
> > seriously
> > - * messed up hardware.
> > - */
> > -static int lirc_thread(void *arg)
> > -{
> > -	struct IR *ir = arg;
> > -	struct lirc_buffer *rbuf = ir->l->buf;
> > -
> > -	dev_dbg(ir->dev, "poll thread started\n");
> > -
> > -	while (!kthread_should_stop()) {
> > -		set_current_state(TASK_INTERRUPTIBLE);
> > -
> > -		/* if device not opened, we can sleep half a second
> > */
> > -		if (atomic_read(&ir->open_count) == 0) {
> > -			schedule_timeout(HZ / 2);
> > -			continue;
> > -		}
> > -
> > -		/*
> > -		 * This is ~113*2 + 24 + jitter (2*repeat gap + code
> > length).
> > -		 * We use this interval as the chip resets every
> > time you poll
> > -		 * it (bad!).  This is therefore just sufficient to
> > catch all
> > -		 * of the button presses.  It makes the remote much
> > more
> > -		 * responsive.  You can see the difference by
> > running irw and
> > -		 * holding down a button.  With 100ms, the old
> > polling
> > -		 * interval, you'll notice breaks in the repeat
> > sequence
> > -		 * corresponding to lost keypresses.
> > -		 */
> > -		schedule_timeout((260 * HZ) / 1000);
> > -		if (kthread_should_stop())
> > -			break;
> > -		if (!add_to_buf(ir))
> > -			wake_up_interruptible(&rbuf->wait_poll);
> > -	}
> > -
> > -	dev_dbg(ir->dev, "poll thread ended\n");
> > -	return 0;
> > -}
> >  
> >  /* safe read of a uint32 (always network byte order) */
> >  static int read_uint32(unsigned char **data,
> > @@ -645,10 +254,10 @@ static int send_data_block(struct IR_tx *tx,
> > unsigned char *data_block)
> >  		buf[0] = (unsigned char)(i + 1);
> >  		for (j = 0; j < tosend; ++j)
> >  			buf[1 + j] = data_block[i + j];
> > -		dev_dbg(tx->ir->dev, "%*ph", 5, buf);
> > +		dev_dbg(&tx->l->dev, "%*ph", 5, buf);
> >  		ret = i2c_master_send(tx->c, buf, tosend + 1);
> >  		if (ret != tosend + 1) {
> > -			dev_err(tx->ir->dev,
> > +			dev_err(&tx->l->dev,
> >  				"i2c_master_send failed with %d\n",
> > ret);
> >  			return ret < 0 ? ret : -EFAULT;
> >  		}
> > @@ -673,7 +282,7 @@ static int send_boot_data(struct IR_tx *tx)
> >  	buf[1] = 0x20;
> >  	ret = i2c_master_send(tx->c, buf, 2);
> >  	if (ret != 2) {
> > -		dev_err(tx->ir->dev, "i2c_master_send failed with
> > %d\n", ret);
> > +		dev_err(&tx->l->dev, "i2c_master_send failed with
> > %d\n", ret);
> >  		return ret < 0 ? ret : -EFAULT;
> >  	}
> >  
> > @@ -690,22 +299,22 @@ static int send_boot_data(struct IR_tx *tx)
> >  	}
> >  
> >  	if (ret != 1) {
> > -		dev_err(tx->ir->dev, "i2c_master_send failed with
> > %d\n", ret);
> > +		dev_err(&tx->l->dev, "i2c_master_send failed with
> > %d\n", ret);
> >  		return ret < 0 ? ret : -EFAULT;
> >  	}
> >  
> >  	/* Here comes the firmware version... (hopefully) */
> >  	ret = i2c_master_recv(tx->c, buf, 4);
> >  	if (ret != 4) {
> > -		dev_err(tx->ir->dev, "i2c_master_recv failed with
> > %d\n", ret);
> > +		dev_err(&tx->l->dev, "i2c_master_recv failed with
> > %d\n", ret);
> >  		return 0;
> >  	}
> >  	if ((buf[0] != 0x80) && (buf[0] != 0xa0)) {
> > -		dev_err(tx->ir->dev, "unexpected IR TX init
> > response: %02x\n",
> > +		dev_err(&tx->l->dev, "unexpected IR TX init
> > response: %02x\n",
> >  			buf[0]);
> >  		return 0;
> >  	}
> > -	dev_notice(tx->ir->dev,
> > +	dev_notice(&tx->l->dev,
> >  		   "Zilog/Hauppauge IR blaster firmware version
> > %d.%d.%d loaded\n",
> >  		   buf[1], buf[2], buf[3]);
> >  
> > @@ -750,15 +359,15 @@ static int fw_load(struct IR_tx *tx)
> >  	}
> >  
> >  	/* Request codeset data file */
> > -	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", tx-
> > >ir->dev);
> > +	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin",
> > &tx->l->dev);
> >  	if (ret != 0) {
> > -		dev_err(tx->ir->dev,
> > +		dev_err(&tx->l->dev,
> >  			"firmware haup-ir-blaster.bin not available
> > (%d)\n",
> >  			ret);
> >  		ret = ret < 0 ? ret : -EFAULT;
> >  		goto out;
> >  	}
> > -	dev_dbg(tx->ir->dev, "firmware of size %zu loaded\n",
> > fw_entry->size);
> > +	dev_dbg(&tx->l->dev, "firmware of size %zu loaded\n",
> > fw_entry->size);
> >  
> >  	/* Parse the file */
> >  	tx_data = vmalloc(sizeof(*tx_data));
> > @@ -786,7 +395,7 @@ static int fw_load(struct IR_tx *tx)
> >  	if (!read_uint8(&data, tx_data->endp, &version))
> >  		goto corrupt;
> >  	if (version != 1) {
> > -		dev_err(tx->ir->dev,
> > +		dev_err(&tx->l->dev,
> >  			"unsupported code set file version (%u,
> > expected 1) -- please upgrade to a newer driver\n",
> >  			version);
> >  		fw_unload_locked();
> > @@ -803,7 +412,7 @@ static int fw_load(struct IR_tx *tx)
> >  			 &tx_data->num_code_sets))
> >  		goto corrupt;
> >  
> > -	dev_dbg(tx->ir->dev, "%u IR blaster codesets loaded\n",
> > +	dev_dbg(&tx->l->dev, "%u IR blaster codesets loaded\n",
> >  		tx_data->num_code_sets);
> >  
> >  	tx_data->code_sets = vmalloc(
> > @@ -868,7 +477,7 @@ static int fw_load(struct IR_tx *tx)
> >  	goto out;
> >  
> >  corrupt:
> > -	dev_err(tx->ir->dev, "firmware is corrupt\n");
> > +	dev_err(&tx->l->dev, "firmware is corrupt\n");
> >  	fw_unload_locked();
> >  	ret = -EFAULT;
> >  
> > @@ -877,94 +486,6 @@ static int fw_load(struct IR_tx *tx)
> >  	return ret;
> >  }
> >  
> > -/* copied from lirc_dev */
> > -static ssize_t read(struct file *filep, char __user *outbuf, size_t
> > n,
> > -		    loff_t *ppos)
> > -{
> > -	struct IR *ir = lirc_get_pdata(filep);
> > -	struct IR_rx *rx;
> > -	struct lirc_buffer *rbuf = ir->l->buf;
> > -	int ret = 0, written = 0, retries = 0;
> > -	unsigned int m;
> > -	DECLARE_WAITQUEUE(wait, current);
> > -
> > -	dev_dbg(ir->dev, "read called\n");
> > -	if (n % rbuf->chunk_size) {
> > -		dev_dbg(ir->dev, "read result = -EINVAL\n");
> > -		return -EINVAL;
> > -	}
> > -
> > -	rx = get_ir_rx(ir);
> > -	if (!rx)
> > -		return -ENXIO;
> > -
> > -	/*
> > -	 * we add ourselves to the task queue before buffer check
> > -	 * to avoid losing scan code (in case when queue is awaken
> > somewhere
> > -	 * between while condition checking and scheduling)
> > -	 */
> > -	add_wait_queue(&rbuf->wait_poll, &wait);
> > -	set_current_state(TASK_INTERRUPTIBLE);
> > -
> > -	/*
> > -	 * while we didn't provide 'length' bytes, device is opened
> > in blocking
> > -	 * mode and 'copy_to_user' is happy, wait for data.
> > -	 */
> > -	while (written < n && ret == 0) {
> > -		if (lirc_buffer_empty(rbuf)) {
> > -			/*
> > -			 * According to the read(2) man page,
> > 'written' can be
> > -			 * returned as less than 'n', instead of
> > blocking
> > -			 * again, returning -EWOULDBLOCK, or
> > returning
> > -			 * -ERESTARTSYS
> > -			 */
> > -			if (written)
> > -				break;
> > -			if (filep->f_flags & O_NONBLOCK) {
> > -				ret = -EWOULDBLOCK;
> > -				break;
> > -			}
> > -			if (signal_pending(current)) {
> > -				ret = -ERESTARTSYS;
> > -				break;
> > -			}
> > -			schedule();
> > -			set_current_state(TASK_INTERRUPTIBLE);
> > -		} else {
> > -			unsigned char buf[MAX_XFER_SIZE];
> > -
> > -			if (rbuf->chunk_size > sizeof(buf)) {
> > -				dev_err(ir->dev,
> > -					"chunk_size is too big
> > (%d)!\n",
> > -					rbuf->chunk_size);
> > -				ret = -EINVAL;
> > -				break;
> > -			}
> > -			m = lirc_buffer_read(rbuf, buf);
> > -			if (m == rbuf->chunk_size) {
> > -				ret = copy_to_user(outbuf + written,
> > buf,
> > -						   rbuf-
> > >chunk_size);
> > -				written += rbuf->chunk_size;
> > -			} else {
> > -				retries++;
> > -			}
> > -			if (retries >= 5) {
> > -				dev_err(ir->dev, "Buffer read
> > failed!\n");
> > -				ret = -EIO;
> > -			}
> > -		}
> > -	}
> > -
> > -	remove_wait_queue(&rbuf->wait_poll, &wait);
> > -	put_ir_rx(rx, false);
> > -	set_current_state(TASK_RUNNING);
> > -
> > -	dev_dbg(ir->dev, "read result = %d (%s)\n", ret,
> > -		ret ? "Error" : "OK");
> > -
> > -	return ret ? ret : written;
> > -}
> > -
> >  /* send a keypress to the IR TX device */
> >  static int send_code(struct IR_tx *tx, unsigned int code, unsigned
> > int key)
> >  {
> > @@ -976,7 +497,7 @@ static int send_code(struct IR_tx *tx, unsigned
> > int code, unsigned int key)
> >  	ret = get_key_data(data_block, code, key);
> >  
> >  	if (ret == -EPROTO) {
> > -		dev_err(tx->ir->dev,
> > +		dev_err(&tx->l->dev,
> >  			"failed to get data for code %u, key %u --
> > check lircd.conf entries\n",
> >  			code, key);
> >  		return ret;
> > @@ -994,7 +515,7 @@ static int send_code(struct IR_tx *tx, unsigned
> > int code, unsigned int key)
> >  	buf[1] = 0x40;
> >  	ret = i2c_master_send(tx->c, buf, 2);
> >  	if (ret != 2) {
> > -		dev_err(tx->ir->dev, "i2c_master_send failed with
> > %d\n", ret);
> > +		dev_err(&tx->l->dev, "i2c_master_send failed with
> > %d\n", ret);
> >  		return ret < 0 ? ret : -EFAULT;
> >  	}
> >  
> > @@ -1007,18 +528,18 @@ static int send_code(struct IR_tx *tx,
> > unsigned int code, unsigned int key)
> >  	}
> >  
> >  	if (ret != 1) {
> > -		dev_err(tx->ir->dev, "i2c_master_send failed with
> > %d\n", ret);
> > +		dev_err(&tx->l->dev, "i2c_master_send failed with
> > %d\n", ret);
> >  		return ret < 0 ? ret : -EFAULT;
> >  	}
> >  
> >  	/* Send finished download? */
> >  	ret = i2c_master_recv(tx->c, buf, 1);
> >  	if (ret != 1) {
> > -		dev_err(tx->ir->dev, "i2c_master_recv failed with
> > %d\n", ret);
> > +		dev_err(&tx->l->dev, "i2c_master_recv failed with
> > %d\n", ret);
> >  		return ret < 0 ? ret : -EFAULT;
> >  	}
> >  	if (buf[0] != 0xA0) {
> > -		dev_err(tx->ir->dev, "unexpected IR TX response #1:
> > %02x\n",
> > +		dev_err(&tx->l->dev, "unexpected IR TX response #1:
> > %02x\n",
> >  			buf[0]);
> >  		return -EFAULT;
> >  	}
> > @@ -1028,7 +549,7 @@ static int send_code(struct IR_tx *tx, unsigned
> > int code, unsigned int key)
> >  	buf[1] = 0x80;
> >  	ret = i2c_master_send(tx->c, buf, 2);
> >  	if (ret != 2) {
> > -		dev_err(tx->ir->dev, "i2c_master_send failed with
> > %d\n", ret);
> > +		dev_err(&tx->l->dev, "i2c_master_send failed with
> > %d\n", ret);
> >  		return ret < 0 ? ret : -EFAULT;
> >  	}
> >  
> > @@ -1038,7 +559,7 @@ static int send_code(struct IR_tx *tx, unsigned
> > int code, unsigned int key)
> >  	 * going to skip this whole mess and say we're done on the
> > HD PVR
> >  	 */
> >  	if (!tx->post_tx_ready_poll) {
> > -		dev_dbg(tx->ir->dev, "sent code %u, key %u\n", code,
> > key);
> > +		dev_dbg(&tx->l->dev, "sent code %u, key %u\n", code,
> > key);
> >  		return 0;
> >  	}
> >  
> > @@ -1054,12 +575,12 @@ static int send_code(struct IR_tx *tx,
> > unsigned int code, unsigned int key)
> >  		ret = i2c_master_send(tx->c, buf, 1);
> >  		if (ret == 1)
> >  			break;
> > -		dev_dbg(tx->ir->dev,
> > +		dev_dbg(&tx->l->dev,
> >  			"NAK expected: i2c_master_send failed with
> > %d (try %d)\n",
> >  			ret, i + 1);
> >  	}
> >  	if (ret != 1) {
> > -		dev_err(tx->ir->dev,
> > +		dev_err(&tx->l->dev,
> >  			"IR TX chip never got ready: last
> > i2c_master_send failed with %d\n",
> >  			ret);
> >  		return ret < 0 ? ret : -EFAULT;
> > @@ -1068,17 +589,17 @@ static int send_code(struct IR_tx *tx,
> > unsigned int code, unsigned int key)
> >  	/* Seems to be an 'ok' response */
> >  	i = i2c_master_recv(tx->c, buf, 1);
> >  	if (i != 1) {
> > -		dev_err(tx->ir->dev, "i2c_master_recv failed with
> > %d\n", ret);
> > +		dev_err(&tx->l->dev, "i2c_master_recv failed with
> > %d\n", ret);
> >  		return -EFAULT;
> >  	}
> >  	if (buf[0] != 0x80) {
> > -		dev_err(tx->ir->dev, "unexpected IR TX response #2:
> > %02x\n",
> > +		dev_err(&tx->l->dev, "unexpected IR TX response #2:
> > %02x\n",
> >  			buf[0]);
> >  		return -EFAULT;
> >  	}
> >  
> >  	/* Oh good, it worked */
> > -	dev_dbg(tx->ir->dev, "sent code %u, key %u\n", code, key);
> > +	dev_dbg(&tx->l->dev, "sent code %u, key %u\n", code, key);
> >  	return 0;
> >  }
> >  
> > @@ -1091,8 +612,7 @@ static int send_code(struct IR_tx *tx, unsigned
> > int code, unsigned int key)
> >  static ssize_t write(struct file *filep, const char __user *buf,
> > size_t n,
> >  		     loff_t *ppos)
> >  {
> > -	struct IR *ir = lirc_get_pdata(filep);
> > -	struct IR_tx *tx;
> > +	struct IR_tx *tx = lirc_get_pdata(filep);
> >  	size_t i;
> >  	int failures = 0;
> >  
> > @@ -1100,31 +620,20 @@ static ssize_t write(struct file *filep, const
> > char __user *buf, size_t n,
> >  	if (n % sizeof(int))
> >  		return -EINVAL;
> >  
> > -	/* Get a struct IR_tx reference */
> > -	tx = get_ir_tx(ir);
> > -	if (!tx)
> > -		return -ENXIO;
> > -
> >  	/* Ensure our tx->c i2c_client remains valid for the
> > duration */
> >  	mutex_lock(&tx->client_lock);
> >  	if (!tx->c) {
> >  		mutex_unlock(&tx->client_lock);
> > -		put_ir_tx(tx, false);
> >  		return -ENXIO;
> >  	}
> >  
> > -	/* Lock i2c bus for the duration */
> > -	mutex_lock(&ir->ir_lock);
> > -
> >  	/* Send each keypress */
> >  	for (i = 0; i < n;) {
> >  		int ret = 0;
> >  		int command;
> >  
> >  		if (copy_from_user(&command, buf + i,
> > sizeof(command))) {
> > -			mutex_unlock(&ir->ir_lock);
> >  			mutex_unlock(&tx->client_lock);
> > -			put_ir_tx(tx, false);
> >  			return -EFAULT;
> >  		}
> >  
> > @@ -1133,9 +642,7 @@ static ssize_t write(struct file *filep, const
> > char __user *buf, size_t n,
> >  			/* Make sure we have the 'firmware' loaded,
> > first */
> >  			ret = fw_load(tx);
> >  			if (ret != 0) {
> > -				mutex_unlock(&ir->ir_lock);
> >  				mutex_unlock(&tx->client_lock);
> > -				put_ir_tx(tx, false);
> >  				if (ret != -ENOMEM)
> >  					ret = -EIO;
> >  				return ret;
> > @@ -1151,9 +658,7 @@ static ssize_t write(struct file *filep, const
> > char __user *buf, size_t n,
> >  			ret = send_code(tx, (unsigned int)command >>
> > 16,
> >  					    (unsigned int)command &
> > 0xFFFF);
> >  			if (ret == -EPROTO) {
> > -				mutex_unlock(&ir->ir_lock);
> >  				mutex_unlock(&tx->client_lock);
> > -				put_ir_tx(tx, false);
> >  				return ret;
> >  			}
> >  		}
> > @@ -1164,15 +669,13 @@ static ssize_t write(struct file *filep, const
> > char __user *buf, size_t n,
> >  		 */
> >  		if (ret != 0) {
> >  			/* Looks like the chip crashed, reset it */
> > -			dev_err(tx->ir->dev,
> > +			dev_err(&tx->l->dev,
> >  				"sending to the IR transmitter chip
> > failed, trying reset\n");
> >  
> >  			if (failures >= 3) {
> > -				dev_err(tx->ir->dev,
> > +				dev_err(&tx->l->dev,
> >  					"unable to send to the IR
> > chip after 3 resets, giving up\n");
> > -				mutex_unlock(&ir->ir_lock);
> >  				mutex_unlock(&tx->client_lock);
> > -				put_ir_tx(tx, false);
> >  				return ret;
> >  			}
> >  			set_current_state(TASK_UNINTERRUPTIBLE);
> > @@ -1184,60 +687,21 @@ static ssize_t write(struct file *filep, const
> > char __user *buf, size_t n,
> >  		}
> >  	}
> >  
> > -	/* Release i2c bus */
> > -	mutex_unlock(&ir->ir_lock);
> > -
> >  	mutex_unlock(&tx->client_lock);
> >  
> > -	/* Give back our struct IR_tx reference */
> > -	put_ir_tx(tx, false);
> > -
> >  	/* All looks good */
> >  	return n;
> >  }
> >  
> > -/* copied from lirc_dev */
> > -static unsigned int poll(struct file *filep, poll_table *wait)
> > -{
> > -	struct IR *ir = lirc_get_pdata(filep);
> > -	struct IR_rx *rx;
> > -	struct lirc_buffer *rbuf = ir->l->buf;
> > -	unsigned int ret;
> > -
> > -	dev_dbg(ir->dev, "%s called\n", __func__);
> > -
> > -	rx = get_ir_rx(ir);
> > -	if (!rx) {
> > -		/*
> > -		 * Revisit this, if our poll function ever reports
> > writeable
> > -		 * status for Tx
> > -		 */
> > -		dev_dbg(ir->dev, "%s result = POLLERR\n", __func__);
> > -		return POLLERR;
> > -	}
> > -
> > -	/*
> > -	 * Add our lirc_buffer's wait_queue to the poll_table. A
> > wake up on
> > -	 * that buffer's wait queue indicates we may have a new poll
> > status.
> > -	 */
> > -	poll_wait(filep, &rbuf->wait_poll, wait);
> > -
> > -	/* Indicate what ops could happen immediately without
> > blocking */
> > -	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN | POLLRDNORM);
> > -
> > -	dev_dbg(ir->dev, "%s result = %s\n", __func__,
> > -		ret ? "POLLIN|POLLRDNORM" : "none");
> > -	return ret;
> > -}
> >  
> >  static long ioctl(struct file *filep, unsigned int cmd, unsigned
> > long arg)
> >  {
> > -	struct IR *ir = lirc_get_pdata(filep);
> > +	struct IR_tx *tx = lirc_get_pdata(filep);
> >  	unsigned long __user *uptr = (unsigned long __user *)arg;
> >  	int result;
> >  	unsigned long mode, features;
> >  
> > -	features = ir->l->features;
> > +	features = tx->l->features;
> >  
> >  	switch (cmd) {
> >  	case LIRC_GET_LENGTH:
> > @@ -1287,13 +751,7 @@ static long ioctl(struct file *filep, unsigned
> > int cmd, unsigned long arg)
> >   */
> >  static int open(struct inode *node, struct file *filep)
> >  {
> > -	struct IR *ir;
> > -
> >  	lirc_init_pdata(node, filep);
> > -	ir = lirc_get_pdata(filep);
> > -
> > -	atomic_inc(&ir->open_count);
> > -
> >  	nonseekable_open(node, filep);
> >  	return 0;
> >  }
> > @@ -1301,25 +759,16 @@ static int open(struct inode *node, struct
> > file *filep)
> >  /* Close the IR device */
> >  static int close(struct inode *node, struct file *filep)
> >  {
> > -	struct IR *ir = lirc_get_pdata(filep);
> > -
> > -	atomic_dec(&ir->open_count);
> > -
> > -	put_ir_device(ir, false);
> >  	return 0;
> >  }
> >  
> > -static int ir_remove(struct i2c_client *client);
> >  static int ir_probe(struct i2c_client *client, const struct
> > i2c_device_id *id);
> >  
> > -#define ID_FLAG_TX	0x01
> > -#define ID_FLAG_HDPVR	0x02
> > +#define ID_FLAG_HDPVR	0x01
> >  
> >  static const struct i2c_device_id ir_transceiver_id[] = {
> > -	{ "ir_tx_z8f0811_haup",  ID_FLAG_TX                 },
> > -	{ "ir_rx_z8f0811_haup",  0                          },
> > -	{ "ir_tx_z8f0811_hdpvr", ID_FLAG_HDPVR | ID_FLAG_TX },
> > -	{ "ir_rx_z8f0811_hdpvr", ID_FLAG_HDPVR              },
> > +	{ "ir_tx_z8f0811_haup",  0 },
> > +	{ "ir_tx_z8f0811_hdpvr", ID_FLAG_HDPVR },
> >  	{ }
> >  };
> >  MODULE_DEVICE_TABLE(i2c, ir_transceiver_id);
> > @@ -1329,16 +778,13 @@ static struct i2c_driver driver = {
> >  		.name	= "Zilog/Hauppauge i2c IR",
> >  	},
> >  	.probe		= ir_probe,
> > -	.remove		= ir_remove,
> >  	.id_table	= ir_transceiver_id,
> >  };
> >  
> >  static const struct file_operations lirc_fops = {
> >  	.owner		= THIS_MODULE,
> >  	.llseek		= no_llseek,
> > -	.read		= read,
> >  	.write		= write,
> > -	.poll		= poll,
> >  	.unlocked_ioctl	= ioctl,
> >  #ifdef CONFIG_COMPAT
> >  	.compat_ioctl	= ioctl,
> > @@ -1347,55 +793,11 @@ static const struct file_operations lirc_fops
> > = {
> >  	.release	= close
> >  };
> >  
> > -static int ir_remove(struct i2c_client *client)
> > -{
> > -	if (strncmp("ir_tx_z8", client->name, 8) == 0) {
> > -		struct IR_tx *tx = i2c_get_clientdata(client);
> > -
> > -		if (tx) {
> > -			mutex_lock(&tx->client_lock);
> > -			tx->c = NULL;
> > -			mutex_unlock(&tx->client_lock);
> > -			put_ir_tx(tx, false);
> > -		}
> > -	} else if (strncmp("ir_rx_z8", client->name, 8) == 0) {
> > -		struct IR_rx *rx = i2c_get_clientdata(client);
> > -
> > -		if (rx) {
> > -			mutex_lock(&rx->client_lock);
> > -			rx->c = NULL;
> > -			mutex_unlock(&rx->client_lock);
> > -			put_ir_rx(rx, false);
> > -		}
> > -	}
> > -	return 0;
> > -}
> > -
> > -/* ir_devices_lock must be held */
> > -static struct IR *get_ir_device_by_adapter(struct i2c_adapter
> > *adapter)
> > -{
> > -	struct IR *ir;
> > -
> > -	if (list_empty(&ir_devices_list))
> > -		return NULL;
> > -
> > -	list_for_each_entry(ir, &ir_devices_list, list)
> > -		if (ir->adapter == adapter) {
> > -			get_ir_device(ir, true);
> > -			return ir;
> > -		}
> > -
> > -	return NULL;
> > -}
> > -
> >  static int ir_probe(struct i2c_client *client, const struct
> > i2c_device_id *id)
> >  {
> > -	struct IR *ir;
> >  	struct IR_tx *tx;
> > -	struct IR_rx *rx;
> >  	struct i2c_adapter *adap = client->adapter;
> >  	int ret;
> > -	bool tx_probe = false;
> >  
> >  	dev_dbg(&client->dev, "%s: %s on i2c-%d (%s), client
> > addr=0x%02x\n",
> >  		__func__, id->name, adap->nr, adap->name, client-
> > >addr);
> > @@ -1405,209 +807,61 @@ static int ir_probe(struct i2c_client
> > *client, const struct i2c_device_id *id)
> >  	 * The IR transmitter is at i2c address 0x70.
> >  	 */
> >  
> > -	if (id->driver_data & ID_FLAG_TX)
> > -		tx_probe = true;
> > -	else if (tx_only) /* module option */
> > -		return -ENXIO;
> > -
> > -	pr_info("probing IR %s on %s (i2c-%d)\n",
> > -		tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
> > -
> > -	mutex_lock(&ir_devices_lock);
> > -
> > -	/* Use a single struct IR instance for both the Rx and Tx
> > functions */
> > -	ir = get_ir_device_by_adapter(adap);
> > -	if (!ir) {
> > -		ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> > -		if (!ir) {
> > -			ret = -ENOMEM;
> > -			goto out_no_ir;
> > -		}
> > -		kref_init(&ir->ref);
> > -
> > -		/* store for use in ir_probe() again, and open()
> > later on */
> > -		INIT_LIST_HEAD(&ir->list);
> > -		list_add_tail(&ir->list, &ir_devices_list);
> > -
> > -		ir->adapter = adap;
> > -		ir->dev = &adap->dev;
> > -		mutex_init(&ir->ir_lock);
> > -		atomic_set(&ir->open_count, 0);
> > -		spin_lock_init(&ir->tx_ref_lock);
> > -		spin_lock_init(&ir->rx_ref_lock);
> > -
> > -		/* set lirc_dev stuff */
> > -		ir->l = lirc_allocate_device();
> > -		if (!ir->l) {
> > -			ret = -ENOMEM;
> > -			goto out_put_ir;
> > -		}
> > -
> > -		snprintf(ir->l->name, sizeof(ir->l->name),
> > "lirc_zilog");
> > -		ir->l->code_length = 13;
> > -		ir->l->fops = &lirc_fops;
> > -		ir->l->owner = THIS_MODULE;
> > -		ir->l->dev.parent = &adap->dev;
> > -
> > -		/*
> > -		 * FIXME this is a pointer reference to us, but no
> > refcount.
> > -		 *
> > -		 * This OK for now, since lirc_dev currently won't
> > touch this
> > -		 * buffer as we provide our own lirc_fops.
> > -		 *
> > -		 * Currently our own lirc_fops rely on this ir->l-
> > >buf pointer
> > -		 */
> > -		ir->l->buf = &ir->rbuf;
> > -		/* This will be returned by lirc_get_pdata() */
> > -		ir->l->data = ir;
> > -		ret = lirc_buffer_init(ir->l->buf, 2, BUFLEN / 2);
> > -		if (ret) {
> > -			lirc_free_device(ir->l);
> > -			ir->l = NULL;
> > -			goto out_put_ir;
> > -		}
> > -	}
> > +	pr_info("probing IR Tx on %s (i2c-%d)\n", adap->name, adap-
> > >nr);
> >  
> > -	if (tx_probe) {
> > -		/* Get the IR_rx instance for later, if already
> > allocated */
> > -		rx = get_ir_rx(ir);
> > -
> > -		/* Set up a struct IR_tx instance */
> > -		tx = kzalloc(sizeof(*tx), GFP_KERNEL);
> > -		if (!tx) {
> > -			ret = -ENOMEM;
> > -			goto out_put_xx;
> > -		}
> > -		kref_init(&tx->ref);
> > -		ir->tx = tx;
> > -
> > -		ir->l->features |= LIRC_CAN_SEND_LIRCCODE;
> > -		mutex_init(&tx->client_lock);
> > -		tx->c = client;
> > -		tx->need_boot = 1;
> > -		tx->post_tx_ready_poll =
> > -			       (id->driver_data & ID_FLAG_HDPVR) ?
> > false : true;
> > -
> > -		/* An ir ref goes to the struct IR_tx instance */
> > -		tx->ir = get_ir_device(ir, true);
> > -
> > -		/* A tx ref goes to the i2c_client */
> > -		i2c_set_clientdata(client, get_ir_tx(ir));
> > -
> > -		/*
> > -		 * Load the 'firmware'.  We do this before
> > registering with
> > -		 * lirc_dev, so the first firmware load attempt does
> > not happen
> > -		 * after a open() or write() call on the device.
> > -		 *
> > -		 * Failure here is not deemed catastrophic, so the
> > receiver will
> > -		 * still be usable.  Firmware load will be retried
> > in write(),
> > -		 * if it is needed.
> > -		 */
> > -		fw_load(tx);
> > -
> > -		/* Proceed only if the Rx client is also ready or
> > not needed */
> > -		if (!rx && !tx_only) {
> > -			dev_info(tx->ir->dev,
> > -				 "probe of IR Tx on %s (i2c-%d)
> > done. Waiting on IR Rx.\n",
> > -				 adap->name, adap->nr);
> > -			goto out_ok;
> > -		}
> > -	} else {
> > -		/* Get the IR_tx instance for later, if already
> > allocated */
> > -		tx = get_ir_tx(ir);
> > -
> > -		/* Set up a struct IR_rx instance */
> > -		rx = kzalloc(sizeof(*rx), GFP_KERNEL);
> > -		if (!rx) {
> > -			ret = -ENOMEM;
> > -			goto out_put_xx;
> > -		}
> > -		kref_init(&rx->ref);
> > -		ir->rx = rx;
> > -
> > -		ir->l->features |= LIRC_CAN_REC_LIRCCODE;
> > -		mutex_init(&rx->client_lock);
> > -		rx->c = client;
> > -		rx->hdpvr_data_fmt =
> > -			       (id->driver_data & ID_FLAG_HDPVR) ?
> > true : false;
> > -
> > -		/* An ir ref goes to the struct IR_rx instance */
> > -		rx->ir = get_ir_device(ir, true);
> > +	/* Set up a struct IR_tx instance */
> > +	tx = devm_kzalloc(&client->dev, sizeof(*tx), GFP_KERNEL);
> > +	if (!tx)
> > +		return -ENOMEM;
> >  
> > -		/* An rx ref goes to the i2c_client */
> > -		i2c_set_clientdata(client, get_ir_rx(ir));
> > +	mutex_init(&tx->client_lock);
> > +	tx->c = client;
> > +	tx->need_boot = 1;
> > +	tx->post_tx_ready_poll = !(id->driver_data & ID_FLAG_HDPVR);
> >  
> > -		/*
> > -		 * Start the polling thread.
> > -		 * It will only perform an empty loop around
> > schedule_timeout()
> > -		 * until we register with lirc_dev and the first
> > user open()
> > -		 */
> > -		/* An ir ref goes to the new rx polling kthread */
> > -		rx->task = kthread_run(lirc_thread,
> > get_ir_device(ir, true),
> > -				       "zilog-rx-i2c-%d", adap->nr);
> > -		if (IS_ERR(rx->task)) {
> > -			ret = PTR_ERR(rx->task);
> > -			dev_err(tx->ir->dev,
> > -				"%s: could not start IR Rx polling
> > thread\n",
> > -				__func__);
> > -			/* Failed kthread, so put back the ir ref */
> > -			put_ir_device(ir, true);
> > -			/* Failure exit, so put back rx ref from
> > i2c_client */
> > -			i2c_set_clientdata(client, NULL);
> > -			put_ir_rx(rx, true);
> > -			ir->l->features &= ~LIRC_CAN_REC_LIRCCODE;
> > -			goto out_put_tx;
> > -		}
> > +	/* set lirc_dev stuff */
> > +	tx->l = lirc_allocate_device();
> > +	if (!tx->l)
> > +		return -ENOMEM;
> >  
> > -		/* Proceed only if the Tx client is also ready */
> > -		if (!tx) {
> > -			pr_info("probe of IR Rx on %s (i2c-%d) done.
> > Waiting on IR Tx.\n",
> > -				adap->name, adap->nr);
> > -			goto out_ok;
> > -		}
> > -	}
> > +	snprintf(tx->l->name, sizeof(tx->l->name), "lirc_zilog");
> > +	tx->l->features |= LIRC_CAN_SEND_LIRCCODE;
> > +	tx->l->code_length = 13;
> > +	tx->l->fops = &lirc_fops;
> > +	tx->l->owner = THIS_MODULE;
> > +	tx->l->dev.parent = &client->dev;
> >  
> >  	/* register with lirc */
> > -	ret = lirc_register_device(ir->l);
> > +	ret = lirc_register_device(tx->l);
> >  	if (ret < 0) {
> > -		dev_err(tx->ir->dev,
> > -			"%s: lirc_register_device() failed: %i\n",
> > +		dev_err(&tx->l->dev, "%s: lirc_register_device()
> > failed: %i\n",
> >  			__func__, ret);
> > -		lirc_free_device(ir->l);
> > -		ir->l = NULL;
> > -		goto out_put_xx;
> > +		lirc_free_device(tx->l);
> > +		tx->l = NULL;
> > +		return ret;
> >  	}
> >  
> > -	dev_info(ir->dev,
> > +	/*
> > +	 * Load the 'firmware'.  We do this before registering with
> > +	 * lirc_dev, so the first firmware load attempt does not
> > happen
> > +	 * after a open() or write() call on the device.
> > +	 */
> > +	ret = fw_load(tx);
> > +	if (ret < 0) {
> > +		lirc_unregister_device(tx->l);
> > +		return ret;
> > +	}
> > +
> > +	/* A tx ref goes to the i2c_client */
> > +	i2c_set_clientdata(client, tx);
> > +
> > +	dev_info(&tx->l->dev,
> >  		 "IR unit on %s (i2c-%d) registered as lirc%d and
> > ready\n",
> > -		 adap->name, adap->nr, ir->l->minor);
> > -
> > -out_ok:
> > -	if (rx)
> > -		put_ir_rx(rx, true);
> > -	if (tx)
> > -		put_ir_tx(tx, true);
> > -	put_ir_device(ir, true);
> > -	dev_info(ir->dev,
> > -		 "probe of IR %s on %s (i2c-%d) done\n",
> > -		 tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
> > -	mutex_unlock(&ir_devices_lock);
> > -	return 0;
> > +		 adap->name, adap->nr, tx->l->minor);
> >  
> > -out_put_xx:
> > -	if (rx)
> > -		put_ir_rx(rx, true);
> > -out_put_tx:
> > -	if (tx)
> > -		put_ir_tx(tx, true);
> > -out_put_ir:
> > -	put_ir_device(ir, true);
> > -out_no_ir:
> > -	dev_err(&client->dev,
> > -		"%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> > -		__func__, tx_probe ? "Tx" : "Rx", adap->name, adap-
> > >nr, ret);
> > -	mutex_unlock(&ir_devices_lock);
> > -	return ret;
> > +	dev_info(&tx->l->dev,
> > +		 "probe of IR Tx on %s (i2c-%d) done\n", adap->name, 
> > adap->nr);
> > +	return 0;
> >  }
> >  
> >  static int __init zilog_init(void)
> > @@ -1648,6 +902,3 @@ MODULE_ALIAS("lirc_pvr150");
> >  
> >  module_param(debug, bool, 0644);
> >  MODULE_PARM_DESC(debug, "Enable debugging messages");
> > -
> > -module_param(tx_only, bool, 0644);
> > -MODULE_PARM_DESC(tx_only, "Only handle the IR transmit function");
