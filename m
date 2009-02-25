Return-path: <linux-media-owner@vger.kernel.org>
Received: from vms173017pub.verizon.net ([206.46.173.17]:48708 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbZBYSjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 13:39:05 -0500
Received: from [192.168.2.10] ([173.50.255.29]) by vms173017.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KFM007I4X4KAK2Y@vms173017.mailsrvcs.net> for
 linux-media@vger.kernel.org; Wed, 25 Feb 2009 12:38:50 -0600 (CST)
Message-id: <49A59034.30104@foo-projects.org>
Date: Wed, 25 Feb 2009 10:38:44 -0800
From: Auke Kok <auke@foo-projects.org>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: moinejf@free.fr, rossi.f@inwind.it, linux-media@vger.kernel.org
Subject: Re: zc3xx: "Creative Webcam Live!" never worked with in-tree driver
References: <49A4616A.10207@foo-projects.org>
	<49A48A3B.4090509@foo-projects.org> <20090224211916.249e15cf@pedra.chehab.org>
In-reply-to: <20090224211916.249e15cf@pedra.chehab.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> On Tue, 24 Feb 2009 16:00:59 -0800
> Auke Kok <auke@foo-projects.org> wrote:
> 
>> Auke Kok wrote:
>>> All,
>>>
>>> I have a "Creative Technology, Ltd Webcam Live!/Live! Pro" that until 
>>> recently worked fine with the out-of-tree gspcav1 driver 
>>> (gspcav1-20071224.tar.gz is the latest version I used unti 2.6.26).
>>>
>>> Since this driver (basically) got merged in the kernel I got my hopes up 
>>> that the in-kernel gspca_zc3xx drivers would work. However, that does 
>>> not provide a usable video0 device - mplayer tv:// crashes with 'No 
>>> stream found.' for instance:

<snip>

>> seems I just found the v4lcompat.so stuff, which (apart from being a 
>> pain in the rear) makes the webcam work again...
> 
> This seems to be a very common error. IMO, we should write message when loading
> a gspca that would require libv4l in order to work.


it would be wonderful if the v4l stack itself can warn when an 
application uses the wrong method on the device node... would such a 
thing be possible?

Auke
