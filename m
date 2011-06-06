Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1FFRzr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 13:55:47 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p56Htloi011002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 6 Jun 2011 13:55:47 -0400
Received: from shalem.localdomain (vpn2-8-69.ams2.redhat.com [10.36.8.69])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p56Hti9W023030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 6 Jun 2011 13:55:46 -0400
Message-ID: <4DED14BA.5010306@redhat.com>
Date: Mon, 06 Jun 2011 19:56:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Which error code to return when a usb camera gets unplugged
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

While working on my cleanup / v4l2 compliance series for
the pwc driver I've noticed that the pwc and gspca drivers
are doing different things wrt what error they return to
an app is using the device while it gets unplugged.
gspca returns -ENODEV, where as pwc returns -EPIPE.

Both make some sense. I've not looked at what other
usb (or other hotplug capable bus) v4l2 drivers do, but
it makes sense to me to standardize on an error here,
preferably a reasonable unique one so that apps can
detect unplug versus other errors. Note that the usb
subsystem returns -ENODEV when you try to (re)submit
an urb from its completion handler, when that
completion handler gets called because the urb was
unlinked because of device unplug.

Given that we often return usb error codes unmodified
and the usb subsys uses -ENODEV for trying to do things
with unplugged devices, I guess it makes sense for
us to also use -ENODEV.

Regards,

Hans
