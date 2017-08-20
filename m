Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36916 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbdHTNJf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 09:09:35 -0400
Received: by mail-qk0-f176.google.com with SMTP id z18so72097095qka.4
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 06:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2bed1912-2c1c-d753-dbf6-8e032c902793@samsung.com>
References: <20170804104155.37386-1-hverkuil@xs4all.nl> <CGME20170816084045epcas2p435b2d7ef400710156d28a6e6bdf90efd@epcas2p4.samsung.com>
 <20170804104155.37386-2-hverkuil@xs4all.nl> <2bed1912-2c1c-d753-dbf6-8e032c902793@samsung.com>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Sun, 20 Aug 2017 15:09:34 +0200
Message-ID: <CA+M3ks7=U5WAPFxQXL=zxzPnw3VX4OZjX-t_6HLZB556mbW62w@mail.gmail.com>
Subject: Re: [PATCH 1/5] media/cec.h: add CEC_CAP_DEFAULTS
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-08-16 10:40 GMT+02:00 Sylwester Nawrocki <s.nawrocki@samsung.com>:
> On 08/04/2017 12:41 PM, Hans Verkuil wrote:
>
>> The CEC_CAP_LOG_ADDRS, CEC_CAP_TRANSMIT, CEC_CAP_PASSTHROUGH and
>> CEC_CAP_RC capabilities are normally always present.
>>
>> Add a CEC_CAP_DEFAULTS define that ORs these four caps to simplify
>> drivers.
>>
>> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
>
>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Reviewed-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
