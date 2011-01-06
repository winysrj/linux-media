Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:29872 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482Ab1AFAp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Jan 2011 19:45:58 -0500
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id field
From: Andy Walls <awalls@md.metrocast.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20110105154553.546998bf@endymion.delvare>
References: <1293587067.3098.10.camel@localhost>
	 <1293587390.3098.16.camel@localhost>
	 <20110105154553.546998bf@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 19:46:20 -0500
Message-ID: <1294274780.9672.93.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, 2011-01-05 at 15:45 +0100, Jean Delvare wrote:
> Hi Andy,
> 
> On Tue, 28 Dec 2010 20:49:50 -0500, Andy Walls wrote:
> > Remove use of deprecated struct i2c_adapter.id field.  In the process,
> > perform different detection of the HD PVR's Z8 IR microcontroller versus
> > the other Hauppauge cards with the Z8 IR microcontroller.
> 
> Thanks a lot for doing this. I'll be very happy when we can finally get
> rid of i2c_adapter.id.

You're welcome.  If I hadn't done it, I was worried that lirc_zilog
would have been deleted.  I want to fix lirc_zilog properly, but haven't
had the time yet.

Keep in mind, that in this patch I had one objective: remove use of
struct i2c_adapter.id . 

I turned a blind-eye to other obvious problems, since fixing
lirc_zilog's problems looked like it was going to be like peeling an
onion.  Once you peel back one layer of problems, you find another one
underneath. ;)

> > Also added a comment about probe() function behavior that needs to be
> > fixed.
> 
> See my suggestion inline below.
> 
> > Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> > ---
> >  drivers/staging/lirc/lirc_zilog.c |   47 ++++++++++++++++++++++++------------
> >  1 files changed, 31 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
> > index 52be6de..ad29bb1 100644
> > --- a/drivers/staging/lirc/lirc_zilog.c
> > +++ b/drivers/staging/lirc/lirc_zilog.c
> > @@ -66,6 +66,7 @@ struct IR {
> >  	/* Device info */
> >  	struct mutex ir_lock;
> >  	int open;
> > +	bool is_hdpvr;
> >  
> >  	/* RX device */
> >  	struct i2c_client c_rx;
> > @@ -206,16 +207,12 @@ static int add_to_buf(struct IR *ir)
> >  		}
> >  
> >  		/* key pressed ? */
> > -#ifdef I2C_HW_B_HDPVR
> > -		if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
> > +		if (ir->is_hdpvr) {
> >  			if (got_data && (keybuf[0] == 0x80))
> >  				return 0;
> >  			else if (got_data && (keybuf[0] == 0x00))
> >  				return -ENODATA;
> >  		} else if ((ir->b[0] & 0x80) == 0)
> > -#else
> > -		if ((ir->b[0] & 0x80) == 0)
> > -#endif
> >  			return got_data ? 0 : -ENODATA;
> >  
> >  		/* look what we have */
> > @@ -841,15 +838,15 @@ static int send_code(struct IR *ir, unsigned int code, unsigned int key)
> >  		return ret < 0 ? ret : -EFAULT;
> >  	}
> >  
> > -#ifdef I2C_HW_B_HDPVR
> >  	/*
> >  	 * The sleep bits aren't necessary on the HD PVR, and in fact, the
> >  	 * last i2c_master_recv always fails with a -5, so for now, we're
> >  	 * going to skip this whole mess and say we're done on the HD PVR
> >  	 */
> > -	if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
> > -		goto done;
> > -#endif
> > +	if (ir->is_hdpvr) {
> > +		dprintk("sent code %u, key %u\n", code, key);
> > +		return 0;
> > +	}
> 
> I don't get the change. What was wrong with the "goto done"? Now you
> duplicated the dprintk(), and as far as I can see the "done" label is
> left unused.

Mauro removed the "done:" label in a commit just prior to this one.
Otherwise, yes, I would have used a "goto done:".

So much needs cleaning up in lirc_zilog, that I didn't agonize over this
particular item.


