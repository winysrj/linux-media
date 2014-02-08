Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41056 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaBHRWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 12:22:12 -0500
Received: by mail-vc0-f174.google.com with SMTP id im17so3555835vcb.5
        for <linux-media@vger.kernel.org>; Sat, 08 Feb 2014 09:22:11 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 8 Feb 2014 17:22:11 +0000
Message-ID: <CAF93UxJ_+K6gP4DzcS0mc0VG5Te32uNFjCVeXX7n+v8H4QoZAw@mail.gmail.com>
Subject: GSPCA ov534 payload error
From: Mark Pupilli <mpupilli@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have successfully been using the PS3 eye camera on a beagleboard-xm
with kernel 2.6.32. I have upgraded to kernel 3.13.1 and can no longer
stream from the camera. I am using unicap to access the camera which
never returns any frames.

I enabled debugging for the gspca_main module and saw that it is
repeatedly getting payload errors:

root@(none): $ dmesg | grep -A 50 -B10 "stream on"
[  801.179748] ov534 2-2.3:1.0: SET 01 0000 00f2 0cov534 2-2.3:1.0:
SET 01 0000 00f3 d0
[  801.180847] ov534 2-2.3:1.0: SET 01 0000 00f5 37ov534 2-2.3:1.0:
GET 01 0000 00f6 00
[  801.199005] ov534 2-2.3:1.0: SET 01 0000 00f2 0cov534 2-2.3:1.0:
SET 01 0000 00f5 33
[  801.218994] ov534 2-2.3:1.0: GET 01 0000 00f6 00ov534 2-2.3:1.0:
SET 01 0000 00f5 f9
[  801.238861] ov534 2-2.3:1.0: GET 01 0000 00f6 00ov534 2-2.3:1.0:
GET 01 0000 00f4 d0
[  801.239349] ov534 2-2.3:1.0: sccb write: 0c d0ov534 2-2.3:1.0: SET
01 0000 00f2 0c
[  801.240081] ov534 2-2.3:1.0: SET 01 0000 00f3 d0ov534 2-2.3:1.0:
SET 01 0000 00f5 37
[  801.258850] ov534 2-2.3:1.0: GET 01 0000 00f6 00ov534 2-2.3:1.0:
sccb write: 2b 00
[  801.258972] ov534 2-2.3:1.0: SET 01 0000 00f2 2bov534 2-2.3:1.0:
SET 01 0000 00f3 00
[  801.260040] ov534 2-2.3:1.0: SET 01 0000 00f5 37ov534 2-2.3:1.0:
GET 01 0000 00f6 00
[  801.278930] ov534 2-2.3:1.0: stream on OK YUYV 640x480ov534
2-2.3:1.0: bulk irq
[  801.284210] ov534 2-2.3:1.0: packet l:12ov534 2-2.3:1.0: payload error
[  801.285919] ov534 2-2.3:1.0: bulk irqov534 2-2.3:1.0: packet l:8768
[  801.286041] ov534 2-2.3:1.0: add t:1 l:2036ov534 2-2.3:1.0: add t:2 l:2036
[  801.286468] ov534 2-2.3:1.0: add t:2 l:2036ov534 2-2.3:1.0: add t:2 l:2036
[  801.286834] ov534 2-2.3:1.0: add t:2 l:564ov534 2-2.3:1.0: bulk irq
[  801.287139] ov534 2-2.3:1.0: packet l:12ov534 2-2.3:1.0: payload error
...

Is this likely to be a problem with the gspca ov534 driver or with the
USB subsystem?

thanks,
Mark
