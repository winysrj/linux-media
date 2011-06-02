Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:45486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1FBQfl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2011 12:35:41 -0400
Message-ID: <4DE7BBCF.4080507@redhat.com>
Date: Thu, 02 Jun 2011 13:35:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Dmitri Belimov <d.belimov@gmail.com>, linux-media@vger.kernel.org,
	thunder.m@email.cz, "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>,
	bahathir@gmail.com
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local>	<BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>	<4DE7A131.7010208@redhat.com> <BANLkTinKOoSJUOBFKy=PK3jJgaonzWrPxQ@mail.gmail.com>
In-Reply-To: <BANLkTinKOoSJUOBFKy=PK3jJgaonzWrPxQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-06-2011 12:17, Devin Heitmueller escreveu:
> On Thu, Jun 2, 2011 at 10:41 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>>> 1.  Assemble tree with current patches
>>
>> It is probably easier for me to do this step, as I have my hg import
>> scripts. However, as I don't have the PCTV devices added at dib0700,
>> I can't test.
>>
>> OK, I did this work, as it just took me a few minutes to rebase patches
>> 1 and 2. I didn't apply the patches that started with "djh" since they
>> seemed to be a few hacks during the development time.
>>
>> The tree is at:
>>
>> git://linuxtv.org/mchehab/experimental.git branch xc4000
>>
>> There are two warnings there that needs to be fixed:
>>
>> drivers/media/common/tuners/xc4000.c:1293: warning: ‘xc4000_is_firmware_loaded’ defined but not used
>> drivers/media/common/tuners/xc4000.c: In function ‘check_firmware.clone.0’:
>> drivers/media/common/tuners/xc4000.c:1107: warning: ‘version’ may be used uninitialized in this function
>>
>> Both seems to be trivial.
>>
>> A disclaimer notice here: I didn't make any cleanup at the code,
>> (except by running a whitespace cleanup script) nor I've reviewed it.
>>
>> IMO, the next step is to test the rebases against a real hardware,
>> and adding a few patches fixing it, if the rebases broke.
>>
>> The next step would be fix the CodingStyle, and run checkpatch.pl.
>> There aren't many CodingStyle warnings/errors (13 errors, 28 warnings).
>> Most of the errors are due to the excess usage of printk's for debug,
>> and due to some obsolete code commented with //.
> 
> Hi Mauro,
> 
> Thanks for taking this on.  The tree you posted looks like a pretty
> reasonable start.  I agree that the "djh - " commits probably aren't
> required as they are most just from rebasing the tree.  We'll find out
> from testing though whether this is true.  There's one patch with
> subject "djh - more debugging" might actually be needed, but we'll see
> when users try the tree.

I was in doubt and I almost backported that one too, but it seemed better
to not add it to just remove it at the end.

Btw, it seems that a latter patch on your tree removed it. The only difference 
between the git tree and your tree at xc4000.c/xc4000.h is:

$ diff -uprBw drivers/media/common/tuners/xc4000.c /home/v4l/tmp/linux/drivers/media/common/tuners/xc4000.c
--- drivers/media/common/tuners/xc4000.c	2011-06-02 11:36:19.000000000 -0300
+++ /home/v4l/tmp/linux/drivers/media/common/tuners/xc4000.c	2011-06-02 10:48:34.000000000 -0300
@@ -1272,7 +1272,8 @@ static int xc4000_set_params(struct dvb_
 		XC4000_Standard[priv->video_standard].AudioMode);
 	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc4000: xc_SetTVStandard failed\n");
-		return -EREMOTEIO;
+		/* DJH - do not return when it fails... */
+		//return -EREMOTEIO;
 	}
 #ifdef DJH_DEBUG
 	ret = xc_set_IF_frequency(priv, priv->if_khz);

So, maybe the above patch also needs to be added there.

> This provides a pretty good base for istan_v to work off of, since he
> did a rather large amount of refactoring to get analog to work - which
> I was unable to even try given the two devices I had can't do analog
> support due to limitations in the dvb-usb framework.
> 
> Mohammad, it would be great if you could try out Mauro's tree, since
> it should work as-is for the 340e.

If it doesn't, please try to apply the above patch.

Thanks,
Mauro
