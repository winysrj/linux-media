Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55168
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754301AbcJUKZ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 06:25:27 -0400
Date: Fri, 21 Oct 2016 08:25:20 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kevin Fitch <kfitch42@gmail.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH v2 54/58] i2c: don't break long lines
Message-ID: <20161021082520.5472624c@vento.lan>
In-Reply-To: <4116505.KJG2renCst@avalon>
References: <cover.1476822924.git.mchehab@s-opensource.com>
        <33d775f4e173dd72f82c190bfd2e542749a5481c.1476822925.git.mchehab@s-opensource.com>
        <4116505.KJG2renCst@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 20 Oct 2016 13:46:08 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Tuesday 18 Oct 2016 18:46:06 Mauro Carvalho Chehab wrote:
> > Due to the 80-cols restrictions, and latter due to checkpatch
> > warnings, several strings were broken into multiple lines. This
> > is not considered a good practice anymore, as it makes harder
> > to grep for strings at the source code.
> > 
> > As we're right now fixing other drivers due to KERN_CONT, we need
> > to be able to identify what printk strings don't end with a "\n".
> > It is a way easier to detect those if we don't break long lines.
> > 
> > So, join those continuation lines.
> > 
> > The patch was generated via the script below, and manually
> > adjusted if needed.
> > 
> > </script>
> > use Text::Tabs;
> > while (<>) {
> > 	if ($next ne "") {
> > 		$c=$_;
> > 		if ($c =~ /^\s+\"(.*)/) {
> > 			$c2=$1;
> > 			$next =~ s/\"\n$//;
> > 			$n = expand($next);
> > 			$funpos = index($n, '(');
> > 			$pos = index($c2, '",');
> > 			if ($funpos && $pos > 0) {
> > 				$s1 = substr $c2, 0, $pos + 2;
> > 				$s2 = ' ' x ($funpos + 1) . substr $c2,   
> $pos + 2;
> > 				$s2 =~ s/^\s+//;
> > 
> > 				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne   
> "");
> > 
> > 				print unexpand("$next$s1\n");
> > 				print unexpand("$s2\n") if ($s2 ne "");
> > 			} else {
> > 				print "$next$c2\n";
> > 			}
> > 			$next="";
> > 			next;
> > 		} else {
> > 			print $next;
> > 		}
> > 		$next="";
> > 	} else {
> > 		if (m/\"$/) {
> > 			if (!m/\\n\"$/) {
> > 				$next=$_;
> > 				next;
> > 			}
> > 		}
> > 	}
> > 	print $_;
> > }
> > </script>
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/i2c/as3645a.c          | 13 +++++++------
> >  drivers/media/i2c/msp3400-kthreads.c |  4 ++--
> >  drivers/media/i2c/mt9m032.c          |  5 +++--
> >  drivers/media/i2c/mt9p031.c          |  5 +++--
> >  drivers/media/i2c/saa7115.c          | 18 +++++++++++-------
> >  drivers/media/i2c/saa717x.c          |  4 ++--
> >  drivers/media/i2c/tvp5150.c          | 14 ++++++++------
> >  drivers/media/i2c/tvp7002.c          |  6 +++---
> >  drivers/media/i2c/upd64083.c         |  4 +---
> >  9 files changed, 40 insertions(+), 33 deletions(-)  
> 
> [snip]
> 
> > diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> > index 58062b41c923..3b341a9da004 100644
> > --- a/drivers/media/i2c/saa7115.c
> > +++ b/drivers/media/i2c/saa7115.c  
> 
> [snip]
> 
> 
> > @@ -1538,8 +1537,10 @@ static int saa711x_log_status(struct v4l2_subdev *sd)
> > /* status for the saa7114 */
> >  		reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
> >  		signalOk = (reg1f & 0xc1) == 0x81;
> > -		v4l2_info(sd, "Video signal:    %s\n", signalOk ? "ok" :   
> "bad");
> 
> No need to change this one, if fits on a single line.

I know, but visually, it looked better to make the same indentation
as on the frequency print below.

