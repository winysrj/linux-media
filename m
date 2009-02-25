Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:56301 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZBYHoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 02:44:09 -0500
Message-ID: <49A4F6C0.5060503@freemail.hu>
Date: Wed, 25 Feb 2009 08:44:00 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 12768] New: usb_alloc_urb() leaks memory 	together
 with uvcvideo driver
References: <bug-12768-10286@http.bugzilla.kernel.org/>	 <20090224135720.9e752fee.akpm@linux-foundation.org>	 <20090224230200.77469747@pedra.chehab.org>	 <d9def9db0902241815i7e0d8e90k59824c5a83534e2c@mail.gmail.com>	 <20090224192330.338302fa.akpm@linux-foundation.org> <d9def9db0902241935h3e9303ebpaa43ec2ae03b4dc2@mail.gmail.com>
In-Reply-To: <d9def9db0902241935h3e9303ebpaa43ec2ae03b4dc2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please, please, please, can we concentrate on the subject?

What I did with the other out-of-tree em28xx-new driver was that
I printed out the urb->kref.refcount before and after each urb operation.

The result was that when the urb->complete function is called, the reference
count was still 2, instead of 1.

I could imagine three possible errors:
1. there is a bug in uvcvideo driver
2. there is a bug in v4l framework
3. there is a bug in usb subsystem

It would be good if someone who have a deeper knowledge than me on these fields could
give some hints or debug patches which would lead us closer to the solution.

Regards,

	Márton Németh
