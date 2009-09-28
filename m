Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45013 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZI1PyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 11:54:12 -0400
Received: by fxm18 with SMTP id 18so3770091fxm.17
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 08:54:15 -0700 (PDT)
Message-ID: <4AC0DC20.2070307@gmail.com>
Date: Mon, 28 Sep 2009 23:54:08 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: CX23885 card Analog/Digital Switch 
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello List,

cx23885 card Magic-Pro ProHDTV Extreme 2, has a cx23885 GPIO pin to
select Analog TV+Radio or Digital TV. How should I add that GPIO setting 
code into cx23885?
The current model that all operations goes to FE instead of card is not 
very appropriate to model this case.
I thought of adding a callback code for the tuner (XC5000), but my case
  is that this behavior is card specific, but not XC5000 generic.

Is there any "Input Selection" hook / callback mechanism to notify the 
card, the device.

Regards,
David T.L. Wong
