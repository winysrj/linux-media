Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab3CRWgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 18:36:52 -0400
Date: Mon, 18 Mar 2013 19:36:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH 3/3] em28xx: add support for registering multiple i2c
 buses
Message-ID: <20130318193642.532f439c@redhat.com>
In-Reply-To: <5137747F.7040405@googlemail.com>
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
	<1362480928-20382-4-git-send-email-mchehab@redhat.com>
	<5137747F.7040405@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 06 Mar 2013 17:53:19 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Hi Mauro,
> 
> I'm basically fine this patch, just a few comments/thoughts:
> 
> Am 05.03.2013 11:55, schrieb Mauro Carvalho Chehab:
> > Register both buses 0 and 1 via I2C API. For now, bus 0 is used
> > only by eeprom on all known devices. Later patches will be needed
> > if this changes in the future.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-cards.c | 29 +++++++---
> >  drivers/media/usb/em28xx/em28xx-i2c.c   | 93 ++++++++++++++++++++++-----------
> >  drivers/media/usb/em28xx/em28xx.h       | 19 +++++--
> >  3 files changed, 97 insertions(+), 44 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> > index 16ab4d7..496b938 100644
> > --- a/drivers/media/usb/em28xx/em28xx-cards.c
> > +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> > @@ -2235,8 +2235,8 @@ static inline void em28xx_set_model(struct em28xx *dev)
> >  		dev->board.i2c_speed = EM28XX_I2C_CLK_WAIT_ENABLE |
> >  				       EM28XX_I2C_FREQ_100_KHZ;
> >  
> > -	if (dev->board.def_i2c_bus == 1)
> > -		dev->board.i2c_speed |= EM2874_I2C_SECONDARY_BUS_SELECT;
> > +	/* Should be initialized early, for I2C to work */
> > +	dev->def_i2c_bus = dev->board.def_i2c_bus;
> >  }
> >  
> >  
> > @@ -2642,7 +2642,7 @@ static int em28xx_hint_board(struct em28xx *dev)
> >  
> >  	/* user did not request i2c scanning => do it now */
> >  	if (!dev->i2c_hash)
> > -		em28xx_do_i2c_scan(dev);
> > +		em28xx_do_i2c_scan(dev, dev->def_i2c_bus);
> >  
> >  	for (i = 0; i < ARRAY_SIZE(em28xx_i2c_hash); i++) {
> >  		if (dev->i2c_hash == em28xx_i2c_hash[i].hash) {
> > @@ -2953,7 +2953,9 @@ void em28xx_release_resources(struct em28xx *dev)
> >  
> >  	em28xx_release_analog_resources(dev);
> >  
> > -	em28xx_i2c_unregister(dev);
> > +	if (dev->def_i2c_bus)
> > +		em28xx_i2c_unregister(dev, 1);
> > +	em28xx_i2c_unregister(dev, 0);
> >  
> >  	v4l2_ctrl_handler_free(&dev->ctrl_handler);
> >  
> > @@ -3109,14 +3111,23 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  	v4l2_ctrl_handler_init(hdl, 8);
> >  	dev->v4l2_dev.ctrl_handler = hdl;
> >  
> > -	/* register i2c bus */
> > -	retval = em28xx_i2c_register(dev);
> > +	/* register i2c bus 0 */
> > +	retval = em28xx_i2c_register(dev, 0);
> >  	if (retval < 0) {
> > -		em28xx_errdev("%s: em28xx_i2c_register - error [%d]!\n",
> > +		em28xx_errdev("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
> >  			__func__, retval);
> >  		goto unregister_dev;
> >  	}
> >  
> > +	if (dev->def_i2c_bus) {
> > +		retval = em28xx_i2c_register(dev, 1);
> 
> Hmm, ok, so you don't want to register unused busses ?

No, the reason here is to just not register it if the device has just
one bus. Ok, the driver could simply check for the em28xx chipset type,
but it sounded easier and cleaner to just check for this field.

> What about bus A when all subdevices are on bus B ?

Currently, there's no such case. If we ever find a device like that, then
we can change the logic. Doing it in advance sounds an overkill to me.

> You don't have to register the adapter for eeprom reading, the i2c
> transfer functions work with unregistered i2c_adapters, too.

Yes, I know it is possible to hack it. However, that makes the code
more complex to read and understand, as, on other drivers, each different
I2C bus is mapped as a different I2C adapter.

> 
> > +		if (retval < 0) {
> > +			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
> > +				__func__, retval);
> > +			goto unregister_dev;
> > +		}
> > +	}
> > +
> >  	/*
> >  	 * Default format, used for tvp5150 or saa711x output formats
> >  	 */
> > @@ -3186,7 +3197,9 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  	return 0;
> >  
> >  fail:
> > -	em28xx_i2c_unregister(dev);
> > +	if (dev->def_i2c_bus)
> > +		em28xx_i2c_unregister(dev, 1);
> > +	em28xx_i2c_unregister(dev, 0);
> >  	v4l2_ctrl_handler_free(&dev->ctrl_handler);
> >  
> >  unregister_dev:
> > diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> > index 9086e57..ea63ac4 100644
> > --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> > +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> > @@ -280,9 +280,22 @@ static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
> >  static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
> >  			   struct i2c_msg msgs[], int num)
> >  {
> > -	struct em28xx *dev = i2c_adap->algo_data;
> > +	struct em28xx_i2c_bus *i2c_bus = i2c_adap->algo_data;
> > +	struct em28xx *dev = i2c_bus->dev;
> > +	unsigned bus = i2c_bus->bus, last_bus;
> >  	int addr, rc, i, byte;
> >  
> > +	/* Switch I2C bus if needed */
> > +	last_bus = (dev->board.i2c_speed & EM2874_I2C_SECONDARY_BUS_SELECT) ?
> > +		   1 : 0;
> > +	if (bus != last_bus) {
> > +		if (bus == 1)
> > +			dev->board.i2c_speed |= EM2874_I2C_SECONDARY_BUS_SELECT;
> > +		else
> > +			dev->board.i2c_speed &= ~EM2874_I2C_SECONDARY_BUS_SELECT;
> > +		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
> > +	}
> > +
> 
> FYI: although it seems to be not necessary for the devices we've seen so
> far, the Windows driver clear/sets bit EM2874_I2C_SECONDARY_BUS_SELECT
> at the beginning of each i2c operation.

Yes, I'm aware of that, but we can do better than the alternative driver ;)

> Anyway, we shouldn't abuse the board data struct for saving the
> currently selected bus.
> This will also not work for briges which switch the bus by using a
> different algorithm instead of modifying register EM28XX_R06_I2C_CLK
> (like the em2765).
> So better save the currently used bus number to a variable in the device
> struct.

I actually started coding like that, but then I decided to just take the
simpler approach, as there's no big issue on modifying the value there.

Feel free to store it on a separate var at em28xx struct after adding support
for em2765.

> 
> >  	if (num <= 0)
> >  		return 0;
> >  	for (i = 0; i < num; i++) {
> > @@ -384,7 +397,7 @@ static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
> >  	/* Select address */
> >  	buf[0] = addr >> 8;
> >  	buf[1] = addr & 0xff;
> > -	ret = i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], buf + !addr_w16, 1 + addr_w16);
> > +	ret = i2c_master_send(&dev->i2c_client[0], buf + !addr_w16, 1 + addr_w16);
> 
> There is no need to restrict this function to bus 0.
> Just change dev->i2c_client[0] to dev->i2c_client[dev->current_i2c_bus]
> (or however you call this variable) or (even better) add a function
> parameter for bus selection (like you did it with em28xx_do_i2c_scan() ).
> It's currently used for eeprom reading only, but that may change in the
> future.

Again, I almost coded like that ;)
> 
> >  	if (ret < 0)
> >  		return ret;
> >  	/* Read data */
> > @@ -398,7 +411,7 @@ static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
> >  		else
> >  			rsize = remain;
> >  
> > -		ret = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus], data, rsize);
> > +		ret = i2c_master_recv(&dev->i2c_client[0], data, rsize);
> 
> The same here.
> 
> The rest looks good and I think it's a step in the right direction. :)
> 
> Regards,
> Frank

