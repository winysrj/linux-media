Return-path: <mchehab@gaivota>
Received: from zone0.gcu-squad.org ([212.85.147.21]:19220 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1AEOqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 09:46:46 -0500
Date: Wed, 5 Jan 2011 15:45:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id field
Message-ID: <20110105154553.546998bf@endymion.delvare>
In-Reply-To: <1293587390.3098.16.camel@localhost>
References: <1293587067.3098.10.camel@localhost>
	<1293587390.3098.16.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Andy,

On Tue, 28 Dec 2010 20:49:50 -0500, Andy Walls wrote:
> Remove use of deprecated struct i2c_adapter.id field.  In the process,
> perform different detection of the HD PVR's Z8 IR microcontroller versus
> the other Hauppauge cards with the Z8 IR microcontroller.

Thanks a lot for doing this. I'll be very happy when we can finally get
rid of i2c_adapter.id.

> Also added a comment about probe() function behavior that needs to be
> fixed.

See my suggestion inline below.

> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> ---
>  drivers/staging/lirc/lirc_zilog.c |   47 ++++++++++++++++++++++++------------
>  1 files changed, 31 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
> index 52be6de..ad29bb1 100644
> --- a/drivers/staging/lirc/lirc_zilog.c
> +++ b/drivers/staging/lirc/lirc_zilog.c
> @@ -66,6 +66,7 @@ struct IR {
>  	/* Device info */
>  	struct mutex ir_lock;
>  	int open;
> +	bool is_hdpvr;
>  
>  	/* RX device */
>  	struct i2c_client c_rx;
> @@ -206,16 +207,12 @@ static int add_to_buf(struct IR *ir)
>  		}
>  
>  		/* key pressed ? */
> -#ifdef I2C_HW_B_HDPVR
> -		if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
> +		if (ir->is_hdpvr) {
>  			if (got_data && (keybuf[0] == 0x80))
>  				return 0;
>  			else if (got_data && (keybuf[0] == 0x00))
>  				return -ENODATA;
>  		} else if ((ir->b[0] & 0x80) == 0)
> -#else
> -		if ((ir->b[0] & 0x80) == 0)
> -#endif
>  			return got_data ? 0 : -ENODATA;
>  
>  		/* look what we have */
> @@ -841,15 +838,15 @@ static int send_code(struct IR *ir, unsigned int code, unsigned int key)
>  		return ret < 0 ? ret : -EFAULT;
>  	}
>  
> -#ifdef I2C_HW_B_HDPVR
>  	/*
>  	 * The sleep bits aren't necessary on the HD PVR, and in fact, the
>  	 * last i2c_master_recv always fails with a -5, so for now, we're
>  	 * going to skip this whole mess and say we're done on the HD PVR
>  	 */
> -	if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
> -		goto done;
> -#endif
> +	if (ir->is_hdpvr) {
> +		dprintk("sent code %u, key %u\n", code, key);
> +		return 0;
> +	}

I don't get the change. What was wrong with the "goto done"? Now you
duplicated the dprintk(), and as far as I can see the "done" label is
left unused.

>  
>  	/*
>  	 * This bit NAKs until the device is ready, so we retry it
> @@ -1111,12 +1108,14 @@ static int ir_remove(struct i2c_client *client);
>  static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id);
>  static int ir_command(struct i2c_client *client, unsigned int cmd, void *arg);
>  
> +#define ID_FLAG_TX	0x01
> +#define ID_FLAG_HDPVR	0x02
> +
>  static const struct i2c_device_id ir_transceiver_id[] = {
> -	/* Generic entry for any IR transceiver */
> -	{ "ir_video", 0 },
> -	/* IR device specific entries should be added here */
> -	{ "ir_tx_z8f0811_haup", 0 },
> -	{ "ir_rx_z8f0811_haup", 0 },
> +	{ "ir_tx_z8f0811_haup",  ID_FLAG_TX                 },
> +	{ "ir_rx_z8f0811_haup",  0                          },
> +	{ "ir_tx_z8f0811_hdpvr", ID_FLAG_HDPVR | ID_FLAG_TX },
> +	{ "ir_rx_z8f0811_hdpvr", ID_FLAG_HDPVR              },
>  	{ }
>  };
>  
> @@ -1196,10 +1195,25 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	int ret;
>  	int have_rx = 0, have_tx = 0;
>  
> -	dprintk("%s: adapter id=0x%x, client addr=0x%02x\n",
> -		__func__, adap->id, client->addr);
> +	dprintk("%s: adapter name (%s) nr %d, i2c_device_id name (%s), "
> +		"client addr=0x%02x\n",
> +		__func__, adap->name, adap->nr, id->name, client->addr);

