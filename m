Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0A1CkT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 21:40:19 -0500
Message-ID: <4B60F901.20301@redhat.com>
Date: Thu, 28 Jan 2010 00:40:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: cx18 fix patches
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

I've made two fix patches to solve the issues with cx18 compilation.
My original intention were to send you an email for your ack.

Unfortunately, those got added at the wrong branch and went upstream.

That proofs that my scripts aren't reliable yet, and that I need
an independent tree for such patches... I hope I have enough disk for all
those trees...

As we can't rebase the -git tree without breaking the replicas,
I'd like you to review the patches:

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=701ca4249401fe9705a66ad806e933f15cb42489
http://git.linuxtv.org/v4l-dvb.git?a=commit;h=dd01705f6a6f732ca95d20959a90dd46482530df

If a committed patch is bad, the remaining solution is to write a patch reverting
it, and generating some dirty at the git logs.

So, I hope both patches are ok...

Please test.

Sorry for the mess.

Cheers,
Mauro.
