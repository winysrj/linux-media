Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44727 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbcKNNWW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 08:22:22 -0500
Date: Mon, 14 Nov 2016 16:21:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org
Subject: [bug report] [media] dib0700_core: don't use stack on I2C reads
Message-ID: <20161114132142.GA15220@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

The patch fa1ecd8dc454: "[media] dib0700_core: don't use stack on I2C
reads" from Oct 7, 2016, leads to the following static checker
warning:

drivers/media/usb/dvb-usb/dib0700_core.c:273 dib0700_i2c_xfer_new() warn: inconsistent returns 'mutex:&d->i2c_mutex'.
  Locked on:   line 224
               line 250
  Unlocked on: line 178
               line 237
               line 273
drivers/media/usb/dvb-usb/dib0700_core.c:273 dib0700_i2c_xfer_new() warn: inconsistent returns 'mutex:&d->usb_mutex'.
  Locked on:   line 250
  Unlocked on: line 178
               line 224
               line 237
               line 273

drivers/media/usb/dvb-usb/dib0700_core.c
   164  static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
   165                                  int num)
   166  {
   167          /* The new i2c firmware messages are more reliable and in particular
   168             properly support i2c read calls not preceded by a write */
   169  
   170          struct dvb_usb_device *d = i2c_get_adapdata(adap);
   171          struct dib0700_state *st = d->priv;
   172          uint8_t bus_mode = 1;  /* 0=eeprom bus, 1=frontend bus */
   173          uint8_t gen_mode = 0; /* 0=master i2c, 1=gpio i2c */
   174          uint8_t en_start = 0;
   175          uint8_t en_stop = 0;
   176          int result, i;
   177  
   178          /* Ensure nobody else hits the i2c bus while we're sending our
   179             sequence of messages, (such as the remote control thread) */
   180          if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
   181                  return -EINTR;
   182  
   183          for (i = 0; i < num; i++) {
   184                  if (i == 0) {
   185                          /* First message in the transaction */
   186                          en_start = 1;
   187                  } else if (!(msg[i].flags & I2C_M_NOSTART)) {
   188                          /* Device supports repeated-start */
   189                          en_start = 1;
   190                  } else {
   191                          /* Not the first packet and device doesn't support
   192                             repeated start */
   193                          en_start = 0;
   194                  }
   195                  if (i == (num - 1)) {
   196                          /* Last message in the transaction */
   197                          en_stop = 1;
   198                  }
   199  
   200                  if (msg[i].flags & I2C_M_RD) {
   201                          /* Read request */
   202                          u16 index, value;
   203                          uint8_t i2c_dest;
   204  
   205                          i2c_dest = (msg[i].addr << 1);
   206                          value = ((en_start << 7) | (en_stop << 6) |
   207                                   (msg[i].len & 0x3F)) << 8 | i2c_dest;
   208                          /* I2C ctrl + FE bus; */
   209                          index = ((gen_mode << 6) & 0xC0) |
   210                                  ((bus_mode << 4) & 0x30);
   211  
   212                          result = usb_control_msg(d->udev,
   213                                                   usb_rcvctrlpipe(d->udev, 0),
   214                                                   REQUEST_NEW_I2C_READ,
   215                                                   USB_TYPE_VENDOR | USB_DIR_IN,
   216                                                   value, index, st->buf,
   217                                                   msg[i].len,
   218                                                   USB_CTRL_GET_TIMEOUT);
   219                          if (result < 0) {
   220                                  deb_info("i2c read error (status = %d)\n", result);
   221                                  break;
   222                          }
   223  
   224                          if (msg[i].len > sizeof(st->buf)) {
   225                                  deb_info("buffer too small to fit %d bytes\n",
   226                                           msg[i].len);
   227                                  return -EIO;

Unlock.  I would just fix this myself, but shouldn't we be returning
"i - 1" here anyway, to show mark that part transfered?

   228                          }
   229  
   230                          memcpy(msg[i].buf, st->buf, msg[i].len);
   231  
   232                          deb_data("<<< ");
   233                          debug_dump(msg[i].buf, msg[i].len, deb_data);
   234  
   235                  } else {
   236                          /* Write request */
   237                          if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
   238                                  err("could not acquire lock");
   239                                  mutex_unlock(&d->i2c_mutex);
   240                                  return -EINTR;
   241                          }
   242                          st->buf[0] = REQUEST_NEW_I2C_WRITE;
   243                          st->buf[1] = msg[i].addr << 1;
   244                          st->buf[2] = (en_start << 7) | (en_stop << 6) |
   245                                  (msg[i].len & 0x3F);
   246                          /* I2C ctrl + FE bus; */
   247                          st->buf[3] = ((gen_mode << 6) & 0xC0) |
   248                                   ((bus_mode << 4) & 0x30);
   249  
   250                          if (msg[i].len > sizeof(st->buf) - 4) {
   251                                  deb_info("i2c message to big: %d\n",
   252                                           msg[i].len);
   253                                  return -EIO;

Should unlock both locks.

   254                          }
   255  
   256                          /* The Actual i2c payload */
   257                          memcpy(&st->buf[4], msg[i].buf, msg[i].len);
   258  
   259                          deb_data(">>> ");
   260                          debug_dump(st->buf, msg[i].len + 4, deb_data);
   261  
   262                          result = usb_control_msg(d->udev,
   263                                                   usb_sndctrlpipe(d->udev, 0),
   264                                                   REQUEST_NEW_I2C_WRITE,
   265                                                   USB_TYPE_VENDOR | USB_DIR_OUT,
   266                                                   0, 0, st->buf, msg[i].len + 4,
   267                                                   USB_CTRL_GET_TIMEOUT);
   268                          mutex_unlock(&d->usb_mutex);
   269                          if (result < 0) {
   270                                  deb_info("i2c write error (status = %d)\n", result);
   271                                  break;
   272                          }
   273                  }
   274          }
   275          mutex_unlock(&d->i2c_mutex);
   276          return i;
   277  }

regards,
dan carpenter
