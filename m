Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33642 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbbJDQST (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2015 12:18:19 -0400
Received: by oixx17 with SMTP id x17so79910475oix.0
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2015 09:18:18 -0700 (PDT)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Sun, 4 Oct 2015 18:17:59 +0200
Message-ID: <CAH-u=81zwkTxjYEsO8rNLf687-nGuj3DdJNeF6bmnxSUSVYQQg@mail.gmail.com>
Subject: [RFC] ADV7604: VGA support
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I had another look into the ADV7604 HW manual, and I understand that
in automatic mode, there is 4 AIN_SEL values possible, determining the
connection on AIN pins.
Now, having a look at the current ADV76xx files, I can see that two
pads are there :
ADV7604_PAD_VGA_RGB and ADV7604_PAD_VGA_COMP.

According to the manual, my understanding is that we should have four
HDMI pads and four analog pads. The latter would be configured as RGB
or component, which allows four analog inputs as described in the HW
manual.

I don't know if you agree with that or if you had something else in
mind when designing it in the first place, I may have missed something
(Lars :) ?).

Thanks,
JM