> >  
> >  	/*
> >  	 * This bit NAKs until the device is ready, so we retry it
> > @@ -1111,12 +1108,14 @@ static int ir_remove(struct i2c_client *client);
> >  static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id);
> >  static int ir_command(struct i2c_client *client, unsigned int cmd, void *arg);
> >  
> > +#define ID_FLAG_TX	0x01
> > +#define ID_FLAG_HDPVR	0x02
> > +
> >  static const struct i2c_device_id ir_transceiver_id[] = {
> > -	/* Generic entry for any IR transceiver */
> > -	{ "ir_video", 0 },
> > -	/* IR device specific entries should be added here */
> > -	{ "ir_tx_z8f0811_haup", 0 },
> > -	{ "ir_rx_z8f0811_haup", 0 },
> > +	{ "ir_tx_z8f0811_haup",  ID_FLAG_TX                 },
> > +	{ "ir_rx_z8f0811_haup",  0                          },
> > +	{ "ir_tx_z8f0811_hdpvr", ID_FLAG_HDPVR | ID_FLAG_TX },
> > +	{ "ir_rx_z8f0811_hdpvr", ID_FLAG_HDPVR              },
> >  	{ }
> >  };
> >  
> > @@ -1196,10 +1195,25 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >  	int ret;
> >  	int have_rx = 0, have_tx = 0;
> >  
> > -	dprintk("%s: adapter id=0x%x, client addr=0x%02x\n",
> > -		__func__, adap->id, client->addr);
> > +	dprintk("%s: adapter name (%s) nr %d, i2c_device_id name (%s), "
> > +		"client addr=0x%02x\n",
> > +		__func__, adap->name, adap->nr, id->name, client->addr);
> 
> The debug message format is long and confusing. What about:
> 
> 	dprintk("%s: %s on i2c-%d (%s), client addr=0x%02x\n",
> 		__func__, id->name, adap->nr, adap->name, client->addr);

Ack. Your suggestion seems fine to me.  

> >  
> >  	/*
> > +	 * FIXME - This probe function probes both the Tx and Rx
> > +	 * addresses of the IR microcontroller.
> > +	 *
> > +	 * However, the I2C subsystem is passing along one I2C client at a
> > +	 * time, based on matches to the ir_transceiver_id[] table above.
> > +	 * The expectation is that each i2c_client address will be probed
> > +	 * individually by drivers so the I2C subsystem can mark all client
> > +	 * addresses as claimed or not.
> > +	 *
> > +	 * This probe routine causes only one of the client addresses, TX or RX,
> > +	 * to be claimed.  This will cause a problem if the I2C subsystem is
> > +	 * subsequently triggered to probe unclaimed clients again.
> > +	 */
> 
> This can be easily addressed. You can call i2c_new_dummy() from within
> the probe function to register secondary addresses. See
> drivers/misc/eeprom/at24.c for an example.
> 
> That being said, I doubt this is what we want here. i2c_new_dummy() is
> only meant for cases where the board code (or bridge driver in your
> case) declares a single I2C device by its main address. Here, you have
> declared both the TX and RX (sub-)devices in your bridge driver, so
> your I2C device driver's probe() function _will_ be called twice.

My intent is to ultimately have lirc_zilog handle only Tx, and let
ir-kbd-i2c handle Rx.  But that might not be possible without a mutex
shared between the two modules.  See the bit about -nak- s below...


>  It
> makes no sense to ask for this in the bridge driver and then to look
> for a way to work around it in the I2C device driver.
> 
> Looking at ir_probe(), it seems rather clear to me that it needs to be
> redesigned seriously. This function is still doing old-style device
> detection which does not belong there in the standard device driver
> binding model. The bridge driver did take care of this already so there
> is no point in doing it again.
> 
> From a purely technical perspective, changing client->addr in the
> probe() function is totally prohibited.

Ack. You are "preaching to the choir". ;)

This was out of kernel code that has it's origins in reverse engineering
the Z8 chip's behavior, over 5 years ago:

http://www.blushingpenguin.com/mark/blog/?p=17

It has been updated only a few times since then, but that is why this
code still has old style I2C binding in it.  It's current condition is
also why it is still in staging.

> So we need more changes done to the lirc_zilog driver than your patch
> currently does. In particular:
> * struct IR should _not_ include private i2c_client structures. i2c
>   clients are provided by the i2c-core, either as a parameter to the
>   probe() function or as the result of i2c_new_dummy(). Private copies
>   are never needed if you use the proper binding model.
> * struct IR should probably be split into IR_rx and IR_tx. Having a
>   single data structure for both TX and RX doesn't make sense when
>   probe() is called once for each.
> * ir_probe() should be cleaned up to do only what we expect from a
>   probe function, i.e. initialize and bind. No device detection, no
>   hard-coded client address. Note that it may make sense to move the
>   disable_rx and disable_tx module parameters to the bridge driver, as
>   in the standard device driver binding model, disabling must be done
>   earlier (you want to prevent the I2C device from being instantiated.)
> 
> I see comments in the code about RX and TX interfering and IR.ir_lock
> being used to prevent that. I presume this is the reason for the
> current driver design. However, I can see that the driver uses
> i2c_master_send() followed by i2c_master_send() or i2c_master_recv()
> when it should use i2c_transfer() to guarantee that nobody uses the
> adapter in-between. 

Thank you for the insight and guidance on how to clean things up.  


> Assuming that the Z8 understands the repeated-start
> I2C condition, this should hopefully let you get rid of IR.ir_lock and
> solve the driver design issue.

I'm not sure if it does.

