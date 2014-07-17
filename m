Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45286 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbaGQXqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 19:46:55 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so8575077wib.16
        for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 16:46:54 -0700 (PDT)
Received: from [10.0.0.202] (251.215.broadband6.iol.cz. [88.101.215.251])
        by mx.google.com with ESMTPSA id r9sm73774968wia.17.2014.07.17.16.46.53
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 17 Jul 2014 16:46:53 -0700 (PDT)
From: Rafael van Horn <rafael.vanhorn@gmail.com>
Message-ID: <53C8606C.4000907@gmail.com>
Date: Fri, 18 Jul 2014 01:46:52 +0200
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: media_build wrong patch
Content-Type: multipart/mixed;
 boundary="------------010100000801070105080409"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010100000801070105080409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'd like to file a bug in the latest commit: 
b6f4c524e0fe8f2d50b0a2f849e022adef76c6cc

The file backports/api_version.patch rejects to patch the 
linux/drivers/media/v4l2-core/v4l2-ioctl.c because of wrong line numbers 
and because the code doesn't match.


This is your code:
-----------------------------------------------------------------------
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1009,7 +1009,7 @@ static int v4l_querycap(const struct 
v4l2_ioctl_ops *ops,
  	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
  	int ret;

-	cap->version = LINUX_VERSION_CODE;
+	cap->version = V4L2_VERSION;

  	ret = ops->vidioc_querycap(file, fh, cap);

-----------------------------------------------------------------------

This should be there:
-----------------------------------------------------------------------
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -964,7 +964,7 @@ static int v4l_querycap(const struct v4l2_ioctl_ops 
*ops,
  {
  	struct v4l2_capability *cap = (struct v4l2_capability *)arg;

-	cap->version = LINUX_VERSION_CODE;
+	cap->version = V4L2_VERSION;
  	return ops->vidioc_querycap(file, fh, cap);
  }

-----------------------------------------------------------------------

In the C file there's no ret variable and all the code is moved 
somewhere else, but it's not @@ line 1009.

The diff file is attached.

When I hacked the patch file, I built everything.

Regards.
Rafael van Horn





-----------------------------------------------------------------------

Debian 7.6
gcc Version: 4:4.7.2-1
make Version: 3.81-8.2
perl Version: 5.14.2-21+deb7u1
linux-headers-amd64 Version: 3.2+46
patch Version: 2.6.1-3

--------------010100000801070105080409
Content-Type: text/x-patch;
 name="api_version.patch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="api_version.patch.diff"

--- MB/backports/api_version.patch	2014-07-18 00:48:54.773248546 +0200
+++ api_version.patch	2014-07-18 01:36:33.878313555 +0200
@@ -41,12 +41,12 @@
 index e0bafda..6225391 100644
 --- a/drivers/media/v4l2-core/v4l2-ioctl.c
 +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
-@@ -1009,7 +1009,7 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
+@@ -964,7 +964,7 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
+ {
  	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
- 	int ret;
  
 -	cap->version = LINUX_VERSION_CODE;
 +	cap->version = V4L2_VERSION;
- 
- 	ret = ops->vidioc_querycap(file, fh, cap);
+ 	return ops->vidioc_querycap(file, fh, cap);
+ }
  

--------------010100000801070105080409--
