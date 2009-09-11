Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:50110 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZIKHJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 03:09:22 -0400
Message-ID: <4AA9F7A0.5080802@freemail.hu>
Date: Fri, 11 Sep 2009 09:09:20 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Thomas Kaiser <thomas@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: image quality of Labtec Webcam 2200
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Labtec Webcam 2200 and I have problems with the image quality
with Linux 2.6.31 + libv4l 0.6.1. I made some experiments and stored
each captured image as raw data and when libv4l was able to convert
then I also stored the result as bmp.

You can find my results at http://v4l-test.sourceforge.net/results/test-20090911/index.html
There are three types of problems:
 a) Sometimes the picture contains a 8x8 pixel error, like in image #9
    http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00009
 b) Sometimes the brightness of the half picture is changed, like in
    images #7, #36 and #37
    http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00007
    http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00036
    http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00037
 c) Sometimes the libv4l cannot convert the raw image and the errno
    is set to EAGAIN (11), for example image #1, #2 and #3

Do you know how can I fix these problems?

Regards,

	Márton Németh
