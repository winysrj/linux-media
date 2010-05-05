Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43118 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0EEUxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 16:53:07 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o45Kr7lU006951
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 5 May 2010 15:53:07 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id o45Kr6Lv004834
	for <linux-media@vger.kernel.org>; Wed, 5 May 2010 15:53:07 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o45Kr6Hv012725
	for <linux-media@vger.kernel.org>; Wed, 5 May 2010 15:53:06 -0500 (CDT)
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 5 May 2010 15:53:05 -0500
Subject: [videobuf] Query: Condition bytesize limit in videobuf_reqbufs ->
 buf_setup() call?
Message-ID: <A24693684029E5489D1D202277BE894455257D13@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

While working on an old port of the omap3 camera-isp driver,
I have faced some problem.

Basically, when calling VIDIOC_REQBUFS with a certain buffer
Count, we had a software limit for total size, calculated depending on:

  Total bytesize = bytesperline x height x count

So, we had an arbitrary limit to, say 32 MB, which was generic.

Now, we want to condition it ONLY when MMAP buffers will be used.
Meaning, we don't want to keep that policy when the kernel is not
allocating the space

But the thing is that, according to videobuf documentation, buf_setup is
the one who should put a RAM usage limit. BUT the memory type passed to
reqbufs is not propagated to buf_setup, therefore forcing me to go to a
non-standard memory limitation in my reqbufs callback function, instead
of doing it properly inside buf_setup.

Is this scenario a good consideration to change buf_setup API, and
propagate buffers memory type aswell?

I'll appreciate your inputs on this matter.

Regards,
Sergio