Ok, addressed the pointed issues and re-tested with HVR-930C.

[PATCH v2 3/3] em28xx: add support for registering multiple i2c buses
    
Register both buses 0 and 1 via I2C API. For now, bus 0 is used
only by eeprom on all known devices. Later patches will be needed
if this changes in the future.
    
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

-
v2:

- added a mutex to avoid using the two buses that depend on R06 at
  the same time (Devin's request);

- pass bus as a parameter for eeprom routines;

- use a separate field to store the currently used bus

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 16ab4d7..6e62b72 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2235,8 +2235,8 @@ static inline void em28xx_set_model(struct em28xx *dev)
 		dev->board.i2c_speed = EM28XX_I2C_CLK_WAIT_ENABLE |
 				       EM28XX_I2C_FREQ_100_KHZ;
 
-	if (dev->board.def_i2c_bus == 1)
-		dev->board.i2c_speed |= EM2874_I2C_SECONDARY_BUS_SELECT;
+	/* Should be initialized early, for I2C to work */
+	dev->def_i2c_bus = dev->board.def_i2c_bus;
 }
 
 
@@ -2642,7 +2642,7 @@ static int em28xx_hint_board(struct em28xx *dev)
 
 	/* user did not request i2c scanning => do it now */
 	if (!dev->i2c_hash)
