Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:48224 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762060Ab3ECFql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 01:46:41 -0400
Received: by mail-ea0-f178.google.com with SMTP id m14so593631eaj.37
        for <linux-media@vger.kernel.org>; Thu, 02 May 2013 22:46:40 -0700 (PDT)
Date: Fri, 3 May 2013 08:47:55 +0300
From: Timo Teras <timo.teras@iki.fi>
To: Timo Teras <timo.teras@iki.fi>
Cc: Jon Arne =?ISO-8859-1?Q?J=F8rgensen?= <jonarne@jonarne.no>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130503084755.7c2f9cd1@vostro>
In-Reply-To: <20130502100456.2fdf42e0@vostro>
References: <20130325143647.3da1360f@redhat.com>
	<20130325194820.7c122834@vostro>
	<20130325153220.3e6dbfe5@redhat.com>
	<20130325211238.7c325d5e@vostro>
	<20130326102056.63b55916@vostro>
	<20130327161049.683483f8@vostro>
	<20130328105201.7bcc7388@vostro>
	<20130328094052.26b7f3f5@redhat.com>
	<20130328153556.0b58d1aa@vostro>
	<20130328165459.6231a5b1@vostro>
	<20130501171153.GA1377@dell.arpanet.local>
	<20130502100456.2fdf42e0@vostro>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2 May 2013 10:04:56 +0300
Timo Teras <timo.teras@iki.fi> wrote:

> On Wed, 1 May 2013 19:11:53 +0200
> Jon Arne Jørgensen <jonarne@jonarne.no> wrote:
> 
> > On Thu, Mar 28, 2013 at 04:54:59PM +0200, Timo Teras wrote:
> > > On Thu, 28 Mar 2013 15:35:56 +0200
> > > Timo Teras <timo.teras@iki.fi> wrote:
> > > 
> > > > On Thu, 28 Mar 2013 09:40:52 -0300
> > > > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > > > 
> > > > > Em Thu, 28 Mar 2013 10:52:01 +0200
> > > > > Timo Teras <timo.teras@iki.fi> escreveu:
> > > > > 
> > > > > > On Wed, 27 Mar 2013 16:10:49 +0200
> > > > > > Timo Teras <timo.teras@iki.fi> wrote:
> > > > > > 
> > > > > > > On Tue, 26 Mar 2013 10:20:56 +0200
> > > > > > > Timo Teras <timo.teras@iki.fi> wrote:
> > > > > > > 
> > > > > > > > I did manage to get decent traces with USBlyzer
> > > > > > > > evaluation version.
> > > > > > > 
> > > > > > > Nothing _that_ exciting there. Though, there's quite a bit
> > > > > > > of differences on certain register writes. I tried copying
> > > > > > > the changed parts, but did not really help.
> > > > > > > 
> > > > > > > Turning on saa7115 debug gave:
> > > > > > > 
> > > > > > > saa7115 1-0025: chip found @ 0x4a (ID 000000000000000)
> > > > > > > does not match a known saa711x chip.
> > > > > > 
> > > > > > Well, I just made saa7115.c ignore this ID check, and
> > > > > > defeault to saa7113 which is apparently the chip used.
> > > > > > 
> > > > > > And now it looks like things start to work a lot better.
> > > > > > 
> > > > > > Weird that the saa7113 chip is missing the ID string. Will
> > > > > > continue testing.
> > > > > 
> > > > > That could happen if saa7113 is behind some I2C bridge and
> > > > > when saa7113 is not found when the detection code is called.
> > > > 
> > > > Smells to me that they replaced the saa7113 with cheaper clone
> > > > that does not support the ID string.
> > > > 
> > > > Sounds like the same issue as:
> > > > http://www.spinics.net/lists/linux-media/msg57926.html
> > > > 
> > > > Additionally noted that something is not initialized right:
> > > > 
> > > > With PAL signal:
> > > > - there's some junk pixel in beginning of each line (looks like
> > > > pixes from previous lines end), sync issue?
> > > > - some junk lines at the end
> > > > - distorted colors when white and black change between pixels
> > > 
> > > Still have not figured out this one. Could be probably related to
> > > the saa7113 differences.
> > > 
> > > > With NTSC signal:
> > > > - unable to get a lock, and the whole picture looks garbled
> > > 
> > > NTSC started working after I removed all the saa711x writes to
> > > following registers:
> > >  R_14_ANAL_ADC_COMPAT_CNTL
> > >  R_15_VGATE_START_FID_CHG
> > >  R_16_VGATE_STOP
> > >  R_17_MISC_VGATE_CONF_AND_MSB
> > > 
> > 
> > This is the exact same behavior as i see on the gm7113c chip
> > in the stk1160, and the smi2021 devices.
> > 
> > See here:
> > http://www.spinics.net/lists/linux-media/msg63163.html
> 
> Thanks. I tested the patch and it detects it properly, and I get
> picture. However, there's problems synchronizing to my PAL signal. The
> picture "jumps" once in a while.
> 
> I guess the problem is in the init sequence. The W7 driver had
> following differences sequence changes compared to saa7113_init:
> -	R_02_INPUT_CNTL_1, 0xc2,
> +	R_02_INPUT_CNTL_1, 0xc0,
> -	R_04_INPUT_CNTL_3, 0x00,
> -	R_05_INPUT_CNTL_4, 0x00,
> -	R_06_H_SYNC_START, 0x89,
> +	R_06_H_SYNC_START, 0xeb,
> -	R_12_RT_SIGNAL_CNTL, 0x07,
> +	R_12_RT_SIGNAL_CNTL, 0xe7,
> -	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,
> -	R_15_VGATE_START_FID_CHG, 0x00,
> -	R_16_VGATE_STOP, 0x00,
> -	R_17_MISC_VGATE_CONF_AND_MSB, 0x00,
> 
> Seems that R_14 is filtered in your patch, but other changes are not
> taken into account.
> 
> Otherwise, the patchset looks good.

