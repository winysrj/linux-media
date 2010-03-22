Return-path: <linux-media-owner@vger.kernel.org>
Received: from www49.your-server.de ([213.133.104.49]:43977 "EHLO
	www49.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab0CVKQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 06:16:20 -0400
Received: from [188.107.127.143] (helo=[192.168.1.32])
	by www49.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <repplinger@motama.com>)
	id 1NteHq-0002Cp-C5
	for linux-media@vger.kernel.org; Mon, 22 Mar 2010 10:51:06 +0100
Message-ID: <4BA73D83.1010002@motama.com>
Date: Mon, 22 Mar 2010 10:50:59 +0100
From: Michael Repplinger <repplinger@motama.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Questions to ngene/dvb_frontend driver [Original email was "Problems
 with ngene based DVB cards (Digital Devices Cine S2 Dual DVB-S2 , Mystique
 SaTiX S2 Dual)"]
Content-Type: multipart/mixed;
 boundary="------------050201040901070003040101"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050201040901070003040101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,
I read the problems described in email thread "Problems with ngene based
DVB cards (Digital Devices Cine S2 Dual DVB-S2 , Mystique SaTiX S2
Dual)". Unfortunately, I just subscribed to this list so I cannot
respond to the original mail directly but it can be found at the end of
this mail.

For tracking down the described problems with high delays, I tried to
understand the dvb_frontend and ngene driver and added some output
messages. The added output messages are attached as a ptach to this
email. Since this was the first time I read the source code of the
module I was not able to find a real problem or bug.

However, I found 3 issues that I would like to report. Especially issue
1) could be a problem. Here the irq handler of ngene module is still
triggered for 60secs if the last application using the DVB devices
terminates.
In Issue 2) I describe the methods that need more time when the
described problem occur. Unfortunately, I could only determine that
these methods need more time but was not able to find a reason.
Issue 3) could be related to issue 1). Here I saw that the ngene module
is not informed if the DVB frontend device is closed.

Again, since I read the source code of a driver for the first time I
don't know if the described issues are OK or not. It would be great if
some of you could check the described issues. Maybe this information
helps to find/solve the problem.

Thanks in advance
  Michael Repplinger

Testsystem:
-Kernel: 2.6.25.20-0.5-pae (Suse 11.0 distribution)
-Driver: following endriss/ngene DVB driver + attached patch
  *Repository URL : http://linuxtv.org/hg/~endriss/ngene
  *Revision       : 14413:510e37da759e

*Issue 1) IRQ handler is triggered  for 60 seconds after last
application stops using the dvb device:*

Reproduce Test:
a) load dvb modules as follows:
  rmmod ngene
  rmmod dvb_core

  modprobe dvb_core dvbdev_debug=1 frontend_debug=1 debug=1 cam_debug=1
dvb_demux_tscheck=1 dvb_net_debug=1 
  modprobe ngene debug=1 one_adapter=0

b) tail -f /var/log/messages
c) In parallel to b) start
   ./szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -x

*Observation 1: *
In b) one can see the following output messages:
Mar 20 14:18:01 dvb_host kernel: ngene>: irq_handler IRQ 16
Mar 20 14:18:01 dvb_host kernel: ngene< : irq_handler return IRQ_HANDLED
Mar 20 14:18:01 dvb_host kernel: ngene: demux_tasklet
Mar 20 14:18:01 dvb_host kernel: ngene: tsin_exchange

=> The following mehtods of ngene-core.c are called
- static irqreturn_t irq_handler(int irq, void *dev_id) ( produces the
first two lines of the above output messages)
- static void demux_tasklet(unsigned long data) ( produces the third
lines of the above output messages)
- static void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock,
u32 flags) (procudes the last output message)

=> IRQ handler of ngene-core module is periodically triggered as soon as the
first application using DVB device has been used

*Observation 2: *
Exactly 60 seconds after executing c), the IRQ handler is no longer
triggered
and no more output messages appear in b).
Here the last output messages are:

