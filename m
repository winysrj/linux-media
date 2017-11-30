Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:45536 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdK3TJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 14:09:30 -0500
Received: by mail-ot0-f175.google.com with SMTP id j64so7017146otj.12
        for <linux-media@vger.kernel.org>; Thu, 30 Nov 2017 11:09:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511975472-26659-4-git-send-email-hugues.fruchet@st.com>
References: <1511975472-26659-1-git-send-email-hugues.fruchet@st.com> <1511975472-26659-4-git-send-email-hugues.fruchet@st.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 30 Nov 2017 17:09:29 -0200
Message-ID: <CAOMZO5CbE6WQ8eAov2L2QB0Pkt8LiO1eOfKo4iKcQqNZ60wMXg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] media: ov5640: add support of DVP parallel interface
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Wed, Nov 29, 2017 at 3:11 PM, Hugues Fruchet <hugues.fruchet@st.com> wrote:
> Add support of DVP parallel mode in addition of
> existing MIPI CSI mode. The choice between two modes
> and configuration is made through device tree.

What about explaining how to select between the two modes in
Documentation/devicetree/bindings/media/i2c/ov5640.txt ?

Thanks