Not sure if part of the problems were related to the fact that I tried
this patch set first with 3.8.10. And that had problems.

Now I'm using 3.9.0 with  the above mentioned patchset, and my
additional patch (below). This seems to work nicely.

In any case it strongly looks like Terratec Grabby hwrev2 has also
the gm7113c chip; I still have not opened one to look, though.

--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -450,6 +450,28 @@
 /* ============== SAA7715 VIDEO templates (end) =======  */
 
 /* ============== GM7113C VIDEO templates =============  */
+static const unsigned char gm7113c_init[] = {
+	R_01_INC_DELAY, 0x08,
+	R_02_INPUT_CNTL_1, 0xc0,
+	R_03_INPUT_CNTL_2, 0x30,
+	R_06_H_SYNC_START, 0xeb,
+	R_07_H_SYNC_STOP, 0x0d,
+	R_08_SYNC_CNTL, 0x88,
+	R_09_LUMA_CNTL, 0x01,
+	R_0A_LUMA_BRIGHT_CNTL, 0x80,
+	R_0B_LUMA_CONTRAST_CNTL, 0x47,
+	R_0C_CHROMA_SAT_CNTL, 0x40,
+	R_0D_CHROMA_HUE_CNTL, 0x00,
+	R_0E_CHROMA_CNTL_1, 0x01,
+	R_0F_CHROMA_GAIN_CNTL, 0x2a,
+	R_10_CHROMA_CNTL_2, 0x08,
+	R_11_MODE_DELAY_CNTL, 0x0c,
+	R_12_RT_SIGNAL_CNTL, 0xe7,
+	R_13_RT_X_PORT_OUT_CNTL, 0x00,
+
+	0x00, 0x00
+};
+
 static const unsigned char gm7113c_cfg_60hz_video[] = {
 	R_08_SYNC_CNTL, 0x68,			/* 0xBO: auto
detection, 0x68 = NTSC */ R_0E_CHROMA_CNTL_1, 0x07,		/*
video autodetection is on */ @@ -1771,9 +1793,11 @@
 	case V4L2_IDENT_SAA7111A:
 		saa711x_writeregs(sd, saa7111_init);
 		break;
-	case V4L2_IDENT_GM7113C:
 	case V4L2_IDENT_SAA7113:
 		saa711x_writeregs(sd, saa7113_init);
+		break;
+	case V4L2_IDENT_GM7113C:
+		saa711x_writeregs(sd, gm7113c_init);
 		break;
 	default:
 		state->crystal_freq = SAA7115_FREQ_32_11_MHZ;