Mar 20 14:19:01 dvb_host kernel: ngene< : irq_handler return IRQ_HANDLED
Mar 20 14:19:01 dvb_host kernel: ngene: demux_tasklet
Mar 20 14:19:01 dvb_host kernel: ngene: tsin_exchange
Mar 20 14:19:01 dvb_host kernel: ngene: ngene_i2c_master_xfer
Mar 20 14:19:01 dvb_host kernel: ngene: > ngene_i2x_set_bus
Mar 20 14:19:01 dvb_host kernel: ngene: ngene_i2c_set_bus
Mar 20 14:19:01 dvb_host kernel: ngene: < ngene_i2x_set_bus
Mar 20 14:19:01 dvb_host kernel: ngene: num = 1 ngene_command_i2c_write
Mar 20 14:19:01 dvb_host kernel: ngene: ngene_command_i2c_write
Mar 20 14:19:01 dvb_host kernel: ngene: ngene_command
Mar 20 14:19:01 dvb_host kernel: ngene: ngene_command_mutex
Mar 20 14:19:01 dvb_host kernel: ngene>: irq_handler IRQ 16
Mar 20 14:19:01 dvb_host kernel: ngene< : irq_handler return IRQ_HANDLED
Mar 20 14:19:01 dvb_host kernel: ngene>: irq_handler IRQ 16
Mar 20 14:19:01 dvb_host kernel: ngene< : irq_handler return IRQ_HANDLED
Mar 20 14:19:01 dvb_host kernel: ngene: ngene_i2c_master_xfer  succeeded

=> In this case, the mehtod ngene_i2c_master_xfer is invoked and
successfully processed (additional invoked methods can also be seen from
the output).

*Conclusion: *
Since I dont understand whats going on here, I don't know if this is
correct or could cause problems. However, I would expect that the IRQ
handler is not triggered, if no application accesses the DVB device.
Moreover, after 60 seconds the IRQ trigger is no longer triggered. This
looks like the kernel (or any other module) stops the ngene-module.



*Issue 2) High delay ~(1.7-18 seconds) when switching the channel *
By enabling and adding additional output messages in used dvb modules, I was
able to find the mehtod that causes a higher delay.


Reproduce Test:
a) load dvb modules as follows:
  rmmod ngene
  rmmod dvb_core

  modprobe dvb_core dvbdev_debug=1 frontend_debug=1 debug=1 cam_debug=1
dvb_demux_tscheck=1 dvb_net_debug=1 
  modprobe ngene debug=1 one_adapter=0

b) tail -f /var/log/messages

c)./run_szap-s2_adapter0.sh | grep Delay

d) in parallel to c)
szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -r

=> while d) is running c) will show increased tuning times

*Observations: *
In b) one can see the following output
Mar 20 11:15:23 dvb_host kernel: dvb_frontend_thread: Frontend ALGO =
DVBFE_ALGO_CUSTOM, state=2
Mar 20 11:15:23 dvb_host kernel: dvb_frontend_thread: Retune requested,
FESTAT_RETUNE
Mar 20 11:15:23 dvb_host kernel: >search, status
Mar 20 11:15:23 dvb_host kernel: dvb_frontend_ioctl (69)
<Delay>
Mar 20 09:32:25 dvb_host kernel: <search, status
Mar 20 11:15:25 dvb_host kernel: dvb_frontend_add_event


=> Excecuting dvb_frontend_ioctl 69 needs more time to be executed. The
reason for this is that the exectuing the ioctl requires locking an
internal mutex. This mutex is still locked by method dvb_frontend_thread
due to tuning the channel. In more detail, method dvb_frontend_thread
handles the case DVBFE_ALGO_CUSTOM: which performs a customized tuning
method. The corresponding
search operation looks as follows.
  dprintk(">search, status\n");                                     
      /* We did do a search as was requested, the flags are
        * now unset as well and has the flags wrt to search.
        */
      fepriv->algo_status = fe->ops.search(fe,
&fepriv->parameters);           
  dprintk("<search, status\n");                                     

The method invocation fe->ops.search triggers method
ngene_i2c_master_xfer in ngene-core.c several times. The amount of
invoking method ngene_i2c_master_xfer is equal when you have good or bad
tuning delays.

*Conclusion:  *
The only conclusion I can get from this test is that the tuning mehtod
itself needs more time. Thats what we already know. Unfortunately, I was
not able to find a reason why executing the involved methods for tuning
need more time.


*Issue 3) Is opending/closing the frontend device in dvb_frontend/ngene
module OK?. *
Actually, I dont know if these methods are correctly implemented, The
corresponding mehtods in dvb_frontend.c are:

static int dvb_frontend_open(struct inode *inode, struct file *file)
static int dvb_frontend_release(struct inode *inode, struct file *file)

