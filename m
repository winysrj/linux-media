Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40363 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750733AbdE3Gx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 02:53:29 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [ANN] HDMI CEC Status Update
Message-ID: <8e277103-8bc5-34b2-411d-e396665df249@xs4all.nl>
Date: Tue, 30 May 2017 08:53:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For those who are interested in HDMI CEC support I made a little status
document that I intend to keep up to date:

https://hverkuil.home.xs4all.nl/cec-status.txt

My goal is to get CEC supported for any mainlined HDMI driver where the hardware
supports CEC.

If anyone is working on a CEC driver that I don't know already about, just drop
me an email so I can update the status.

I also started maintaining a list of DisplayPort to HDMI adapters that support
CEC. If you have one that works and is not on the list, then please let me know.
Seeing /dev/cecX is not enough, some adapters do not connect the CEC pin, so they
won't be able to detect any other CEC devices. See the test instructions in the
cec-status.txt file on how to make sure the adapter has a working CEC pin. I
plan to do some more testing this week, so hopefully the list will expand.

Thanks!

	Hans
