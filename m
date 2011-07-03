Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab1GCUDg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2011 16:03:36 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p63K3aAu022308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 3 Jul 2011 16:03:36 -0400
Received: from shalem.localdomain (vpn1-7-37.ams2.redhat.com [10.36.7.37])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p63K3Y5O008500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 3 Jul 2011 16:03:36 -0400
Message-ID: <4E10CB5D.90802@redhat.com>
Date: Sun, 03 Jul 2011 22:04:45 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Kudos for the new vtl2 ctrls framework
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

After making some serious use of it in the pwc driver cleanup
I would like to thank Hans V. for all his hard work on the
new ctrl framework.

The clusters bit got a bit getting used to / but once I did
it is great.

Once you get it, it really makes sense to group certain ctrls
into clusters which then get set in a single call to the driver,
allowing more or less atomic handling of things like autofoo +
foo changing. And in the pwc case also grouping the pan and
tilt controls, which get set with a single usb command,
so that with s_ex_ctrls an app can in theory do diagonal
moving of the camera rather then stair case moving.

Thanks Hans V.!

Regards,

Hans