In method dvb_frontend_release, I added some output message to see if the
clenaup operations in all if-statemements are executeed.

      if (fepriv->exit == 1) {
              dprintk (" >Internal cleanup when closin DVB device 
%s\n", __func__);      
              fops_put(file->f_op);
              file->f_op = NULL;
              wake_up(&dvbdev->wait_queue);
              dprintk (" <Internal cleanup when closin DVB device 
%s\n", __func__);      
      }
      if (fe->ops.ts_bus_ctrl) {
              dprintk (" >Invoke fe->ops.ts_bus_ctrl  %s\n",
__func__);      
              fe->ops.ts_bus_ctrl(fe, 0);
              dprintk (" >Invoke fe->ops.ts_bus_ctrl %s\n",
__func__);         
      }                    

Reproduce Test:
a) load dvb modules as follows:
  rmmod ngene
  rmmod dvb_core

  modprobe dvb_core dvbdev_debug=1 frontend_debug=1 debug=1 cam_debug=1
dvb_demux_tscheck=1 dvb_net_debug=1 
  modprobe ngene debug=1 one_adapter=0

b) tail -f /var/log/messages | grep -v ngene

c) ./szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -x

Observation:
In b) the following output appears adedd output messages appear
...
Mar 20 15:17:30 dvb_host kernel:  <down interruptable dvb_frontend_ioctl
(73)
Mar 20 15:17:30 dvb_host kernel:  dvb_frontend_ioctl_legacy
dvb_frontend_ioctl (73)
Mar 20 15:17:30 dvb_host kernel: > up dvb_frontend_ioctl (73)
Mar 20 15:17:30 dvb_host kernel: <up dvb_frontend_ioctl (73)
Mar 20 15:17:30 dvb_host kernel: dvb_frontend_release

The added output messages do not appear. =>Not all cleanup functions are
called. However, even after reading the code I don't know if this is
correct or not. These if-statements seem to be executed only if the
frontend-thread is stopped (which happens if the module is unloaded). So
I think this is OK.

However, no additional mehtod on the ngene-core module is called. If you
use the following command in b)
  tail -f /var/log/messages
then you receive only the messages described in issue 1), observation
1). If you outcomment the corresponding output messages in ngene-core.c,
no additional output message appears from ngene module.


*Conclusion: *
I think that there is no general problem with opening/closing methods
implemented in dvb-frontend.c. The only problem I could see is that the
ngene module is not informed about this. From my point of view I found
only one reason to inform the ngene module about such an event which is
to unregister the IRQ handler (see issue 1). Since I have no real
knlowedge about driver development, I don't know if this is correct or not.


On Thu, Mar 18, 2010 at 11:07 AM, Marco *Lohse* <m*lohse* <at>
motama.com> wrote:
> Devin Heitmueller wrote:
>> On Thu, Mar 18, 2010 at 6:00 AM, Andreas Besse <besse <at>
motama.com> wrote:
>>> Hello,
>>>
>>> We are now able to reproduce the problem faster and easier (using the
>>> patched version of szap-s2 and the scripts included in the tar.gz :
>>>
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/17334
>>> and
>>>
http://cache.gmane.org//gmane/linux/drivers/video-input-infrastructure/17334-001.bin
>>> )
>>
>> This is pretty interesting.  I'm doing some ngene work over the next
>> few weeks, so I will see if I can reproduce the behavior you are
>> seeing here.
>>
>> I noticed  that you are manually setting the "one_adapter=0" modprobe
>> setting.  Does this have any bearing on the test results?
>>
>
> I will try to answer this one:
>
> No, leaving out this parameter does not change the test results; you
> will only need to use different and additional parameters for szap-s2
> for specifying the correct adapter and sub-devices.
>
> By now, we also found out that the problems can be reproduced much easier:
>
> 0)
>
> szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -x |
> grep Delay
>
> Delay : 0.573021
>
> 1)
>
> szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -x |
> grep Delay
> Delay : 0.564667
>
> 2)
>
> szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -x |
> grep Delay
> Delay : 1.741931
>
> Instead of 2) you can also run the included script
>
> 2')
>
> ./run_szap-s2_adapter0.sh
>
> which will result in the device timeout after 30-40 iterations
>
> To summarize
>
> => When opening and closing adapter0, then opening and closing devices
> of adapter1, this will immediately result in problems.
>
> And there a lot more variations of this bug, for example: actually read
> data from adapter0, tune adapter1 using szap-s2, which will result in
> adapter0 to be 'blocked' and not produce any more data after around 60
secs.
>
> We are currently trying to dig into the source code of the driver to
> solve the problems and would appreciate any help.




--------------050201040901070003040101
Content-Type: text/x-patch;
 name="ngene_dvbfrontend_debug_output.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ngene_dvbfrontend_debug_output.patch"