-		em28xx_do_i2c_scan(dev);
+		em28xx_do_i2c_scan(dev, dev->def_i2c_bus);
 
 	for (i = 0; i < ARRAY_SIZE(em28xx_i2c_hash); i++) {
 		if (dev->i2c_hash == em28xx_i2c_hash[i].hash) {
@@ -2953,7 +2953,9 @@ void em28xx_release_resources(struct em28xx *dev)
 
 	em28xx_release_analog_resources(dev);
 
-	em28xx_i2c_unregister(dev);
+	if (dev->def_i2c_bus)
+		em28xx_i2c_unregister(dev, 1);
+	em28xx_i2c_unregister(dev, 0);
 
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 
@@ -3109,14 +3111,25 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	v4l2_ctrl_handler_init(hdl, 8);
 	dev->v4l2_dev.ctrl_handler = hdl;
 
-	/* register i2c bus */
-	retval = em28xx_i2c_register(dev);
+	rt_mutex_init(&dev->i2c_bus_lock);
+
+	/* register i2c bus 0 */
+	retval = em28xx_i2c_register(dev, 0);
 	if (retval < 0) {
-		em28xx_errdev("%s: em28xx_i2c_register - error [%d]!\n",
+		em28xx_errdev("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 			__func__, retval);
 		goto unregister_dev;
 	}
 
+	if (dev->def_i2c_bus) {
+		retval = em28xx_i2c_register(dev, 1);
+		if (retval < 0) {
+			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
+				__func__, retval);
+			goto unregister_dev;
+		}
+	}
+
 	/*
 	 * Default format, used for tvp5150 or saa711x output formats
 	 */
@@ -3186,7 +3199,9 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	return 0;
 
 fail:
-	em28xx_i2c_unregister(dev);
+	if (dev->def_i2c_bus)
+		em28xx_i2c_unregister(dev, 1);
+	em28xx_i2c_unregister(dev, 0);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 
 unregister_dev:
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9086e57..d4a48cb 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -280,11 +280,29 @@ static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
 static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			   struct i2c_msg msgs[], int num)
 {
-	struct em28xx *dev = i2c_adap->algo_data;
+	struct em28xx_i2c_bus *i2c_bus = i2c_adap->algo_data;
+	struct em28xx *dev = i2c_bus->dev;
+	unsigned bus = i2c_bus->bus;
 	int addr, rc, i, byte;
 
-	if (num <= 0)
+	rc = rt_mutex_trylock(&dev->i2c_bus_lock);
+	if (rc < 0)
+		return rc;
+
+	/* Switch I2C bus if needed */
+	if (bus != dev->cur_i2c_bus) {
+		if (bus == 1)
+			dev->cur_i2c_bus |= EM2874_I2C_SECONDARY_BUS_SELECT;
+		else
+			dev->cur_i2c_bus &= ~EM2874_I2C_SECONDARY_BUS_SELECT;
+		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->cur_i2c_bus);
+		dev->cur_i2c_bus = bus;
+	}
+
+	if (num <= 0) {
+		rt_mutex_unlock(&dev->i2c_bus_lock);
 		return 0;
+	}
 	for (i = 0; i < num; i++) {
 		addr = msgs[i].addr << 1;
 		if (i2c_debug)
@@ -301,6 +319,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			if (rc == -ENODEV) {
 				if (i2c_debug)
 					printk(" no device\n");
+				rt_mutex_unlock(&dev->i2c_bus_lock);
 				return rc;
 			}
 		} else if (msgs[i].flags & I2C_M_RD) {
@@ -336,12 +355,14 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 		if (rc < 0) {
 			if (i2c_debug)
 				printk(" ERROR: %i\n", rc);
+			rt_mutex_unlock(&dev->i2c_bus_lock);
 			return rc;
 		}
 		if (i2c_debug)
 			printk("\n");
 	}
 
+	rt_mutex_unlock(&dev->i2c_bus_lock);
 	return num;
 }
 
@@ -372,8 +393,8 @@ static inline unsigned long em28xx_hash_mem(char *buf, int length, int bits)
 
 /* Helper function to read data blocks from i2c clients with 8 or 16 bit
  * address width, 8 bit register width and auto incrementation been activated */
-static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
-				 u16 len, u8 *data)
+static int em28xx_i2c_read_block(struct em28xx *dev, unsigned bus, u16 addr,
+				 bool addr_w16, u16 len, u8 *data)
 {
 	int remain = len, rsize, rsize_max, ret;
 	u8 buf[2];
@@ -384,7 +405,7 @@ static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
 	/* Select address */
 	buf[0] = addr >> 8;
 	buf[1] = addr & 0xff;
-	ret = i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], buf + !addr_w16, 1 + addr_w16);
+	ret = i2c_master_send(&dev->i2c_client[bus], buf + !addr_w16, 1 + addr_w16);
 	if (ret < 0)
 		return ret;
 	/* Read data */
