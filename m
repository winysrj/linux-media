Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:38145 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751304AbdIKU4G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 16:56:06 -0400
Received: by mail-io0-f172.google.com with SMTP id n69so33750852ioi.5
        for <linux-media@vger.kernel.org>; Mon, 11 Sep 2017 13:56:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831110156.11018-4-hverkuil@xs4all.nl>
References: <20170831110156.11018-1-hverkuil@xs4all.nl> <20170831110156.11018-4-hverkuil@xs4all.nl>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 11 Sep 2017 22:56:04 +0200
Message-ID: <CACRpkdY195waN-SY2sKNhVBmz9pwAdriLPY14bqH7RakT86sKg@mail.gmail.com>
Subject: Re: [PATCHv4 3/5] dt-bindings: document the CEC GPIO bindings
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 31, 2017 at 1:01 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> +       cec-gpio = <&gpio 7 GPIO_OPEN_DRAIN>;

Actually if you want to be 100% specific:

cec-gpio = <&gpio 7 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;

(Parens are needed.)

But I'm not very picky about that, active high is implicit.

Yours,
Linus Walleij