Index: linux/drivers/media/dvb/ngene/ngene-core.c
===================================================================
--- linux/drivers/media/dvb/ngene/ngene-core.c	(revision 1)
+++ linux/drivers/media/dvb/ngene/ngene-core.c	(revision 5)
@@ -90,6 +90,8 @@
 {
 	struct ngene *dev = (struct ngene *)data;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	while (dev->EventQueueReadIndex != dev->EventQueueWriteIndex) {
 		struct EVENT_BUFFER Event =
 			dev->EventQueue[dev->EventQueueReadIndex];
@@ -117,6 +119,8 @@
 	struct ngene_channel *chan = (struct ngene_channel *)data;
 	struct SBufferHeader *Cur = chan->nextBuffer;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	spin_lock_irq(&chan->state_lock);
 
 	while (Cur->ngeneBuffer.SR.Flags & 0x80) {
@@ -211,6 +215,8 @@
 	u32 i = MAX_STREAM;
 	u8 *tmpCmdDoneByte;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ">: %s IRQ %i\n", __func__, irq);
+
 	if (dev->BootFirmware) {
 		icounts = ngreadl(NGENE_INT_COUNTS);
 		if (icounts != dev->icounts) {
@@ -220,6 +226,10 @@
 			dev->icounts = icounts;
 			rc = IRQ_HANDLED;
 		}
+                if ( rc != IRQ_HANDLED ) {
+                  dprintk("Unhandled IRQ %i occured\n", irq);
+                }
+                dprintk (KERN_DEBUG DEVICE_NAME "<: %s Return dev->BootFirmware \n", __func__);                                               
 		return rc;
 	}
 
@@ -260,7 +270,12 @@
 		dev->EventBuffer->EventStatus &= ~0x80;
 		tasklet_schedule(&dev->event_tasklet);
 		rc = IRQ_HANDLED;
-	}
+	} else {
+          if( i == 0) {
+            dprintk (KERN_DEBUG DEVICE_NAME ": %s IRQ handler does not execute any method \n", __func__);
+          }      
+        }       
+        
 
 	while (i > 0) {
 		i--;
@@ -278,6 +293,8 @@
 		}
 		spin_unlock(&dev->channel[i].state_lock);
 	}
+         
+        dprintk (KERN_DEBUG DEVICE_NAME "< : %s return IRQ_HANDLED \n", __func__);                                               
 
 	/* Request might have been processed by a previous call. */
 	return IRQ_HANDLED;
