Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:35694 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdITKvs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 06:51:48 -0400
From: Hans Verkuil <hansverk@cisco.com>
Subject: [ANN] edid-decode on freedesktop.org has been updated to the latest
 CTA-861 spec
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>
Message-ID: <e7c940c9-af96-f97a-0cc6-18abe3550982@cisco.com>
Date: Wed, 20 Sep 2017 12:51:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For anyone interested in decoding an EDID:

The edid-decode utility available from git://anongit.freedesktop.org/xorg/app/edid-decode
has been updated to include the latest CTA-861-G standard. Also many bug fixes were
applied and the utility does a much better job at checking the EDID for inconsistencies
and errors.

I did most of this work about a year ago for Cisco, then was sitting on them until I
finally found the time to upstream the patches. Everything has now been merged, so
I hope it will prove useful to others as well.

Regards,

	Hans
