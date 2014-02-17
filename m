Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:24709 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaBQJTg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:19:36 -0500
Date: Mon, 17 Feb 2014 10:13:53 +0100
From: Antonio Ospite <ao2@ao2.it>
To: Mark Pupilli <mpupilli@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: GSPCA ov534 payload error
Message-Id: <20140217101353.b292ff6d2e90749394ab6dc3@ao2.it>
In-Reply-To: <CAF93UxJ_+K6gP4DzcS0mc0VG5Te32uNFjCVeXX7n+v8H4QoZAw@mail.gmail.com>
References: <CAF93UxJ_+K6gP4DzcS0mc0VG5Te32uNFjCVeXX7n+v8H4QoZAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 8 Feb 2014 17:22:11 +0000
Mark Pupilli <mpupilli@gmail.com> wrote:

> Hi,
> 
> I have successfully been using the PS3 eye camera on a beagleboard-xm
> with kernel 2.6.32. I have upgraded to kernel 3.13.1 and can no longer
> stream from the camera. I am using unicap to access the camera which
> never returns any frames.
>

Never used unicap but the camera works fine here on a amd64 with kernel
3.12, 3.13.1 and 3.14-rc2, I tried it with luvcview, qv4l2, guvcview and
gstreamer (gst-launch-1.0 v4l2src device=/dev/video0 ! autovideosink)

> I enabled debugging for the gspca_main module and saw that it is
> repeatedly getting payload errors:
> 
> root@(none): $ dmesg | grep -A 50 -B10 "stream on"
[...]
> [  801.278930] ov534 2-2.3:1.0: stream on OK YUYV 640x480ov534
> 2-2.3:1.0: bulk irq
> [  801.284210] ov534 2-2.3:1.0: packet l:12ov534 2-2.3:1.0: payload error
> [  801.285919] ov534 2-2.3:1.0: bulk irqov534 2-2.3:1.0: packet l:8768
> [  801.286041] ov534 2-2.3:1.0: add t:1 l:2036ov534 2-2.3:1.0: add t:2 l:2036
> [  801.286468] ov534 2-2.3:1.0: add t:2 l:2036ov534 2-2.3:1.0: add t:2 l:2036
> [  801.286834] ov534 2-2.3:1.0: add t:2 l:564ov534 2-2.3:1.0: bulk irq
> [  801.287139] ov534 2-2.3:1.0: packet l:12ov534 2-2.3:1.0: payload error
> ...
> 
> Is this likely to be a problem with the gspca ov534 driver or with the
> USB subsystem?
>

Oscillating packet sizes (l:12, l:8768, l:564), looks more like an USB
issue.

Ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