Although some understanding I do have about the chip's program comes
from these captures from, I *assume*, the Windows driver talking to the
chip:

http://www.blushingpenguin.com/mark/lmilk/boot3
http://www.blushingpenguin.com/mark/lmilk/wdev3
http://www.blushingpenguin.com/mark/lmilk/thelot4

The Tx I2C address is 0x70 and the Rx I2C address is 0x71.

The host looks to be filling up part of a "page" in the Z8's memory 4
bytes at a time, starting at offsets 01, 05, 09, etc:

Offset in page--+   +--- Total number of bytes in page for this command
for this group  |   |    (only for first write, offset 0x01 in page)
or bytes        |   |
                vv vv
 29.494mS: 70 W 01 60 00 01 CC   ` . . . 
  2.043mS: 70 W 05 02 00 F3 1D   . . . . 
  2.033mS: 70 W 09 78 06 DE 68   x . . h 
  2.090mS: 70 W 0D A0 66 B8 48   . f . H 
  2.043mS: 70 W 11 B2 11 50 EE   . . P . 
  2.072mS: 70 W 15 AF 8D C3 1F   . . . . 
  2.035mS: 70 W 19 C2 A9 B4 BF   . . . . 
  2.033mS: 70 W 1D CB EC 27 56   . . ' V 
  2.028mS: 70 W 21 54 67 54 BC   T g T . 
  2.020mS: 70 W 25 13 D2 68 3F   . . h ? 
  2.070mS: 70 W 29 7B 1D 6E 81   { . n . 
  2.020mS: 70 W 2D 39 0A 44 40   9 . D @ 
  2.030mS: 70 W 31 14 59 72 4E   . Y r N 
  2.033mS: 70 W 35 51 5F 58 4E   Q _ X N 
  2.030mS: 70 W 39 68 4D 56 5E   h M V ^ 
  2.051mS: 70 W 3D 4B AF 25 1A   K . % . 
  2.062mS: 70 W 41 46 F1 02 94   F . . . 
  2.033mS: 70 W 45 2D E4 17 38   - . . 8 
  2.030mS: 70 W 49 31 9D 57 BC   1 . W . 
  2.028mS: 70 W 4D 5B 26 3E 81   [ & > . 
  2.043mS: 70 W 51 0C D7 3A 14   . . : . 
  2.020mS: 70 W 55 35 50 02 B6   5 P . . 
  2.033mS: 70 W 59 43 6A 2D 0B   C j - . 
  2.075mS: 70 W 5D 2B 11 2F 7A   + . / z 
  2.033mS: 70 W 61 00 00 00   . . . 

 10.874mS: 70 W 00 20          <--- Write some sort of "go" command at offset 00
     
  9.988mS: 70 W 00             <--- Read back some sort of Ack/Status from offset 00
    681uS: 70 r 80 01 03 00   . . . 
                ^^ ^^
 Return code----+   + length of following payload


If you look at more of the dumps, it appears that accesses to I2C
addresses 0x70 and 0x71 can be interleaved, so it looks like the
IR.ir_lock might not be needed.  Although looking further I see this:

  2.035mS: 70 W 61 00 00 00   . . . 
 10.887mS: 70 W 00 40   @ 
 10.012mS: 70 W 00   
    681uS: 70 r A0   
    717uS: 70 W 00 80   . 
 18.808mS: 70 W  -nak-  
  1.393mS: 70 W  -nak-  
  1.393mS: 70 W  -nak-  
  1.396mS: 70 W  -nak-  
  1.393mS: 70 W  -nak-  
  1.393mS: 70 W  -nak- 
[...]
  1.393mS: 70 W  -nak-  
  1.477mS: 71 W  -nak-  
  1.391mS: 71 W  -nak-  
  1.393mS: 71 W  -nak-  
  1.393mS: 71 W  -nak-  
  1.391mS: 71 W  -nak-  
  1.438mS: 71 W 00   
    681uS: 71 r 00 00 00 00 00 00   . . . . . 
 51.079mS: 70 W 00   
    681uS: 70 r 80

Which seems to indicate that actions taken on the Transmit side of the
chip can cause it to go unresponsive for both Tx and Rx.  The "goto
done;" statement that was in lirc_zilog skips the code that deals with
those -nak- for the HD PVR.

Regards,
Andy

> 
> > +	/*
> >  	 * The external IR receiver is at i2c address 0x71.
> >  	 * The IR transmitter is at 0x70.
> >  	 */
> > @@ -1241,6 +1255,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >  	mutex_init(&ir->ir_lock);
> >  	mutex_init(&ir->buf_lock);
> >  	ir->need_boot = 1;
> > +	ir->is_hdpvr = (id->driver_data & ID_FLAG_HDPVR) ? true : false;
> >  
> >  	memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
> >  	ir->l.minor = -1;
> 
> 