> 
> > -		v4l2_info(sd, "Frequency:       %s\n", (reg1f & 0x20) ? "60   
> Hz" : "50
> > Hz"); +		v4l2_info(sd, "Video signal:    %s\n",
> > +			  signalOk ? "ok" : "bad");
> > +		v4l2_info(sd, "Frequency:       %s\n",
> > +			  (reg1f & 0x20) ? "60 Hz" : "50 Hz");
> >  		return 0;
> >  	}
> >   
> 
> [snip]
> 
> > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > index 4740da39d698..b3a9580ef1e4 100644
> > --- a/drivers/media/i2c/tvp5150.c
> > +++ b/drivers/media/i2c/tvp5150.c
> > @@ -280,10 +280,10 @@ static inline void tvp5150_selmux(struct v4l2_subdev
> > *sd) break;
> >  	}
> > 
> > -	v4l2_dbg(1, debug, sd, "Selecting video route: route input=%i,   
> output=%i "
> > -			"=> tvp5150 input=%i, opmode=%i\n",  
> > -			decoder->input, decoder->output,
> > -			input, opmode);
> > +	v4l2_dbg(1, debug, sd,
> > +		 "Selecting video route: route input=%i, output=%i =>   
> tvp5150 input=%i, opmode=%i\n",
> > +		 decoder->input, decoder->output,
> > +		 input, opmode);  
> 
> The three arguments can fit on a single line.
> 
> > 
> >  	tvp5150_write(sd, TVP5150_OP_MODE_CTL, opmode);
> >  	tvp5150_write(sd, TVP5150_VD_IN_SRC_SEL_1, input);
> > @@ -649,7 +649,8 @@ static int tvp5150_set_vbi(struct v4l2_subdev *sd,
> >  	int pos=0;
> > 
> >  	if (std == V4L2_STD_ALL) {
> > -		v4l2_err(sd, "VBI can't be configured without knowing number   
> of
> > lines\n");
> > +		v4l2_err(sd,
> > +			 "VBI can't be configured without knowing number of   
> lines\n");
> 
> I'm quite doubtful that this particular change improves readability :-)

I have another patch pending on my tree getting rid of v4l2_err().
with that, the first argument becomes bigger:

-               v4l2_err(sd,
-                        "VBI can't be configured without knowing number of lines\n");
+               dev_err(sd->dev,
+                       "VBI can't be configured without knowing number of lines\n");

So, I prefer to keep the string on a separate line.

> 
> >  		return 0;
> >  	} else if (std & V4L2_STD_625_50) {
> >  		/* Don't follow NTSC Line number convension */
> > @@ -697,7 +698,8 @@ static int tvp5150_get_vbi(struct v4l2_subdev *sd,
> >  	int i, ret = 0;
> > 
> >  	if (std == V4L2_STD_ALL) {
> > -		v4l2_err(sd, "VBI can't be configured without knowing number   
> of
> > lines\n");
> > +		v4l2_err(sd,
> > +			 "VBI can't be configured without knowing number of   
> lines\n");
> 
> Ditto.

Same as above.

> >  		return 0;
> >  	} else if (std & V4L2_STD_625_50) {
> >  		/* Don't follow NTSC Line number convension */  
> 
> [snip]
> 

Patch addressing the comments I agreed is attached.

Thanks,
Mauro




--

[PATCH] i2c: don't break long lines

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
index 2e90e4094b79..d2f56014a150 100644
--- a/drivers/media/i2c/as3645a.c
+++ b/drivers/media/i2c/as3645a.c
@@ -299,8 +299,8 @@ static int as3645a_read_fault(struct as3645a *flash)
 		dev_dbg(&client->dev, "Inductor Peak limit fault\n");
 
 	if (rval & AS_FAULT_INFO_INDICATOR_LED)
-		dev_dbg(&client->dev, "Indicator LED fault: "
-			"Short circuit or open loop\n");
+		dev_dbg(&client->dev,
+			"Indicator LED fault: Short circuit or open loop\n");
 
 	dev_dbg(&client->dev, "%u connected LEDs\n",
 		rval & AS_FAULT_INFO_LED_AMOUNT ? 2 : 1);
@@ -315,8 +315,8 @@ static int as3645a_read_fault(struct as3645a *flash)
 		dev_dbg(&client->dev, "Short circuit fault\n");
 
 	if (rval & AS_FAULT_INFO_OVER_VOLTAGE)
-		dev_dbg(&client->dev, "Over voltage fault: "
-			"Indicates missing capacitor or open connection\n");
+		dev_dbg(&client->dev,
+			"Over voltage fault: Indicates missing capacitor or open connection\n");
 
 	return rval;
 }
@@ -588,8 +588,9 @@ static int as3645a_registered(struct v4l2_subdev *sd)
 
 	/* Verify the chip model and version. */
 	if (model != 0x01 || rfu != 0x00) {
-		dev_err(&client->dev, "AS3645A not detected "
-			"(model %d rfu %d)\n", model, rfu);
+		dev_err(&client->dev,
+			"AS3645A not detected (model %d rfu %d)\n",
+			model, rfu);
 		rval = -ENODEV;
 		goto power_off;
 	}
diff --git a/drivers/media/i2c/msp3400-kthreads.c b/drivers/media/i2c/msp3400-kthreads.c
index 17120804fab7..2f72bba64d99 100644
--- a/drivers/media/i2c/msp3400-kthreads.c
+++ b/drivers/media/i2c/msp3400-kthreads.c
@@ -775,8 +775,8 @@ int msp3410d_thread(void *data)
 		if (msp_amsound && !state->radio &&
 		    (state->v4l2_std & V4L2_STD_SECAM) && (val != 0x0009)) {
 			/* autodetection has failed, let backup */
-			v4l_dbg(1, msp_debug, client, "autodetection failed,"
-				" switching to backup standard: %s (0x%04x)\n",
+			v4l_dbg(1, msp_debug, client,
+				"autodetection failed, switching to backup standard: %s (0x%04x)\n",
 				msp_stdlist[8].name ?
 					msp_stdlist[8].name : "unknown", val);
 			state->std = val = 0x0009;
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index da076796999e..83c1d67d72c2 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -746,8 +746,9 @@ static int mt9m032_probe(struct i2c_client *client,
 
 	chip_version = mt9m032_read(client, MT9M032_CHIP_VERSION);
 	if (chip_version != MT9M032_CHIP_VERSION_VALUE) {
-		dev_err(&client->dev, "MT9M032 not detected, wrong version "
-			"0x%04x\n", chip_version);
+		dev_err(&client->dev,
+			"MT9M032 not detected, wrong version 0x%04x\n",
+			chip_version);
 		ret = -ENODEV;
 		goto error_sensor;
 	}
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 237737fec09c..86afe1125c91 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -929,8 +929,9 @@ static int mt9p031_registered(struct v4l2_subdev *subdev)
 	mt9p031_power_off(mt9p031);
 
 	if (data != MT9P031_CHIP_VERSION_VALUE) {
-		dev_err(&client->dev, "MT9P031 not detected, wrong version "
-			"0x%04x\n", data);
+		dev_err(&client->dev,
+			"MT9P031 not detected, wrong version 0x%04x\n",
+			data);
 		return -ENODEV;
 	}
 
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 58062b41c923..3b341a9da004 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -53,8 +53,7 @@
 #define VRES_60HZ	(480+16)
 
 MODULE_DESCRIPTION("Philips SAA7111/SAA7113/SAA7114/SAA7115/SAA7118 video decoder driver");
-MODULE_AUTHOR(  "Maxim Yevtyushkin, Kevin Thayer, Chris Kennedy, "
-		"Hans Verkuil, Mauro Carvalho Chehab");
+MODULE_AUTHOR("Maxim Yevtyushkin, Kevin Thayer, Chris Kennedy, Hans Verkuil, Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
 
 static bool debug;
@@ -1538,8 +1537,10 @@ static int saa711x_log_status(struct v4l2_subdev *sd)
 		/* status for the saa7114 */
 		reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
 		signalOk = (reg1f & 0xc1) == 0x81;
-		v4l2_info(sd, "Video signal:    %s\n", signalOk ? "ok" : "bad");
-		v4l2_info(sd, "Frequency:       %s\n", (reg1f & 0x20) ? "60 Hz" : "50 Hz");
+		v4l2_info(sd, "Video signal:    %s\n",
+			  signalOk ? "ok" : "bad");
+		v4l2_info(sd, "Frequency:       %s\n",
+			  (reg1f & 0x20) ? "60 Hz" : "50 Hz");
 		return 0;
 	}
 
@@ -1551,11 +1552,14 @@ static int saa711x_log_status(struct v4l2_subdev *sd)
 	vcr = !(reg1f & 0x10);
 
 	if (state->input >= 6)
-		v4l2_info(sd, "Input:           S-Video %d\n", state->input - 6);
+		v4l2_info(sd, "Input:           S-Video %d\n",
+			  state->input - 6);
 	else
 		v4l2_info(sd, "Input:           Composite %d\n", state->input);
-	v4l2_info(sd, "Video signal:    %s\n", signalOk ? (vcr ? "VCR" : "broadcast/DVD") : "bad");
-	v4l2_info(sd, "Frequency:       %s\n", (reg1f & 0x20) ? "60 Hz" : "50 Hz");
+	v4l2_info(sd, "Video signal:    %s\n",
+		  signalOk ? (vcr ? "VCR" : "broadcast/DVD") : "bad");
+	v4l2_info(sd, "Frequency:       %s\n",
+		  (reg1f & 0x20) ? "60 Hz" : "50 Hz");
 
 	switch (reg1e & 0x03) {
 	case 1:
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 1baca37f3eb6..e67aeec46644 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -735,8 +735,8 @@ static void get_inf_dev_status(struct v4l2_subdev *sd,
 		reg_data3, stdres[reg_data3 & 0x1f],
 		(reg_data3 & 0x000020) ? ",stereo" : "",
 		(reg_data3 & 0x000040) ? ",dual"   : "");
-	v4l2_dbg(1, debug, sd, "detailed status: "
-		"%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s\n",
+	v4l2_dbg(1, debug, sd,
+		 "detailed status: %s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s\n",
 		(reg_data3 & 0x000080) ? " A2/EIAJ pilot tone "     : "",
 		(reg_data3 & 0x000100) ? " A2/EIAJ dual "           : "",
 		(reg_data3 & 0x000200) ? " A2/EIAJ stereo "         : "",
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 4740da39d698..b3a9580ef1e4 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -280,10 +280,10 @@ static inline void tvp5150_selmux(struct v4l2_subdev *sd)
 		break;
 	}
 
-	v4l2_dbg(1, debug, sd, "Selecting video route: route input=%i, output=%i "
-			"=> tvp5150 input=%i, opmode=%i\n",
-			decoder->input, decoder->output,
-			input, opmode);
+	v4l2_dbg(1, debug, sd,
+		 "Selecting video route: route input=%i, output=%i => tvp5150 input=%i, opmode=%i\n",
+		 decoder->input, decoder->output,
+		 input, opmode);
 
 	tvp5150_write(sd, TVP5150_OP_MODE_CTL, opmode);
 	tvp5150_write(sd, TVP5150_VD_IN_SRC_SEL_1, input);
@@ -649,7 +649,8 @@ static int tvp5150_set_vbi(struct v4l2_subdev *sd,
 	int pos=0;
 
 	if (std == V4L2_STD_ALL) {
-		v4l2_err(sd, "VBI can't be configured without knowing number of lines\n");
+		v4l2_err(sd,
+			 "VBI can't be configured without knowing number of lines\n");
 		return 0;
 	} else if (std & V4L2_STD_625_50) {
 		/* Don't follow NTSC Line number convension */
@@ -697,7 +698,8 @@ static int tvp5150_get_vbi(struct v4l2_subdev *sd,
 	int i, ret = 0;
 
 	if (std == V4L2_STD_ALL) {
-		v4l2_err(sd, "VBI can't be configured without knowing number of lines\n");
+		v4l2_err(sd,
+			 "VBI can't be configured without knowing number of lines\n");
 		return 0;
 	} else if (std & V4L2_STD_625_50) {
 		/* Don't follow NTSC Line number convension */
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 3dc3341c4896..c11b49f10de8 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -663,7 +663,7 @@ static int tvp7002_query_dv(struct v4l2_subdev *sd, int *index)
 
 	if (*index == NUM_TIMINGS) {
 		v4l2_dbg(1, debug, sd, "detection failed: lpf = %x, cpl = %x\n",
-								lpfr, cpln);
+			 lpfr, cpln);
 		return -ENOLINK;
 	}
 
@@ -1057,8 +1057,8 @@ static int tvp7002_remove(struct i2c_client *c)
 	struct v4l2_subdev *sd = i2c_get_clientdata(c);
 	struct tvp7002 *device = to_tvp7002(sd);
 
-	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapter"
-				"on address 0x%x\n", c->addr);
+	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapter on address 0x%x\n",
+		 c->addr);
 	v4l2_async_unregister_subdev(&device->sd);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&device->sd.entity);
diff --git a/drivers/media/i2c/upd64083.c b/drivers/media/i2c/upd64083.c
index 77f122f2e3c9..519ad0e97fec 100644
--- a/drivers/media/i2c/upd64083.c
+++ b/drivers/media/i2c/upd64083.c
@@ -139,9 +139,7 @@ static int upd64083_log_status(struct v4l2_subdev *sd)
 	u8 buf[7];
 
 	i2c_master_recv(client, buf, 7);
-	v4l2_info(sd, "Status: SA00=%02x SA01=%02x SA02=%02x SA03=%02x "
-		      "SA04=%02x SA05=%02x SA06=%02x\n",
-		buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6]);
+	v4l2_info(sd, "Status: SA00 to SA07 registers %*ph\n", 7, buf);
 	return 0;
 }
 


