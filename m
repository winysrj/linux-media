Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353Ab0CMDuP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 22:50:15 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2D3oCJG014276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 22:50:12 -0500
Message-ID: <4B9B0B6F.3060903@redhat.com>
Date: Sat, 13 Mar 2010 00:50:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: pushes at v4l-utils tree
References: <4B99891E.9010406@redhat.com> <4B9A62B6.7090004@redhat.com> <4B9A962A.2020407@redhat.com> <4B9AE956.203@redhat.com>
In-Reply-To: <4B9AE956.203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Mauro Carvalho Chehab wrote:
>> Hans de Goede wrote:

>> Yes. The new objects and the touched files got a different group ownership
>> after git push. I had to manually fix them at the server.
> 
> I added a hook that will likely fix it. As I have a few more changes to ir-keytable,
> I'll be sending it directly and see if the permissions are properly fixed.

After some work, it is now working properly. So, it is safe for the others to update
on it without breaking the permissions.

> Please, don't upgrade the version yet just due to keytable, as I'm still working on
> more keytable patches, to handle the new uevent attributes (to match the IR core patches
> I posted earlier today).

Added what I have for now. The ir-keytable is now doing a nice job reading the new
sysfs stuff from /sys/class/irrcv, with the new IR patches I posted. I'll add tomorrow
the ir-core patches at v4l-dvb tree, if no comments received.

The next item on keytable TODO list is to add ir-keytable at Makefile install target
and to put it to work together with udev. After those changes, it will be possible to
replace an IR table when a device is detected by udev. 

I'll probably write an example script to do a very basic udev setup,but a more 
sophisticated userspace tool would be needed to allow someone to do it
via some gui.

-- 

Cheers,
Mauro