The debug message format is long and confusing. What about:

	dprintk("%s: %s on i2c-%d (%s), client addr=0x%02x\n",
		__func__, id->name, adap->nr, adap->name, client->addr);

>  
>  	/*
> +	 * FIXME - This probe function probes both the Tx and Rx
> +	 * addresses of the IR microcontroller.
> +	 *
> +	 * However, the I2C subsystem is passing along one I2C client at a
> +	 * time, based on matches to the ir_transceiver_id[] table above.
> +	 * The expectation is that each i2c_client address will be probed
> +	 * individually by drivers so the I2C subsystem can mark all client
> +	 * addresses as claimed or not.
> +	 *
> +	 * This probe routine causes only one of the client addresses, TX or RX,
> +	 * to be claimed.  This will cause a problem if the I2C subsystem is
> +	 * subsequently triggered to probe unclaimed clients again.
> +	 */

This can be easily addressed. You can call i2c_new_dummy() from within
the probe function to register secondary addresses. See
drivers/misc/eeprom/at24.c for an example.

That being said, I doubt this is what we want here. i2c_new_dummy() is
only meant for cases where the board code (or bridge driver in your
case) declares a single I2C device by its main address. Here, you have
declared both the TX and RX (sub-)devices in your bridge driver, so
your I2C device driver's probe() function _will_ be called twice. It
makes no sense to ask for this in the bridge driver and then to look
for a way to work around it in the I2C device driver.

Looking at ir_probe(), it seems rather clear to me that it needs to be
redesigned seriously. This function is still doing old-style device
detection which does not belong there in the standard device driver
binding model. The bridge driver did take care of this already so there
is no point in doing it again.

>From a purely technical perspective, changing client->addr in the
probe() function is totally prohibited.

So we need more changes done to the lirc_zilog driver than your patch
currently does. In particular:
* struct IR should _not_ include private i2c_client structures. i2c
  clients are provided by the i2c-core, either as a parameter to the
  probe() function or as the result of i2c_new_dummy(). Private copies
  are never needed if you use the proper binding model.
* struct IR should probably be split into IR_rx and IR_tx. Having a
  single data structure for both TX and RX doesn't make sense when
  probe() is called once for each.
* ir_probe() should be cleaned up to do only what we expect from a
  probe function, i.e. initialize and bind. No device detection, no
  hard-coded client address. Note that it may make sense to move the
  disable_rx and disable_tx module parameters to the bridge driver, as
  in the standard device driver binding model, disabling must be done
  earlier (you want to prevent the I2C device from being instantiated.)

I see comments in the code about RX and TX interfering and IR.ir_lock
being used to prevent that. I presume this is the reason for the
current driver design. However, I can see that the driver uses
i2c_master_send() followed by i2c_master_send() or i2c_master_recv()
when it should use i2c_transfer() to guarantee that nobody uses the
adapter in-between. Assuming that the Z8 understands the repeated-start
I2C condition, this should hopefully let you get rid of IR.ir_lock and
solve the driver design issue.


> +	/*
>  	 * The external IR receiver is at i2c address 0x71.
>  	 * The IR transmitter is at 0x70.
>  	 */
> @@ -1241,6 +1255,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	mutex_init(&ir->ir_lock);
>  	mutex_init(&ir->buf_lock);
>  	ir->need_boot = 1;
> +	ir->is_hdpvr = (id->driver_data & ID_FLAG_HDPVR) ? true : false;
>  
>  	memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
>  	ir->l.minor = -1;


-- 
Jean Delvare
