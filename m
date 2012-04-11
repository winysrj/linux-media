Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma04.mx.aol.com ([64.12.206.42]:61841 "EHLO
	imr-ma04.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2DKSbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 14:31:36 -0400
Message-ID: <4F85CDE2.3050209@netscape.net>
Date: Wed, 11 Apr 2012 15:30:58 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Steven Toth <stoth@kernellabs.com>
Subject: Patch Broken driver cx23885 mygica x8507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

I found that this is the patch that makes no sound and deformation image on mygica x8507:

http://git.kernellabs.com/?p=stoth/cx23885-hvr1850-fixups.git;a=commit;h=e187d0d51bcd0659eeac1d608284644ec8404239

I will try to find that lines are responsible.


Please refer to the patch mentioned above.

lines that leave without sound to the card are these:

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
->+                        * to avoid audio popping on svideo/compositeuse.
->+                        */
->+                       cx25840_and_or(client, 0x803, ~0x10, 0x00);
->+               }
+       }
+
         return 0;
  }

Without these lines, have sound.



And the following line produces a vertical green bar on the right and
the image is a bit narrow (maybe  taken as  an  image  of 702  pixel).
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



With kernel 3.0, 3.1 and 3.2 the card worked fine.


Thanks,

Alfredo



-- 
Dona tu voz
http://www.voxforge.org/es

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

