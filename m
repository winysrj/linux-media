Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab1IRP0a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 11:26:30 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p8IFQU4s015753
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 18 Sep 2011 11:26:30 -0400
Received: from [10.11.10.158] (vpn-10-158.rdu.redhat.com [10.11.10.158])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p8IFQSfr019108
	for <linux-media@vger.kernel.org>; Sun, 18 Sep 2011 11:26:29 -0400
Message-ID: <4E760DA4.8030906@redhat.com>
Date: Sun, 18 Sep 2011 12:26:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] patchwork.linuxtv.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Sirs,

As several of you noticed, we were having several troubles with patchwork.kernel.org,
resulting on patches that got lost and several other troubles. Still, it is the
main tool I use here to collect random patches that people send through the mailing
list and that the driver maintainer is lazy^Wbusy enough to not care to pick and
send me via a git pull request.

At the end of August, Kernel.org infrastructure were put down for maintainance, and 
there's no ETA for it to return.

All new patches sent to the linux-media ML will now be sent also to patchwork.linuxtv.org,
where they'll be stored if patchwork euristics detect the email as a patch.

So, I decided to run a new patchwork instance at linuxtv.org. Unfortunately, with
kernel.org servers down, I could not recover the patches that were there. Due to that,
I've sent to patchwork filter the emails from my linux-media archives (that has a few
holes, but it is better than nothing).

About 7500+ patches were added there, since 2009. As most of the patches were already
applied, I've scripted some logic to detect if a patch were (partially) applied, or if
the patch were rejected. I'm now reviewing manually the patches that still applies and
pinging people about them, if the patch is too old and I didn't notice it being applied.
This gives us a second chance of reviewing the patches that older versions of Patchwork
(or kernel.org instance) didn't catch.

The patchwork instance at linuxtv is capable of automatically sending notifications to
people if a patch changes its state. I'll likely enable this feature on a near future,
after finishing the review of the old stuff. I'll also likely try to use the delegate
function of patchwork. I'll keep you updated about new features as we'll be able to
activate them.

For those that are submitting patches, I'd like to remember that patchwork has some rules
to accept a patch. It basically will get your patch if:
	- the patch sent inlined;
	- the patch weren't mangled by the emailer (some emailers love to break long
lines into smaller ones, damaging the patches);
	- are encoded with ASCII and doesn't contain any character upper than 0x80
(no accented characters).

Patchwork might also get patches uuencoded, with different charsets (in particular, if
your name has accents, I recommend you to use UTF-8) and/or with the patch attached, but
I recommend you to double check at patchwork.linuxtv.org to see if the patch were caught.

Also, although patchwork does accept attached patches, you should not send patches
on this way, as people can't easily review it (as several developers use plain text
emailers that can't reply to the inlined patch text).

If you discover any problems there, or notice a patch that were badly tagged (and aren't
marked there as "New"), please drop me an email.

Ah, you should notice that, by default, patchwork will only show patches tagged as
New or Under review (e. g., patches with "Action required"). So, if you want to search
for a patch that might be wrongly tagged, you'll need to click into patchwork "Filters:"
field and change it to show all patch status, or click on the URL bellow:

	http://patchwork.linuxtv.org/project/linux-media/list/?state=*

I hope you enjoy patchwork.linuxtv.org!

Thanks,
Mauro
