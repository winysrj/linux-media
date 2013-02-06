Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56769 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3BFL4d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 06:56:33 -0500
Received: by mail-wi0-f174.google.com with SMTP id hi8so4953958wib.1
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 03:56:32 -0800 (PST)
Message-ID: <511244ED.5040607@googlemail.com>
Date: Wed, 06 Feb 2013 11:56:29 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: WinTV-HVR-1400: scandvb (and kaffeine) fails to find any channels
References: <510A9A1E.9090801@googlemail.com> <CAGoCfiwQNBv1r5KgCzYFf7X1hP--fyQpqvRHCDtKFcSxwbJWpA@mail.gmail.com> <510ADB2F.4080901@googlemail.com> <510AF800.2090607@googlemail.com> <510BACD5.2070406@googlemail.com> <510BCE2F.1070100@googlemail.com> <CAGoCfix8XDzcgtCiL39Qna_QBx_=ZEKyMknzbsS3iTXS04_a8A@mail.gmail.com> <510C2DA2.7020000@googlemail.com> <CAGoCfiy3hJtkxZG==wg4o1AG2dV3ESiwApNj3GxENDsLSQ=jSA@mail.gmail.com> <510DA959.6000106@googlemail.com> <51111BC8.2010209@googlemail.com>
In-Reply-To: <51111BC8.2010209@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/05/13 14:48, Chris Clayton wrote:
>
[snip]
>
> Well, after lots of hacking diagnostics into cx23885-i2c.c, I'm pretty
> sure that this is a timing problem. I've eventually found that if I
> insert a short delay into the top of i2c_sendbytes(), my HVR-1400
> expresscard dvb-t gadget starts to work. When I run a dvb scan, it finds
> all 117 services that are found using the same device on Windows 7 (and
> by a nearby Samsung TV). I have no idea why the delay makes the card work.
>
> A patch that makes this change is:
>
[snip]
OK, here's what I believe to be a better version of the patch:

--- linux-3.7.6/drivers/media/pci/cx23885/cx23885-i2c.c~ 
2013-02-01 19:46:56.000000000 +0000
+++ linux-3.7.6/drivers/media/pci/cx23885/cx23885-i2c.c 2013-02-06 
11:08:31.000000000 +0000
@@ -92,6 +92,13 @@ static int i2c_sendbytes(struct i2c_adap
         else
                 dprintk(1, "%s(msg->len=%d)\n", __func__, msg->len);

+       /* The XC3028L tuner on a WinTV-HVR-1400 fails to tune without 
this */
+       if (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1400) {
+               printk_once(KERN_INFO "%s - extra delay being applied for "
+                           "HVR1400\n", i2c_adap->name);
+               udelay(8);
+       }
+
         /* Deal with i2c probe functions with zero payload */
         if (msg->len == 0) {
                 cx_write(bus->reg_addr, msg->addr << 25);

Signed-off-by: Chris Clayton <chris2553@googlemail.com>

It applies cleanly to 3.7.6 and to 3.80-rc6+ (pulled this morning).

Chris


