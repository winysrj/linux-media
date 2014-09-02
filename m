Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:43059 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaIBOsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 10:48:14 -0400
Received: by mail-oi0-f44.google.com with SMTP id i138so4506477oig.17
        for <linux-media@vger.kernel.org>; Tue, 02 Sep 2014 07:48:13 -0700 (PDT)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 2 Sep 2014 16:47:58 +0200
Message-ID: <CAL8zT=gEXzeP1KPJZBrDUOQWRotvV8XidPuoeQZecKLKCdJEPw@mail.gmail.com>
Subject: ADV76xx : Endpoint parsing
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurentp@cse-semaphore.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, lars@metafoo.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to understand how endpoint parsing is done in adv7604/11
and the main objective is to get adv7604 endpoint parsing from DT for
all its ports (4 HDMI and one VGA as input, one output).
I am stuck on the function adv7604_parse_dt().
Tell me if I am wrong, but this function takes the first endpoint from
DT, puts the node, and that's all...

At least for ADV7611, there is two endpoints : one HDMI as input, one output.
I am not even sure that this function gets both...

And last but not least, how can we get support for all endpoints in
the ADV7604 case ?

Thanks,
JM
