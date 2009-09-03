Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp03.uk.clara.net ([195.8.89.36]:37450 "EHLO
	claranet-outbound-smtp03.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764AbZICKhT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 06:37:19 -0400
Message-ID: <4A9F9C5F.9000007@onelan.com>
Date: Thu, 03 Sep 2009 11:37:19 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
References: <4A9E9E08.7090104@onelan.com> <4A9EAF07.3040303@hhs.nl> <4A9F89AD.7030106@onelan.com> <4A9F9006.6020203@hhs.nl> <4A9F98BA.3010001@onelan.com>
In-Reply-To: <4A9F98BA.3010001@onelan.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simon Farnsworth wrote:
> Hans de Goede wrote:
>> Ok,
>> 
>> That was even easier then I thought it would be. Attached is a
>> patch (against libv4l-0.6.1), which implements 1) and 3) from
>> above.
>> 
> I applied it to a clone of your HG repository, and had to make a
> minor change to get it to compile. I've attached the updated patch.
> 
> It looks like the read() from the card isn't reading entire frames
> ata a time - I'm using a piece of test gear that I have to return in
> a couple of hours to send colourbars to it, and I'm seeing bad
> colour, and the picture moving across the screen. I'll try and chase
> this, see whether there's something obviously wrong.
> 
There is indeed something obviously wrong; at line 315 of libv4l2.c, we
expand the buffer we read into, then ask for that many bytes.

diff -r c51a90c0f62f v4l2-apps/libv4l/libv4l2/libv4l2.c
--- a/v4l2-apps/libv4l/libv4l2/libv4l2.c        Tue Sep 01 10:03:27 2009 +0200
+++ b/v4l2-apps/libv4l/libv4l2/libv4l2.c        Thu Sep 03 11:32:40 2009 +0100
@@ -326,7 +326,7 @@
   }

   do {
-    result = SYS_READ(devices[index].fd, devices[index].readbuf, buf_size);
+    result = SYS_READ(devices[index].fd, devices[index].readbuf, devices[index].dest_fmt.fmt.pix.sizeimage);
     if (result <= 0) {
       if (result && errno != EAGAIN) {
        int saved_err = errno;

fixes it for me.

I appear to lose colour after a few seconds of capture, which I shall chase
further.
-- 
Simon Farnsworth