@@ -398,7 +419,7 @@ static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
 		else
 			rsize = remain;
 
-		ret = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus], data, rsize);
+		ret = i2c_master_recv(&dev->i2c_client[bus], data, rsize);
 		if (ret < 0)
 			return ret;
 
@@ -409,7 +430,8 @@ static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
 	return len;
 }
 
-static int em28xx_i2c_eeprom(struct em28xx *dev, u8 **eedata, u16 *eedata_len)
+static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
+			     u8 **eedata, u16 *eedata_len)
 {
 	const u16 len = 256;
 	/* FIXME common length/size for bytes to read, to display, hash
@@ -422,10 +444,12 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, u8 **eedata, u16 *eedata_len)
 	*eedata = NULL;
 	*eedata_len = 0;
 
-	dev->i2c_client[dev->def_i2c_bus].addr = 0xa0 >> 1;
+	/* EEPROM is always on i2c bus 0 on all known devices. */
+
+	dev->i2c_client[bus].addr = 0xa0 >> 1;
 
 	/* Check if board has eeprom */
-	err = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus], &buf, 0);
+	err = i2c_master_recv(&dev->i2c_client[bus], &buf, 0);
 	if (err < 0) {
 		em28xx_info("board has no eeprom\n");
 		return -ENODEV;
@@ -436,7 +460,8 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, u8 **eedata, u16 *eedata_len)
 		return -ENOMEM;
 
 	/* Read EEPROM content */
