Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33812 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751277AbdK0JN5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 04:13:57 -0500
Subject: Re: [PATCH 0/3] Improve CEC autorepeat handling
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
References: <cover.1511523174.git.sean@mess.org>
 <20171125234752.2z46d3ya7qiaovby@dtor-ws>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <27b40fb8-a422-e43d-45d4-b4f763f7b82a@xs4all.nl>
Date: Mon, 27 Nov 2017 10:13:51 +0100
MIME-Version: 1.0
In-Reply-To: <20171125234752.2z46d3ya7qiaovby@dtor-ws>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/2017 12:47 AM, Dmitry Torokhov wrote:
> Hi Sean,
> 
> On Fri, Nov 24, 2017 at 11:43:58AM +0000, Sean Young wrote:
>> Due to the slowness of the CEC bus, autorepeat handling rather special
>> on CEC. If the repeated user control pressed message is received, a 
>> keydown repeat should be sent immediately.
> 
> This sounds like you want to have hardware autorepeat combined with
> software one. This seems fairly specific to CEC and I do not think that
> this should be in input core; but stay in the driver.
> 
> Another option just to decide what common delay for CEC autorepeat is
> and rely on the standard autorepeat handling. The benefit is that users
> can control the delay before autorepeat kicks in.

They are not allowed to. Autorepeat is only allowed to start when a second
keydown message arrives within 550 ms as per the spec. After that autorepeat
continues as long as keydown messages are received within 550ms from the
previous one. The actual REP_PERIOD time is unrelated to the frequency of
the CEC messages but should be that of the local system.

The thing to remember here is that CEC is slooow (400 bits/s) so you cannot
send messages at REP_PERIOD rate. You should see it as messages that tell
you to enter/stay in autorepeat mode. Not as actual autorepeat messages.

> 
>>
>> By handling this in the input layer, we can remove some ugly code from
>> cec, which also sends a keyup event after the first keydown, to prevent
>> autorepeat.
> 
> If driver does not want input core to handle autorepeat (but handle
> autorepeat by themselves) they should indicate it by setting appropriate
> dev->rep[REP_DELAY] and dev->rep[REP_PERIOD] before calling
> input_register_device(). This will let input core know that it should
> not setup its autorepeat timer.

That only means that I have to setup the autorepeat timer myself, there
is no benefit in that :-)

Sean, I kind of agree with Dmitry here. The way autorepeat works for CEC
is pretty specific to that protocol and unlikely to be needed for other
protocols.

It is also no big deal to keep knowledge of that within cec-adap.c.

The only thing that would be nice to have control over is that with CEC
userspace shouldn't be able to change REP_DELAY and that REP_DELAY should
always be identical to REP_PERIOD. If this can be done easily, then that
would be nice, but it's a nice-to-have in my opinion.

Regards,

	Hans
