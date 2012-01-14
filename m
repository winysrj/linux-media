Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab2ANOvU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 09:51:20 -0500
Message-ID: <4F119664.5080507@redhat.com>
Date: Sat, 14 Jan 2012 12:51:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jim Darby <uberscubajim@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] dvb-core: preserve the delivery system at cache
 clear
References: <4F101940.2020408@gmail.com> <1326462636-8869-1-git-send-email-mchehab@redhat.com> <4F10C586.3030600@gmail.com>
In-Reply-To: <4F10C586.3030600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-01-2012 22:00, Jim Darby escreveu:
> Thanks for the patch Mauro. According to Gianluca that solves the backwards compatibility issue. This is great news.

Good!

> In other news I've tried a few experiments. Firstly I tried using a 3.2.0 unmodified straight out of the box kernel on my Core 2 64-bit system. I was unable to produce any faults. This would tend to lead one to suspect that it's a 32-bit problem or that my 32-bit machine is a bit flaky or slow.
> 
> So, as I wanted to try the new alpha 3 for Mageia 2 (a Mandriva fork) out and it has a 3.0 kernel that seemed to be a good idea. The bad news is that I'd run out of hardware. So I thought I'd be clever and run it as a virtual machine on my Core 2 system.
> 
> The good news is that it correctly recognised the stick and it seemed to work for standard definition. However, after setting it to record some HDTV programmes it failed. More importantly it failed in the same way as the 32-bit system.
> 
> This makes me think it's some kind of timing problem. The USB passthrough of VirtualBox may well not operate at the performance required for HDTV. Also by this time I'd put the stick on a USB extension lead which may have adversely affected the power feed.

Never used the USB passthrough of VirtualBox. At KVM, Hans de Goede wrote several patches 
to allow it to work with webcams.

On my tests with it with video cards, sometimes it works, sometimes it doesn't.


> For my next series of tests I plan to run it again on bare hardware. I'm going to try and use my older Core 2 machine which should have the CPU and electrical power.
> 
> None of which explains why it works on the 32-bit Athlon XP 2200+ when it's running 3.0.0 though. And has done so reliably for some time. Maybe some other things are happening in the kernel that much up the device timing or something.
> 
> Anyway, I'll keep people posted as to the progression of the testing.

>From DVB drivers perspective, a full 32bits system should work just like a 64 bits one.

Btw, I was working with a 32 bits kernel for my ISDB-T tests with the dvbv5-scan tool
I'm writing. I'm now using a 64 bits kernel for DVB-C, and everything is working
as fine as before.
> 
> Best regards,
> 
> Jim.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