@@ -291,6 +308,8 @@
 {
 	u8 buf[8], *b;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	ngcpyfrom(buf, HOST_TO_NGENE, 8);
 	printk(KERN_ERR "host_to_ngene (%04x): %02x %02x %02x %02x %02x %02x %02x %02x\n",
 		HOST_TO_NGENE, buf[0], buf[1], buf[2], buf[3],
@@ -315,6 +334,8 @@
 	int ret;
 	u8 *tmpCmdDoneByte;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	dev->cmd_done = 0;
 
 	if (com->cmd.hdr.Opcode == CMD_FWLOAD_PREPARE) {
@@ -394,6 +415,8 @@
 {
 	int result;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	down(&dev->cmd_mutex);
 	result = ngene_command_mutex(dev, com);
 	up(&dev->cmd_mutex);
@@ -419,6 +442,8 @@
 {
 	struct ngene_command com;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	com.cmd.hdr.Opcode = CMD_I2C_READ;
 	com.cmd.hdr.Length = outlen + 3;
 	com.cmd.I2CRead.Device = adr << 1;
@@ -446,6 +471,8 @@
 {
 	struct ngene_command com;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 #if 0
 	/* Probing by writing 0 bytes does not work */
 	if (!outlen)
@@ -475,6 +502,8 @@
 	u32 cleft;
 	struct ngene_command com;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	com.cmd.hdr.Opcode = CMD_FWLOAD_PREPARE;
 	com.cmd.hdr.Length = 0;
 	com.in_len = 0;
@@ -583,6 +612,8 @@
 {
 	struct ngene_command com;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	com.cmd.hdr.Opcode = CMD_CONFIGURE_BUFFER;
 	com.cmd.hdr.Length = 1;
 	com.cmd.ConfigureBuffers.config = config;
@@ -598,6 +629,8 @@
 {
 	struct ngene_command com;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	com.cmd.hdr.Opcode = CMD_CONFIGURE_FREE_BUFFER;
 	com.cmd.hdr.Length = 6;
 	memcpy(&com.cmd.ConfigureBuffers.config, config, 6);
@@ -614,6 +647,8 @@
 {
 	struct ngene_command com;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	com.cmd.hdr.Opcode = CMD_SET_GPIO_PIN;
 	com.cmd.hdr.Length = 1;
 	com.cmd.SetGpioPin.select = select | (level << 7);
@@ -708,6 +743,8 @@
 {
 	u32 *ptr = Buffer;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	memset(Buffer, 0xff, Length);
 	while (Length > 0) {
 		if (Flags & DF_SWAP32)
@@ -735,6 +772,8 @@
 {
 	u8 val;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	do {
 		msleep(1);
 		spin_lock_irq(&chan->state_lock);
@@ -747,6 +786,8 @@
 {
 	struct SBufferHeader *Cur = chan->nextBuffer;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	do {
 		memset(&Cur->ngeneBuffer.SR, 0, sizeof(Cur->ngeneBuffer.SR));
 		if (chan->mode & NGENE_IO_TSOUT)
@@ -784,6 +825,8 @@
 	u16 BsSPI = ((stream & 1) ? 0x9800 : 0x9700);
 	u16 BsSDO = 0x9B00;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	/* down(&dev->stream_mutex); */
 	while (down_trylock(&dev->stream_mutex)) {
 		printk(KERN_INFO DEVICE_NAME ": SC locked\n");
@@ -954,6 +997,8 @@
 
 static void ngene_i2c_set_bus(struct ngene *dev, int bus)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	if (!(dev->card_info->i2c_access & 2))
 		return;
 	if (dev->i2c_current_bus == bus)
@@ -980,28 +1025,46 @@
 		(struct ngene_channel *)i2c_get_adapdata(adapter);
 	struct ngene *dev = chan->dev;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	down(&dev->i2c_switch_mutex);
+        dprintk (KERN_DEBUG DEVICE_NAME ": > ngene_i2x_set_bus \n");
 	ngene_i2c_set_bus(dev, chan->number);
+        dprintk (KERN_DEBUG DEVICE_NAME ": < ngene_i2x_set_bus \n");       
 
-	if (num == 2 && msg[1].flags & I2C_M_RD && !(msg[0].flags & I2C_M_RD))
+	if (num == 2 && msg[1].flags & I2C_M_RD && !(msg[0].flags & I2C_M_RD)) {
+                dprintk (KERN_DEBUG DEVICE_NAME "> : num = 2 ngene_command_i2c_read \n");              
 		if (!ngene_command_i2c_read(dev, msg[0].addr,
 					    msg[0].buf, msg[0].len,
-					    msg[1].buf, msg[1].len, 0))
-			goto done;
+					    msg[1].buf, msg[1].len, 0)) {
+                        dprintk (KERN_DEBUG DEVICE_NAME "<: ngene_command_i2c_read> ngene_i2x_set_bus \n");              
+ 			goto done;
+                }                     
+        }                     
 
-	if (num == 1 && !(msg[0].flags & I2C_M_RD))
+	if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
+                dprintk (KERN_DEBUG DEVICE_NAME ": num = 1 ngene_command_i2c_write \n");              
 		if (!ngene_command_i2c_write(dev, msg[0].addr,
-					     msg[0].buf, msg[0].len))
+					     msg[0].buf, msg[0].len)) {
+                        dprintk (KERN_DEBUG DEVICE_NAME ": num = 1 ngene_command_i2c_write \n");                                   
 			goto done;
-	if (num == 1 && (msg[0].flags & I2C_M_RD))
+                  }                     
+        }                     
+	if (num == 1 && (msg[0].flags & I2C_M_RD)) {
+                dprintk (KERN_DEBUG DEVICE_NAME ">: read  num = 1 ngene_command_i2c_write \n");              
 		if (!ngene_command_i2c_read(dev, msg[0].addr, NULL, 0,
-					    msg[0].buf, msg[0].len, 0))
+					    msg[0].buf, msg[0].len, 0)) {
+                        dprintk (KERN_DEBUG DEVICE_NAME "<: read  num = 1 ngene_command_i2c_write \n");                                                          
 			goto done;
+                }
+        }                     
 
 	up(&dev->i2c_switch_mutex);
+        dprintk (KERN_DEBUG DEVICE_NAME ": %s  failed \n", __func__);       
 	return -EIO;
 
 done:
+        dprintk (KERN_DEBUG DEVICE_NAME ": %s  succeeded \n", __func__);
 	up(&dev->i2c_switch_mutex);
 	return num;
 }
@@ -1042,6 +1105,8 @@
 
 static u32 ngene_i2c_functionality(struct i2c_adapter *adap)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	return I2C_FUNC_SMBUS_EMUL;
 }
 
@@ -1062,6 +1127,8 @@
 {
 	struct i2c_adapter *adap = &(dev->channel[dev_nr].i2c_adapter);
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	i2c_set_adapdata(adap, &(dev->channel[dev_nr]));
 #ifdef I2C_CLASS_TV_DIGITAL
 	adap->class = I2C_CLASS_TV_DIGITAL | I2C_CLASS_TV_ANALOG;
@@ -1739,6 +1806,8 @@
 
 static void swap_buffer(u32 *p, u32 len)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	while (len) {
 		*p = swab32(*p);
 		p++;
@@ -1783,6 +1852,8 @@
 {
 	struct ngene_channel *chan = priv;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 #if 0
 	printk(KERN_INFO DEVICE_NAME ": tsin %08x %02x %02x %02x %02x\n",
 	       len, ((u8 *) buf)[512 * 188], ((u8 *) buf)[0],
@@ -1805,6 +1876,8 @@
 	struct ngene *dev = chan->dev;
 	u32 alen;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	alen = dvb_ringbuffer_avail(&dev->tsout_rbuf);
 	alen -= alen % 188;
 
@@ -1837,6 +1910,8 @@
 	struct ngene *dev = chan->dev;
 	int ret;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	/*
 	printk(KERN_INFO DEVICE_NAME ": st %d\n", state);
 	msleep(100);
@@ -1910,6 +1985,8 @@
 {
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
 	struct ngene_channel *chan = dvbdmx->priv;
+
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
 #if 0
 	struct ngene *dev = chan->dev;
 
@@ -1952,6 +2029,8 @@
 {
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
 	struct ngene_channel *chan = dvbdmx->priv;
+
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
 #if 0
 	struct ngene *dev = chan->dev;
 
@@ -2220,6 +2299,8 @@
 				   int (*stop_feed)(struct dvb_demux_feed *),
 				   void *priv)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	dvbdemux->priv = priv;
 
 	dvbdemux->filternum = 256;
@@ -2241,6 +2322,8 @@
 {
 	int ret;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	dmxdev->filternum = 256;
 	dmxdev->demux = &dvbdemux->dmx;
 	dmxdev->capabilities = 0;
@@ -2348,6 +2431,8 @@
 	struct SBufferHeader *Cur = rb->Head;
 	u32 j;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	if (!Cur)
 		return;
 
@@ -2379,6 +2464,8 @@
 	int j;
 	struct SBufferHeader *Cur = tb->Head;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	if (!rb->Head)
 		return;
 	free_ringbuffer(dev, rb);
@@ -2395,6 +2482,8 @@
 	u32 i;
 	struct ngene_channel *chan;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	for (i = STREAM_VIDEOIN1; i < MAX_STREAM; i++) {
 		chan = &dev->channel[i];
 		free_idlebuffer(dev, &chan->TSIdleBuffer, &chan->TSRingBuffer);
@@ -2430,6 +2519,8 @@
 	u64 PARingBufferNext;
 	struct SBufferHeader *Cur, *Next;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	descr->Head = NULL;
 	descr->MemSize = 0;
 	descr->PAHead = 0;
@@ -2489,6 +2580,8 @@
 	struct SBufferHeader *Cur;
 	void *SCListMem;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	if (SCListMemSize < 4096)
 		SCListMemSize = 4096;
 
@@ -2594,6 +2687,9 @@
 	/* Point to first buffer entry */
 	struct SBufferHeader *Cur = pRingBuffer->Head;
 	int i;
+
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	/* Loop thru all buffer and set Buffer 2 pointers to TSIdlebuffer */
 	for (i = 0; i < n; i++) {
 		Cur->Buffer2 = pIdleBuffer->Head->Buffer1;
@@ -2716,6 +2812,8 @@
 {
 	int status = 0, i;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	dev->FWInterfaceBuffer = pci_alloc_consistent(dev->pci_dev, 4096,
 						     &dev->PAFWInterfaceBuffer);
 	if (!dev->FWInterfaceBuffer)
@@ -2805,6 +2903,8 @@
 
 static void ngene_release_buffers(struct ngene *dev)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	if (dev->iomem)
 		iounmap(dev->iomem);
 	free_common_buffers(dev);
@@ -2816,6 +2916,8 @@
 
 static int ngene_get_buffers(struct ngene *dev)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	if (AllocCommonBuffers(dev))
 		return -ENOMEM;
 	if (dev->card_info->io_type[4] & NGENE_IO_TSOUT) {
@@ -2849,6 +2951,8 @@
 {
 	int i;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	tasklet_init(&dev->event_tasklet, event_tasklet, (unsigned long)dev);
 
 	memset_io(dev->iomem + 0xc000, 0x00, 0x220);
@@ -2878,6 +2982,8 @@
 	char *fw_name;
 	int err, version;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	version = dev->card_info->fw_version;
 
 	switch (version) {
@@ -2922,6 +3028,8 @@
 
 static void ngene_stop(struct ngene *dev)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	down(&dev->cmd_mutex);
 	i2c_del_adapter(&(dev->channel[0].i2c_adapter));
 	i2c_del_adapter(&(dev->channel[1].i2c_adapter));
@@ -2940,6 +3048,8 @@
 	int stat;
 	int i;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	pci_set_master(dev->pci_dev);
 	ngene_init(dev);
 
@@ -3452,6 +3562,8 @@
 		chan->dev->card_info->tuner_config[chan->number];
 	struct stv6110x_devctl *ctl;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	ctl = dvb_attach(stv6110x_attach, chan->fe, tunerconf,
 			 &chan->i2c_adapter);
 	if (ctl == NULL) {
@@ -3569,6 +3681,8 @@
 	struct stv090x_config *feconf = (struct stv090x_config *)
 		chan->dev->card_info->fe_config[chan->number];
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	chan->fe = dvb_attach(stv090x_attach,
 			feconf,
 			&chan->i2c_adapter,
@@ -3600,6 +3714,8 @@
 	struct ngene_info *ni = dev->card_info;
 	int io = ni->io_type[chan->number];
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 #ifdef COMMAND_TIMEOUT_WORKAROUND
 	if (chan->running)
 		set_transfer(chan, 0);
@@ -3652,6 +3768,8 @@
 	struct ngene_info *ni = dev->card_info;
 	int io = ni->io_type[nr];
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	tasklet_init(&chan->demux_tasklet, demux_tasklet, (unsigned long)chan);
 	chan->users = 0;
 	chan->type = io;
@@ -3741,6 +3859,8 @@
 {
 	int i, j;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	for (i = 0; i < MAX_STREAM; i++) {
 		if (init_channel(&dev->channel[i]) < 0) {
 			for (j = i - 1; j >= 0; j--)
@@ -3760,6 +3880,8 @@
 	struct ngene *dev = (struct ngene *)pci_get_drvdata(pdev);
 	int i;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	tasklet_kill(&dev->event_tasklet);
 	for (i = MAX_STREAM - 1; i >= 0; i--)
 		release_channel(&dev->channel[i]);
@@ -3775,6 +3897,8 @@
 	struct ngene *dev;
 	int stat = 0;
 
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	if (pci_enable_device(pci_dev) < 0)
 		return -ENODEV;
 
@@ -4306,6 +4430,8 @@
 static pci_ers_result_t ngene_error_detected(struct pci_dev *dev,
 					     enum pci_channel_state state)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	printk(KERN_ERR DEVICE_NAME ": PCI error\n");
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
@@ -4316,6 +4442,8 @@
 
 static pci_ers_result_t ngene_link_reset(struct pci_dev *dev)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	printk(KERN_INFO DEVICE_NAME ": link reset\n");
 	return 0;
 }
@@ -4328,6 +4456,8 @@
 
 static void ngene_resume(struct pci_dev *dev)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	printk(KERN_INFO DEVICE_NAME ": resume\n");
 }
 
@@ -4353,6 +4483,8 @@
 
 static __init int module_init_ngene(void)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	printk(KERN_INFO
 	       "nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas\n");
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 15)
@@ -4364,6 +4496,8 @@
 
 static __exit void module_exit_ngene(void)
 {
+	dprintk (KERN_DEBUG DEVICE_NAME ": %s\n", __func__);
+
 	pci_unregister_driver(&ngene_pci_driver);
 }
 
Index: linux/drivers/media/dvb/dvb-core/dvb_frontend.c
===================================================================
--- linux/drivers/media/dvb/dvb-core/dvb_frontend.c	(revision 1)
+++ linux/drivers/media/dvb/dvb-core/dvb_frontend.c	(revision 5)
@@ -404,6 +404,7 @@
 		if (fe->ops.read_status)
 			fe->ops.read_status(fe, &s);
 		if (s != fepriv->status) {
+                        dprintk("dvb_frontend_swzigzag add_event frontend status");              
 			dvb_frontend_add_event(fe, s);
 			fepriv->status = s;
 		}
@@ -473,6 +474,7 @@
 		if (retval < 0) {
 			return;
 		} else if (retval) {
+                        dprintk(" OK, if we've run out of trials at the fast speed. -> Slow speed \n");              
 			/* OK, if we've run out of trials at the fast speed.
 			 * Drop back to slow for the _next_ attempt */
 			fepriv->state = FESTATE_SEARCHING_SLOW;
@@ -634,24 +636,35 @@
 				 */
 				if (fepriv->algo_status & DVBFE_ALGO_SEARCH_AGAIN) {
 					if (fe->ops.search) {
-						fepriv->algo_status = fe->ops.search(fe, &fepriv->parameters);
+                                            dprintk(">search, status\n");                                      
 						/* We did do a search as was requested, the flags are
 						 * now unset as well and has the flags wrt to search.
 						 */
+                                                fepriv->algo_status = fe->ops.search(fe, &fepriv->parameters);                                                 
+                                             dprintk("<search, status\n");                                      
+                                          
 					} else {
 						fepriv->algo_status &= ~DVBFE_ALGO_SEARCH_AGAIN;
 					}
 				}
 				/* Track the carrier if the search was successful */
 				if (fepriv->algo_status == DVBFE_ALGO_SEARCH_SUCCESS) {
-					if (fe->ops.track)
+					if (fe->ops.track) {
+                                           dprintk(">track, status\n");                                                                         
 						fe->ops.track(fe, &fepriv->parameters);
+                                           dprintk("<track, status\n");                                                                                                                   
+                                        }                                          
 				} else {
 					fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 					fepriv->delay = HZ / 2;
 				}
-				fe->ops.read_status(fe, &s);
+                                
+                                dprintk(">read status, status\n");
+				fe->ops.read_status(fe, &s);                                
+                                dprintk("<read status, status\n");
+                                
 				if (s != fepriv->status) {
+                                        dprintk("dvb_frontend_thread, status\n");
 					dvb_frontend_add_event(fe, s); /* update event list */
 					fepriv->status = s;
 					if (!(s & FE_HAS_LOCK)) {
@@ -1506,23 +1519,34 @@
 	if (fepriv->exit)
 		return -ENODEV;
 
+        dprintk(" not fepriv->exit %s (%d)\n", __func__, _IOC_NR(cmd));
+
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
 	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
 	     cmd == FE_DISEQC_RECV_SLAVE_REPLY))
 		return -EPERM;
 
+        dprintk(" >down interruptable %s (%d)\n", __func__, _IOC_NR(cmd));
 	if (down_interruptible (&fepriv->sem))
 		return -ERESTARTSYS;
+        dprintk(" <down interruptable %s (%d)\n", __func__, _IOC_NR(cmd));
 
-	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
+	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY)) {
+                dprintk(" dvb_frontend_ioctl_properties %s (%d)\n", __func__, _IOC_NR(cmd));        
 		err = dvb_frontend_ioctl_properties(inode, file, cmd, parg);
+        }              
 	else {
+                dprintk(" dvb_frontend_ioctl_legacy %s (%d)\n", __func__, _IOC_NR(cmd));        
 		fe->dtv_property_cache.state = DTV_UNDEFINED;
 		err = dvb_frontend_ioctl_legacy(inode, file, cmd, parg);
 	}
 
+        dprintk("> up %s (%d)\n", __func__, _IOC_NR(cmd));        
+
 	up(&fepriv->sem);
-	return err;
+        dprintk("<up %s (%d)\n", __func__, _IOC_NR(cmd));        
+
+        return err;
 }
 
 static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
@@ -1870,6 +1894,7 @@
 		fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 
 		dvb_frontend_wakeup(fe);
+                dprintk("dvb_frontend_add_event, before wakeup");                              
 		dvb_frontend_add_event(fe, 0);
 		fepriv->status = 0;
 		err = 0;
@@ -2018,17 +2043,24 @@
 	if ((file->f_flags & O_ACCMODE) != O_RDONLY)
 		fepriv->release_jiffies = jiffies;
 
-	ret = dvb_generic_release (inode, file);
+        ret = dvb_generic_release (inode, file);
 
 	if (dvbdev->users == -1) {
 		if (fepriv->exit == 1) {
+                        dprintk (" >Internal cleanup when closin DVB device  %s\n", __func__);       
 			fops_put(file->f_op);
 			file->f_op = NULL;
 			wake_up(&dvbdev->wait_queue);
+                        dprintk (" <Internal cleanup when closin DVB device  %s\n", __func__);       
 		}
-		if (fe->ops.ts_bus_ctrl)
+		if (fe->ops.ts_bus_ctrl) {
+                        dprintk (" >Invoke fe->ops.ts_bus_ctrl  %s\n", __func__);       
 			fe->ops.ts_bus_ctrl(fe, 0);
-	}
+                        dprintk (" >Invoke fe->ops.ts_bus_ctrl %s\n", __func__);                            
+                }                     
+	} else {
+                dprintk (" !NOT Close DVB device %s\n", __func__);       
+        }
 
 	return ret;
 }

--------------050201040901070003040101--
