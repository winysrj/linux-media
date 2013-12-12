Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28454 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab3LLBqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 20:46:52 -0500
From: "Zhao, Halley" <halley.zhao@intel.com>
To: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
Subject: v4l2 dmabuf test on Ubuntu 13.10 with logitech c210 camera
Date: Thu, 12 Dec 2013 01:46:23 +0000
Message-ID: <81DD1C3FC6BE1E4EAA454D486F82004401D54F0B@SHSMSX101.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi experts:
With Laurent Pinchart's test case: http://www.mail-archive.com/linux-media@vger.kernel.org/msg54806.html
I update it to work on my PC (haswell) with Ubuntu 13.10 + c210 camera:
https://gitorious.org/halley-test/v4l2-dmabuf-test

the loop keeps running, however, video scene almost doesn't update.
Anyone know the reason, does Ubuntu13.10 (3.11 linux kernel) includes all the necessary parts for dmabuf support in uvc camera?

Thanks.

