Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40251 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbZGGNli (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2009 09:41:38 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n67DfcOb003680
	for <linux-media@vger.kernel.org>; Tue, 7 Jul 2009 09:41:38 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n67DfbSi017077
	for <linux-media@vger.kernel.org>; Tue, 7 Jul 2009 09:41:37 -0400
Received: from localhost.localdomain (vpn-10-15.str.redhat.com [10.32.10.15])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n67DfZRs030507
	for <linux-media@vger.kernel.org>; Tue, 7 Jul 2009 09:41:36 -0400
Message-ID: <4A53509D.8060503@redhat.com>
Date: Tue, 07 Jul 2009 15:41:49 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: howto handle driver changes which require libv4l > x.y ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

So recently I've hit 2 issues where kernel side fixes need
to go hand in hand with libv4l updates to not cause regressions.

First lets discuss the 2 cases:
1) The pac207 driver currently limits the framerate (and thus
    the minimum exposure time) because at higher framerate the
    cam starts using a higher compression and we could not
    decompress this. Thanks to Bertrik Sikken we can now handle
    the higher decompression.

    So no I really want to enable the higher framerates as those
    are needed to make the cam work properly in full daylight.

    But if I do this, things will regress for people with an
    older libv4l, as that won't be able to decompress the frames

2) Several zc3xxx cams have a timing issue between the bridge and
    the sensor (the windows drivers have the same issue) which
    makes them do only 320x236 instead of 320x240. Currently
    we report their resolution to userspace as 320x240, leading to
    a bar of noise at the bottom of the screen.

    The fix here obviously is to report the real effective resoltion
    to userspace, but this will cause regressions for apps which blindly
    assume 320x240 is available (such as skype). The latest libv4l will
    make the apps happy again by giving them 320x240 by adding small
    black borders.


Now I see 2 solutions here:

a) Just make the changes, seen from the kernel side these are most
    certainly bugfixes. I tend towards this for case 2)

b) Come up with an API to tell the libv4l version to the kernel and
    make these changes in the drivers conditional on the libv4l version


So this is my dilemma, your input is greatly appreciated.

Regards,

Hans
