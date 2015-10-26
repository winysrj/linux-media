Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:32963 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbbJZO5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 10:57:46 -0400
Received: by oiad129 with SMTP id d129so101646988oia.0
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2015 07:57:45 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 Oct 2015 15:57:45 +0100
Message-ID: <CAPW4HR13x2Qk2C18QT_wHvUMqMzdiy28Bj-NojX2E59BzJeUvQ@mail.gmail.com>
Subject: [RFC] Snapshot Mode and Interrupt Trigger
From: =?UTF-8?Q?Carlos_Sanmart=C3=ADn_Bustos?= <carsanbu@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I was searching in the list if there is some RFC to implement some
kind of snapshot mode in the API. I found a conversation [1] but it
turned to flash capabilities.

The thing is, there are sensors with hardware trigger modes (a.k.a.
snapshot modes) but there is not any standard form to deal with it. We
can use v4l-controls to set this modes and continue using streaming
API, it's an option.

But in the other hand, if our sensor hasn't got snapshot mode or we
can't use it, could be a nice option trigger the sensor by software
using interrupts, like IIO triggers' do.

At that point I'm thinking if it's possible to define a snapshot API
for use the sensor's snapshot mode or the software snapshot mode
reusing the IIO API, maybe using MC Next Gen for that.

Suggestions?


[1] http://www.spinics.net/lists/linux-media/msg29368.html


-- 
Carlos Sanmartín
