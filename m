Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab2HARjG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Aug 2012 13:39:06 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q71HcvPL023492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 1 Aug 2012 13:39:06 -0400
Received: from [10.97.5.124] (vpn1-5-124.gru2.redhat.com [10.97.5.124])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q71GgoRi002326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 1 Aug 2012 12:42:51 -0400
Message-ID: <50195C89.5090808@redhat.com>
Date: Wed, 01 Aug 2012 13:42:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] patchwork notifications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Developers,

Just to let you know, I finally made patchwork notifications to work.

With this change, every time a patch (or a group of patches) have their
status changed, an email will be sent to the patch author, similar to this one:

	The following patches (submitted by you) have been updated in patchwork:

	 * [43/47,media] mt2063: add some useful info for the dvb callback calls
	     - http://patchwork.linuxtv.org/patch/9332/
	    was: New
	    now: RFC

	 * [2/4,media] DocBook/dvbproperty.xml: Fix ISDB-T delivery system parameters
	     - http://patchwork.linuxtv.org/patch/9557/
	    was: New
	    now: Accepted

	 * [13/35,media] az6007: need to define drivers name before including dvb-usb.h
	     - http://patchwork.linuxtv.org/patch/9593/
	    was: New
	    now: Accepted

...

Developers that don't want this feature can opt-out, using this link:
	 http://patchwork.linuxtv.org/mail/

Still, I suggest you to don't to that ;)

As a reminder, the policy I'm using to handle patches is:

New patches are marked there as 'New'.

When I'm expecting someone (typically, the driver's author) to review a patch, the
status is changed to 'Under review'. Unfortunately, patchwork doesn't have a field
to indicate to whom, so I'm currently this information on a separate file on my local
machine.

When the same patch is sent twice, or a new version of the same patch and I am
able to identify it, the old patch is marked as  'superseded'.

When someone asks for changes at the patch, the patch is marked as 'changes requested'.

When the patch is wrong or doesn't apply, it is marked as 'rejected'. Most of the
time, 'rejected' and 'changes requested' means the same thing for the developer:
he'll need to re-work on the patch.

Patches that aren't meant to be applicable at the media-tree.git are typically
marked as 'not applicable' [1].

Finally, when everything is ok and it got applied either at the main tree or at
the fixes tree, the patch is marked as 'accepted'.

Of course, as we're all humans (and patchwork status is changed manually by me),
errors may happen. Feel free to ping me on irc or via email on such cases.

[1] Just to make my life easier, patches for a few other random trees that I
maintain/partially maintain, like media-build tree, are generally marked as 
'Accepted' as well, when I am the one applying it, as it saves me time ;)

I hope you'll find this new tool useful.

Regards,
Mauro
