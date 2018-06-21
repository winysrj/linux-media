Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:57648 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932459AbeFUJJq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 05:09:46 -0400
To: "xorg-announce@lists.x.org" <xorg-announce@lists.x.org>,
        xorg@lists.x.org, xorg-devel@lists.x.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Adam Jackson <ajax@nwnk.net>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [ANN] edid-decode maintenance info
Message-ID: <4f89ae25-4ae6-3530-a8f9-171dd39dceb0@cisco.com>
Date: Thu, 21 Jun 2018 10:59:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

As Adam already announced earlier this week I'm taking over maintenance of
the edid-decode utility.

Since I am already maintaining other utilities on git.linuxtv.org I decided
to move the edid-decode git repo to linuxtv.org as well. It is now available
here: https://git.linuxtv.org/edid-decode.git/

Patches, bug reports, etc. should be mailed to linux-media@vger.kernel.org
(see https://linuxtv.org/lists.php). Please make sure the subject line
contains 'edid-decode'.

One thing I would like to tackle in the very near future is to add support for
the new HDMI 2.1b EDID additions.

I also know that some patches for edid-decode were posted to xorg-devel that
were never applied. I will try to find them, but to be safe it is best to
repost them to linux-media.

Regards,

	Hans Verkuil
