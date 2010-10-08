Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:9145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797Ab0JHVQL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 17:16:11 -0400
Date: Fri, 8 Oct 2010 17:16:01 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net
Cc: Joris van Rantwijk <jorispubl@xs4all.nl>
Subject: [PATCH 2/2] staging/lirc: ioctl portability fixups
Message-ID: <20101008211601.GG5165@redhat.com>
References: <20101008211235.GF5165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008211235.GF5165@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/lirc/lirc_it87.c     |   17 ++++++++---------
 drivers/staging/lirc/lirc_ite8709.c  |    6 +++---
 drivers/staging/lirc/lirc_parallel.c |   32 ++++++++++++++++----------------
 drivers/staging/lirc/lirc_serial.c   |   21 ++++++++++-----------
 drivers/staging/lirc/lirc_sir.c      |   21 ++++++++++-----------
 5 files changed, 47 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/lirc/lirc_it87.c b/drivers/staging/lirc/lirc_it87.c
index ec11c0e..7d1b427 100644
--- a/drivers/staging/lirc/lirc_it87.c
+++ b/drivers/staging/lirc/lirc_it87.c
@@ -239,8 +239,7 @@ static ssize_t lirc_write(struct file *file, const char *buf,
 static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	int retval = 0;
-	unsigned long value = 0;
-	unsigned int ivalue;
+	__u32 value = 0;
 	unsigned long hw_flags;
 
 	if (cmd == LIRC_GET_FEATURES)
@@ -256,24 +255,24 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case LIRC_GET_FEATURES:
 	case LIRC_GET_SEND_MODE:
 	case LIRC_GET_REC_MODE:
-		retval = put_user(value, (unsigned long *) arg);
+		retval = put_user(value, (__u32 *) arg);
 		break;
 
 	case LIRC_SET_SEND_MODE:
 	case LIRC_SET_REC_MODE:
-		retval = get_user(value, (unsigned long *) arg);
+		retval = get_user(value, (__u32 *) arg);
 		break;
 
 	case LIRC_SET_SEND_CARRIER:
-		retval = get_user(ivalue, (unsigned int *) arg);
+		retval = get_user(value, (__u32 *) arg);
 		if (retval)
 			return retval;
-		ivalue /= 1000;
-		if (ivalue > IT87_CIR_FREQ_MAX ||
-		    ivalue < IT87_CIR_FREQ_MIN)
+		value /= 1000;
+		if (value > IT87_CIR_FREQ_MAX ||
+		    value < IT87_CIR_FREQ_MIN)
 			return -EINVAL;
 
-		it87_freq = ivalue;
+		it87_freq = value;
 
 		spin_lock_irqsave(&hardware_lock, hw_flags);
 		outb(((inb(io + IT87_CIR_TCR2) & IT87_CIR_TCR2_TXMPW) |
diff --git a/drivers/staging/lirc/lirc_ite8709.c b/drivers/staging/lirc/lirc_ite8709.c
index 9352f45..cb20cfd 100644
--- a/drivers/staging/lirc/lirc_ite8709.c
+++ b/drivers/staging/lirc/lirc_ite8709.c
@@ -102,8 +102,8 @@ struct ite8709_device {
 	int io;
 	int irq;
 	spinlock_t hardware_lock;
-	unsigned long long acc_pulse;
-	unsigned long long acc_space;
+	__u64 acc_pulse;
+	__u64 acc_space;
 	char lastbit;
 	struct timeval last_tv;
 	struct lirc_driver driver;
@@ -220,7 +220,7 @@ static void ite8709_set_use_dec(void *data)
 }
 
 static void ite8709_add_read_queue(struct ite8709_device *dev, int flag,
-					unsigned long long val)
+				   __u64 val)
 {
 	int value;
 
diff --git a/drivers/staging/lirc/lirc_parallel.c b/drivers/staging/lirc/lirc_parallel.c
index 6da4a8c..be3d60d 100644
--- a/drivers/staging/lirc/lirc_parallel.c
+++ b/drivers/staging/lirc/lirc_parallel.c
@@ -301,9 +301,9 @@ static void irq_handler(void *blah)
 
 	if (signal != 0) {
 		/* ajust value to usecs */
-		unsigned long long helper;
+		__u64 helper;
 
-		helper = ((unsigned long long) signal)*1000000;
+		helper = ((__u64) signal)*1000000;
 		do_div(helper, timer);
 		signal = (long) helper;
 
@@ -404,9 +404,9 @@ static ssize_t lirc_write(struct file *filep, const char *buf, size_t n,
 
 	/* adjust values from usecs */
 	for (i = 0; i < count; i++) {
-		unsigned long long helper;
+		__u64 helper;
 
-		helper = ((unsigned long long) wbuf[i])*timer;
+		helper = ((__u64) wbuf[i])*timer;
 		do_div(helper, 1000000);
 		wbuf[i] = (int) helper;
 	}
@@ -464,48 +464,48 @@ static unsigned int lirc_poll(struct file *file, poll_table *wait)
 static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	int result;
-	unsigned long features = LIRC_CAN_SET_TRANSMITTER_MASK |
-				 LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2;
-	unsigned long mode;
-	unsigned int ivalue;
+	__u32 features = LIRC_CAN_SET_TRANSMITTER_MASK |
+			 LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2;
+	__u32 mode;
+	__u32 value;
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
-		result = put_user(features, (unsigned long *) arg);
+		result = put_user(features, (__u32 *) arg);
 		if (result)
 			return result;
 		break;
 	case LIRC_GET_SEND_MODE:
-		result = put_user(LIRC_MODE_PULSE, (unsigned long *) arg);
+		result = put_user(LIRC_MODE_PULSE, (__u32 *) arg);
 		if (result)
 			return result;
 		break;
 	case LIRC_GET_REC_MODE:
-		result = put_user(LIRC_MODE_MODE2, (unsigned long *) arg);
+		result = put_user(LIRC_MODE_MODE2, (__u32 *) arg);
 		if (result)
 			return result;
 		break;
 	case LIRC_SET_SEND_MODE:
-		result = get_user(mode, (unsigned long *) arg);
+		result = get_user(mode, (__u32 *) arg);
 		if (result)
 			return result;
 		if (mode != LIRC_MODE_PULSE)
 			return -EINVAL;
 		break;
 	case LIRC_SET_REC_MODE:
-		result = get_user(mode, (unsigned long *) arg);
+		result = get_user(mode, (__u32 *) arg);
 		if (result)
 			return result;
 		if (mode != LIRC_MODE_MODE2)
 			return -ENOSYS;
 		break;
 	case LIRC_SET_TRANSMITTER_MASK:
-		result = get_user(ivalue, (unsigned int *) arg);
+		result = get_user(value, (__u32 *) arg);
 		if (result)
 			return result;
-		if ((ivalue & LIRC_PARALLEL_TRANSMITTER_MASK) != ivalue)
+		if ((value & LIRC_PARALLEL_TRANSMITTER_MASK) != value)
 			return LIRC_PARALLEL_MAX_TRANSMITTERS;
-		tx_mask = ivalue;
+		tx_mask = value;
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/lirc/lirc_serial.c
index 9456f8e..02906b4 100644
--- a/drivers/staging/lirc/lirc_serial.c
+++ b/drivers/staging/lirc/lirc_serial.c
@@ -372,7 +372,7 @@ static unsigned long conv_us_to_clocks;
 static int init_timing_params(unsigned int new_duty_cycle,
 		unsigned int new_freq)
 {
-	unsigned long long loops_per_sec, work;
+	__u64 loops_per_sec, work;
 
 	duty_cycle = new_duty_cycle;
 	freq = new_freq;
@@ -987,8 +987,7 @@ static ssize_t lirc_write(struct file *file, const char *buf,
 static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	int result;
-	unsigned long value;
-	unsigned int ivalue;
+	__u32 value;
 
 	switch (cmd) {
 	case LIRC_GET_SEND_MODE:
@@ -997,7 +996,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 		result = put_user(LIRC_SEND2MODE
 				  (hardware[type].features&LIRC_CAN_SEND_MASK),
-				  (unsigned long *) arg);
+				  (__u32 *) arg);
 		if (result)
 			return result;
 		break;
@@ -1006,7 +1005,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if (!(hardware[type].features&LIRC_CAN_SEND_MASK))
 			return -ENOIOCTLCMD;
 
-		result = get_user(value, (unsigned long *) arg);
+		result = get_user(value, (__u32 *) arg);
 		if (result)
 			return result;
 		/* only LIRC_MODE_PULSE supported */
@@ -1023,12 +1022,12 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if (!(hardware[type].features&LIRC_CAN_SET_SEND_DUTY_CYCLE))
 			return -ENOIOCTLCMD;
 
-		result = get_user(ivalue, (unsigned int *) arg);
+		result = get_user(value, (__u32 *) arg);
 		if (result)
 			return result;
-		if (ivalue <= 0 || ivalue > 100)
+		if (value <= 0 || value > 100)
 			return -EINVAL;
-		return init_timing_params(ivalue, freq);
+		return init_timing_params(value, freq);
 		break;
 
 	case LIRC_SET_SEND_CARRIER:
@@ -1036,12 +1035,12 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if (!(hardware[type].features&LIRC_CAN_SET_SEND_CARRIER))
 			return -ENOIOCTLCMD;
 
-		result = get_user(ivalue, (unsigned int *) arg);
+		result = get_user(value, (__u32 *) arg);
 		if (result)
 			return result;
-		if (ivalue > 500000 || ivalue < 20000)
+		if (value > 500000 || value < 20000)
 			return -EINVAL;
-		return init_timing_params(duty_cycle, ivalue);
+		return init_timing_params(duty_cycle, value);
 		break;
 
 	default:
diff --git a/drivers/staging/lirc/lirc_sir.c b/drivers/staging/lirc/lirc_sir.c
index eb08fa7..10354f9 100644
--- a/drivers/staging/lirc/lirc_sir.c
+++ b/drivers/staging/lirc/lirc_sir.c
@@ -336,9 +336,8 @@ static ssize_t lirc_write(struct file *file, const char *buf, size_t n,
 static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	int retval = 0;
-	unsigned long value = 0;
+	__u32 value = 0;
 #ifdef LIRC_ON_SA1100
-	unsigned int ivalue;
 
 	if (cmd == LIRC_GET_FEATURES)
 		value = LIRC_CAN_SEND_PULSE |
@@ -362,22 +361,22 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case LIRC_GET_FEATURES:
 	case LIRC_GET_SEND_MODE:
 	case LIRC_GET_REC_MODE:
-		retval = put_user(value, (unsigned long *) arg);
+		retval = put_user(value, (__u32 *) arg);
 		break;
 
 	case LIRC_SET_SEND_MODE:
 	case LIRC_SET_REC_MODE:
-		retval = get_user(value, (unsigned long *) arg);
+		retval = get_user(value, (__u32 *) arg);
 		break;
 #ifdef LIRC_ON_SA1100
 	case LIRC_SET_SEND_DUTY_CYCLE:
-		retval = get_user(ivalue, (unsigned int *) arg);
+		retval = get_user(value, (__u32 *) arg);
 		if (retval)
 			return retval;
-		if (ivalue <= 0 || ivalue > 100)
+		if (value <= 0 || value > 100)
 			return -EINVAL;
-		/* (ivalue/100)*(1000000/freq) */
-		duty_cycle = ivalue;
+		/* (value/100)*(1000000/freq) */
+		duty_cycle = value;
 		pulse_width = (unsigned long) duty_cycle*10000/freq;
 		space_width = (unsigned long) 1000000L/freq-pulse_width;
 		if (pulse_width >= LIRC_ON_SA1100_TRANSMITTER_LATENCY)
@@ -386,12 +385,12 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			space_width -= LIRC_ON_SA1100_TRANSMITTER_LATENCY;
 		break;
 	case LIRC_SET_SEND_CARRIER:
-		retval = get_user(ivalue, (unsigned int *) arg);
+		retval = get_user(value, (__u32 *) arg);
 		if (retval)
 			return retval;
-		if (ivalue > 500000 || ivalue < 20000)
+		if (value > 500000 || value < 20000)
 			return -EINVAL;
-		freq = ivalue;
+		freq = value;
 		pulse_width = (unsigned long) duty_cycle*10000/freq;
 		space_width = (unsigned long) 1000000L/freq-pulse_width;
 		if (pulse_width >= LIRC_ON_SA1100_TRANSMITTER_LATENCY)
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

