Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.wa.amnet.net.au ([203.161.124.52]:39962 "EHLO
	smtp3.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbbJEP0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 11:26:36 -0400
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
To: Steven Toth <stoth@kernellabs.com>
References: <5610B12B.8090201@tresar-electronics.com.au>
 <CALzAhNWuOhQNQFu-baXy6QzhV3AxCknh7XeKOBjp943nz66Qyw@mail.gmail.com>
 <5611D97B.9020101@tresar-electronics.com.au>
 <CALzAhNVVipTAE3T9Hpmi8_CT=ZS5Wd04W5LfMaf-X5QP2d0sQw@mail.gmail.com>
 <56128AA6.8010106@tresar-electronics.com.au>
 <CALzAhNVDYgBbCfW5XSwVXJKqm7CgB23=xpsf25Y2Z0yY=tEKBQ@mail.gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
From: Richard Tresidder <rtresidd@tresar-electronics.com.au>
Message-ID: <561296A8.7000302@tresar-electronics.com.au>
Date: Mon, 5 Oct 2015 23:26:32 +0800
MIME-Version: 1.0
In-Reply-To: <CALzAhNVDYgBbCfW5XSwVXJKqm7CgB23=xpsf25Y2Z0yY=tEKBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stage 1..
Yep it works with accessing src directly.. had to reboot to verify that one.
Well at least the download says it worked and the image booted successfully.

excuse my manual diff method..
git and I don't agree... not sure how to get it to diff the media_build 
repo I pulled the code from..
my brain is stuck in subversion mode..

Still rebuilding the kernel to check the i2c Mux issue..

Regards
    Richard

saa7164-fw.c.patch
******************************************************************
--- saa7164-fw.c    2015-10-05 23:05:31.279329924 +0800
+++ saa7164-fw.c    2015-10-05 23:21:54.236082009 +0800
@@ -75,7 +75,6 @@ static int saa7164_downloadimage(struct
                   u32 dlflags, u8 __iomem *dst, u32 dstsize)
  {
      u32 reg, timeout, offset;
-    u8 *srcbuf = NULL;
      int ret;

      u32 dlflag = dlflags;
@@ -93,17 +92,10 @@ static int saa7164_downloadimage(struct
          goto out;
      }

-    srcbuf = kzalloc(4 * 1048576, GFP_KERNEL);
-    if (NULL == srcbuf) {
-        ret = -ENOMEM;
-        goto out;
-    }
-
      if (srcsize > (4*1048576)) {
          ret = -ENOMEM;
          goto out;
      }
-    memcpy(srcbuf, src, srcsize);

      dprintk(DBGLVL_FW, "%s() dlflag = 0x%x\n", __func__, dlflag);
      dprintk(DBGLVL_FW, "%s() dlflag_ack = 0x%x\n", __func__, dlflag_ack);
@@ -134,8 +126,9 @@ static int saa7164_downloadimage(struct
      for (offset = 0; srcsize > dstsize;
          srcsize -= dstsize, offset += dstsize) {

+
          dprintk(DBGLVL_FW, "%s() memcpy %d\n", __func__, dstsize);
-        memcpy_toio(dst, srcbuf + offset, dstsize);
+        memcpy_toio(dst, src+offset, dstsize);

          /* Flag the data as ready */
          saa7164_writel(drflag, 1);
@@ -153,7 +146,7 @@ static int saa7164_downloadimage(struct

      dprintk(DBGLVL_FW, "%s() memcpy(l) %d\n", __func__, dstsize);
      /* Write last block to the device */
-    memcpy_toio(dst, srcbuf+offset, srcsize);
+    memcpy_toio(dst, src+offset, srcsize);

      /* Flag the data as ready */
      saa7164_writel(drflag, 1);
@@ -192,7 +185,6 @@ static int saa7164_downloadimage(struct
      ret = 0;

  out:
-    kfree(srcbuf);
      return ret;
  }
  *********************************************************************


On 05/10/15 22:43, Steven Toth wrote:
>>> Do you have a large number of other devices / drivers loaded? I
>>> suspect another driver is burning through kernel memory before the
>>> saa7164 has a chance to be initialized.
>> Nope nothing I can see Its actually the only addon card I have in this
>> system..
>> I'd be buggered If 4GB of RAM is fragmented enough early on in the boot
>> stage...?
> I agree.
>
>> I've hunted but can't find a nice way to determine what contiguous blocks
>> are available..
>> Noted there was a simple module that could be compiled in to test such
>> things, I'll play with that and see what it turns up..
> Let us know how that goes.
>
>>> I took a quick look at saa7164-fw.c this morning, I see no reason why
>>> the allocation is required at all. With a small patch the function
>>> could be made to memcpy from 'src' directly, dropping the need to
>>> allocate srcbuf what-so-ever. This would remove the need for the 4MB
>>> temporary allocation, and might get you past this issue, likely on to
>>> the next (user buffer allocations are also large - as I recall). Note
>>> that the 4MB allocation is temporary, so its not a long term saving,
>>> but it might get you past the hump.
>> That was my thoughts exactly.. but I took a minimal fiddling approach to
>> begin with..
>> I wasn't sure if there was some requirement for the memcpy_toio requiring a
>> specially allocated source..? can't see why..
>> Was going to dig into that next as a side job..
> At this stage the code is 7-8 years old, so I don't recall the
> rationale for why I did that back in 2008(?) - but looking at it
> today, I think its needless.... and its a fairly trivial thing to
> remove and test.
>

