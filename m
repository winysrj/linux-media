Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:15477 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZCREh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 00:37:57 -0400
Received: by yw-out-2324.google.com with SMTP id 3so360776ywj.1
        for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 21:37:55 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Mar 2009 13:32:08 +0900
Message-ID: <5e9665e10903172132g2c433879j14b292d8f5c96268@mail.gmail.com>
Subject: About white balance control.
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: bill@thedirks.org, Hans Verkuil <hverkuil@xs4all.nl>,
	dongsoo45.kim@samsung.com,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I accidently realized today that I was using white balance control in wrong way.

As far as I understand we've got

V4L2_CID_AUTO_WHITE_BALANCE which activate auto white balance
adjustment in runtime,
V4L2_CID_DO_WHITE_BALANCE_TEMPERATURE specifying absolute kelvin value

but can't get what V4L2_CID_DO_WHITE_BALANCE is for.

I think after issuing V4L2_CID_AUTO_WHITE_BALANCE and
V4L2_CID_WHITE_BALANCE_TEMPERATURE,
the white balance functionality works immediately. Isn't it right?

What exactly is the button type V4L2_CID_DO_WHITE_BALANCE for? Because
the V4L2 API document says that "(the value is ignored)". Does that
mean that even we have issued V4L2_CID_AUTO_WHITE_BALANCE and
V4L2_CID_WHITE_BALANCE_TEMPERATURE, we can't see the white balance
working at that moment?

And one more thing. If I want to serve several white balance presets,
like cloudy, dawn, sunny and so on, what should I do?
I think it should be supported as menu type, but most of drivers are
using white balance CID with integer type...then what should I do?
Define preset names with kelvin number like this?

#define WB_CLOUDY 8000

Pretty confusing... anyone knows what should I do?

Nate
