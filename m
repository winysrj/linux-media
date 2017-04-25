Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:57049 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1177299AbdDYKvq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 06:51:46 -0400
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: stih-cec: can you check if it works when there is no HPD?
Message-ID: <9a1fc3ea-8080-6e26-a26f-de635be0c95f@xs4all.nl>
Date: Tue, 25 Apr 2017 12:51:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benjamin,

The CEC specification allows sending certain CEC messages even if there is no HPD
signal. This is for displays that turn off the HPD when they go into standby or
switch to another input, but still keep the CEC bus alive.

Support for this was added to 4.12. But does your driver handle this? Sometimes
when the HPD goes away the HDMI driver powers off the CEC part as well.

I test this with a pulse-eight USB CEC adapter, since it is easy to setup this
situation (just don't connect anything to the TV).

Without that adapter it might be harder to test this.

Regards,

	Hans
