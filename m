Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:46516 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZIMHUW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 03:20:22 -0400
Date: Sun, 13 Sep 2009 09:20:15 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	leandro Costantino <lcostantino@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: image quality of Labtec Webcam 2200
Message-ID: <20090913092015.485fdbcd@tele>
In-Reply-To: <4AA9F7A0.5080802@freemail.hu>
References: <4AA9F7A0.5080802@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 11 Sep 2009 09:09:20 +0200
Németh Márton <nm127@freemail.hu> wrote:

> You can find my results at
> http://v4l-test.sourceforge.net/results/test-20090911/index.html
> There are three types of problems: a) Sometimes the picture contains
> a 8x8 pixel error, like in image #9
> http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00009
> b) Sometimes the brightness of the half picture is changed, like in
> images #7, #36 and #37
> http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00007
> http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00036
> http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00037
> c) Sometimes the libv4l cannot convert the raw image and the errno is
> set to EAGAIN (11), for example image #1, #2 and #3
> 
> Do you know how can I fix these problems?

The error EAGAIN is normal when decoding pac7311 images, because they
are rotated 90°. But this error should occur one time only.

I looked at the raw image #1, and it seems that there are JPEG errors
inside (sequences ff ff). There should be a problem in the pac7311
driver. Hans, may you confirm?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
