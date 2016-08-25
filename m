Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33411 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933301AbcHYLpw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 07:45:52 -0400
Received: by mail-wm0-f54.google.com with SMTP id d196so38188822wmd.0
        for <linux-media@vger.kernel.org>; Thu, 25 Aug 2016 04:45:51 -0700 (PDT)
Date: Thu, 25 Aug 2016 12:45:48 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Yannick Fertre <yannick.fertre@st.com>, kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v4 0/3] support of v4l2 encoder for
 STMicroelectronics SOC
Message-ID: <20160825114548.GC3281@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1469457850-17973-1-git-send-email-jean-christophe.trotin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1469457850-17973-1-git-send-email-jean-christophe.trotin@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Christophe,

On Mon, 25 Jul 2016, Jean-Christophe Trotin wrote:

> version 4:
> - Module renamed "st-hva" as suggested by Hans
> - resource_size() inline function used to calculate the esram size
> - V4L2 compliance successfully passed with this version (see report below)

For the series: -

Acked-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter.