-	err = em28xx_i2c_read_block(dev, 0x0000, dev->eeprom_addrwidth_16bit,
+	err = em28xx_i2c_read_block(dev, bus, 0x0000,
+				    dev->eeprom_addrwidth_16bit,
 				    len, data);
 	if (err != len) {
 		em28xx_errdev("failed to read eeprom (err=%d)\n", err);
@@ -485,7 +510,8 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, u8 **eedata, u16 *eedata_len)
 
 		/* Read hardware config dataset offset from address
 		 * (microcode start + 46)			    */
-		err = em28xx_i2c_read_block(dev, mc_start + 46, 1, 2, data);
+		err = em28xx_i2c_read_block(dev, bus, mc_start + 46, 1, 2,
+					    data);
 		if (err != 2) {
 			em28xx_errdev("failed to read hardware configuration data from eeprom (err=%d)\n",
 				      err);
@@ -501,7 +527,8 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, u8 **eedata, u16 *eedata_len)
 		 * the old eeprom and not longer than 256 bytes.
 		 * tveeprom is currently also limited to 256 bytes.
 		 */
-		err = em28xx_i2c_read_block(dev, hwconf_offset, 1, len, data);
+		err = em28xx_i2c_read_block(dev, bus, hwconf_offset, 1, len,
+					    data);
 		if (err != len) {
 			em28xx_errdev("failed to read hardware configuration data from eeprom (err=%d)\n",
 				      err);
@@ -590,9 +617,11 @@ error:
 /*
  * functionality()
  */
-static u32 functionality(struct i2c_adapter *adap)
+static u32 functionality(struct i2c_adapter *i2c_adap)
 {
-	struct em28xx *dev = adap->algo_data;
+	struct em28xx_i2c_bus *i2c_bus = i2c_adap->algo_data;
+	struct em28xx *dev = i2c_bus->dev;
+
 	u32 func_flags = I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 	if (dev->board.is_em2800)
 		func_flags &= ~I2C_FUNC_SMBUS_WRITE_BLOCK_DATA;
@@ -643,7 +672,7 @@ static char *i2c_devs[128] = {
  * do_i2c_scan()
  * check i2c address range for devices
  */
-void em28xx_do_i2c_scan(struct em28xx *dev)
+void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus)
 {
 	u8 i2c_devicelist[128];
 	unsigned char buf;
@@ -652,55 +681,66 @@ void em28xx_do_i2c_scan(struct em28xx *dev)
 	memset(i2c_devicelist, 0, ARRAY_SIZE(i2c_devicelist));
 
 	for (i = 0; i < ARRAY_SIZE(i2c_devs); i++) {
-		dev->i2c_client[dev->def_i2c_bus].addr = i;
-		rc = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus], &buf, 0);
+		dev->i2c_client[bus].addr = i;
+		rc = i2c_master_recv(&dev->i2c_client[bus], &buf, 0);
 		if (rc < 0)
 			continue;
 		i2c_devicelist[i] = i;
-		em28xx_info("found i2c device @ 0x%x [%s]\n",
-			    i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
+		em28xx_info("found i2c device @ 0x%x on bus %d [%s]\n",
+			    i << 1, bus, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 
-	dev->i2c_hash = em28xx_hash_mem(i2c_devicelist,
-					ARRAY_SIZE(i2c_devicelist), 32);
+	if (bus == dev->def_i2c_bus)
+		dev->i2c_hash = em28xx_hash_mem(i2c_devicelist,
+						ARRAY_SIZE(i2c_devicelist), 32);
 }
 
 /*
  * em28xx_i2c_register()
  * register i2c bus
  */
-int em28xx_i2c_register(struct em28xx *dev)
+int em28xx_i2c_register(struct em28xx *dev, unsigned bus)
 {
 	int retval;
 
 	BUG_ON(!dev->em28xx_write_regs || !dev->em28xx_read_reg);
 	BUG_ON(!dev->em28xx_write_regs_req || !dev->em28xx_read_reg_req);
-	dev->i2c_adap[dev->def_i2c_bus] = em28xx_adap_template;
-	dev->i2c_adap[dev->def_i2c_bus].dev.parent = &dev->udev->dev;
-	strcpy(dev->i2c_adap[dev->def_i2c_bus].name, dev->name);
-	dev->i2c_adap[dev->def_i2c_bus].algo_data = dev;
-	i2c_set_adapdata(&dev->i2c_adap[dev->def_i2c_bus], &dev->v4l2_dev);
 
-	retval = i2c_add_adapter(&dev->i2c_adap[dev->def_i2c_bus]);
+	if (bus >= NUM_I2C_BUSES)
+		return -ENODEV;
+
+	dev->i2c_adap[bus] = em28xx_adap_template;
+	dev->i2c_adap[bus].dev.parent = &dev->udev->dev;
+	strcpy(dev->i2c_adap[bus].name, dev->name);
+
+	dev->i2c_bus[bus].bus = bus;
+	dev->i2c_bus[bus].dev = dev;
+	dev->i2c_adap[bus].algo_data = &dev->i2c_bus[bus];
+	i2c_set_adapdata(&dev->i2c_adap[bus], &dev->v4l2_dev);
+
+	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
 	if (retval < 0) {
 		em28xx_errdev("%s: i2c_add_adapter failed! retval [%d]\n",
 			__func__, retval);
 		return retval;
 	}
 
-	dev->i2c_client[dev->def_i2c_bus] = em28xx_client_template;
-	dev->i2c_client[dev->def_i2c_bus].adapter = &dev->i2c_adap[dev->def_i2c_bus];
+	dev->i2c_client[bus] = em28xx_client_template;
+	dev->i2c_client[bus].adapter = &dev->i2c_adap[bus];
 
-	retval = em28xx_i2c_eeprom(dev, &dev->eedata, &dev->eedata_len);
-	if ((retval < 0) && (retval != -ENODEV)) {
-		em28xx_errdev("%s: em28xx_i2_eeprom failed! retval [%d]\n",
-			__func__, retval);
+	/* Up to now, all eeproms are at bus 0 */
+	if (!bus) {
+		retval = em28xx_i2c_eeprom(dev, bus, &dev->eedata, &dev->eedata_len);
+		if ((retval < 0) && (retval != -ENODEV)) {
+			em28xx_errdev("%s: em28xx_i2_eeprom failed! retval [%d]\n",
+				__func__, retval);
 
-		return retval;
+			return retval;
+		}
 	}
 
 	if (i2c_scan)
-		em28xx_do_i2c_scan(dev);
+		em28xx_do_i2c_scan(dev, bus);
 
 	return 0;
 }
@@ -709,8 +749,11 @@ int em28xx_i2c_register(struct em28xx *dev)
  * em28xx_i2c_unregister()
  * unregister i2c_bus
  */
-int em28xx_i2c_unregister(struct em28xx *dev)
+int em28xx_i2c_unregister(struct em28xx *dev, unsigned bus)
 {
-	i2c_del_adapter(&dev->i2c_adap[dev->def_i2c_bus]);
+	if (bus >= NUM_I2C_BUSES)
+		return -ENODEV;
+
+	i2c_del_adapter(&dev->i2c_adap[bus]);
 	return 0;
 }
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 43eb1c6..f6ac1df 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -375,7 +375,7 @@ struct em28xx_board {
 	int vchannels;
 	int tuner_type;
 	int tuner_addr;
-	int def_i2c_bus;	/* Default I2C bus */
+	unsigned def_i2c_bus;	/* Default I2C bus */
 
 	/* i2c flags */
 	unsigned int tda9887_conf;
@@ -460,6 +460,13 @@ struct em28xx_fh {
 	enum v4l2_buf_type           type;
 };
 
+struct em28xx_i2c_bus {
+	struct em28xx *dev;
+
+	unsigned bus;
+};
+
+
 /* main device struct */
 struct em28xx {
 	/* generic device properties */
@@ -515,8 +522,12 @@ struct em28xx {
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap[NUM_I2C_BUSES];
 	struct i2c_client i2c_client[NUM_I2C_BUSES];
+	struct em28xx_i2c_bus i2c_bus[NUM_I2C_BUSES];
+
 	unsigned char eeprom_addrwidth_16bit:1;
-	int def_i2c_bus;	/* Default I2C bus */
+	unsigned def_i2c_bus;	/* Default I2C bus */
+	unsigned cur_i2c_bus;	/* Current I2C bus */
+	struct rt_mutex i2c_bus_lock;
 
 	/* video for linux */
 	int users;		/* user count for exclusive use */
@@ -638,9 +649,9 @@ struct em28xx_ops {
 };
 
 /* Provided by em28xx-i2c.c */
-void em28xx_do_i2c_scan(struct em28xx *dev);
-int  em28xx_i2c_register(struct em28xx *dev);
-int  em28xx_i2c_unregister(struct em28xx *dev);
+void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus);
+int  em28xx_i2c_register(struct em28xx *dev, unsigned bus);
+int  em28xx_i2c_unregister(struct em28xx *dev, unsigned bus);
 
 /* Provided by em28xx-core.c */
 int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
