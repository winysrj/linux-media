Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma01.mx.aol.com ([64.12.206.39]:51549 "EHLO
	imr-ma01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2DBCVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 22:21:46 -0400
Message-ID: <4F790D1B.4030702@netscape.net>
Date: Sun, 01 Apr 2012 23:21:15 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Steven Toth <stoth@kernellabs.com>
Subject: Re: Broken driver cx23885 mygica x8507
References: <4F77B099.7030109@netscape.net> <4F78A815.9050102@netscape.net>
In-Reply-To: <4F78A815.9050102@netscape.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

El 01/04/12 16:10, Alfredo Jesús Delaiti escribió:
> Hi all
>
> I found that this is the patch that makes no sound:
>
> http://git.kernellabs.com/?p=stoth/cx23885-hvr1850-fixups.git;a=commit;h=e187d0d51bcd0659eeac1d608284644ec8404239 
>
>
> I will try to find that lines are responsible.
>

Please refer to the patch mentioned above.

lines that leave without sound to the plate are these:

@@ -1086,6 +1232,23 @@ static int set_input(struct i2c_client *client, 
enum cx25840_video_input vid_inp
                 cx25840_write4(client, 0x8d0, 0x1f063870);
         }

+       if (is_cx2388x(state)) {
+               /* HVR1850 */
+               /* AUD_IO_CTRL - I2S Input, Parallel1*/
+               /*  - Channel 1 src - Parallel1 (Merlin out) */
+               /*  - Channel 2 src - Parallel2 (Merlin out) */
+               /*  - Channel 3 src - Parallel3 (Merlin AC97 out) */
+               /*  - I2S source and dir - Merlin, output */
+               cx25840_write4(client, 0x124, 0x100);
+
->+               if (!is_dif) {
->+                       /* Stop microcontroller if we don't need it
->+                        * to avoid audio popping on svideo/composite use.
->+                        */
->+                       cx25840_and_or(client, 0x803, ~0x10, 0x00);
->+               }
+       }
+
         return 0;
  }

Without these lines, have sound.



And the following line produces a vertical green bar on the right and 
the image is a bit narrow.
If I cancel that line, the image is colored with alternating bars and 
color distorted.

@@ -631,6 +654,37 @@ static void cx23885_initialize(struct i2c_client 
*client)
         /* Disable and clear audio interrupts - we don't use them */
         cx25840_write(client, CX25840_AUD_INT_CTRL_REG, 0xff);
         cx25840_write(client, CX25840_AUD_INT_STAT_REG, 0xff);
+
+       /* CC raw enable */
+       /*  - VIP 1.1 control codes - 10bit, blue field enable.
+        *  - enable raw data during vertical blanking.
+        *  - enable ancillary Data insertion for 656 or VIP.
+        */
->+       cx25840_write4(client, 0x404, 0x0010253e);


Thanks,

Alfredo



-- 
Dona tu voz
http://www.voxforge.org/es

