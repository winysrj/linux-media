Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:46540 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbdKYXrz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Nov 2017 18:47:55 -0500
Date: Sat, 25 Nov 2017 15:47:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sean Young <sean@mess.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Improve CEC autorepeat handling
Message-ID: <20171125234752.2z46d3ya7qiaovby@dtor-ws>
References: <cover.1511523174.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1511523174.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Fri, Nov 24, 2017 at 11:43:58AM +0000, Sean Young wrote:
> Due to the slowness of the CEC bus, autorepeat handling rather special
> on CEC. If the repeated user control pressed message is received, a 
> keydown repeat should be sent immediately.

This sounds like you want to have hardware autorepeat combined with
software one. This seems fairly specific to CEC and I do not think that
this should be in input core; but stay in the driver.

Another option just to decide what common delay for CEC autorepeat is
and rely on the standard autorepeat handling. The benefit is that users
can control the delay before autorepeat kicks in.

> 
> By handling this in the input layer, we can remove some ugly code from
> cec, which also sends a keyup event after the first keydown, to prevent
> autorepeat.

If driver does not want input core to handle autorepeat (but handle
autorepeat by themselves) they should indicate it by setting appropriate
dev->rep[REP_DELAY] and dev->rep[REP_PERIOD] before calling
input_register_device(). This will let input core know that it should
not setup its autorepeat timer.

Thanks.

-- 
Dmitry
