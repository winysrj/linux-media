Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751946AbdGIQSM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 12:18:12 -0400
From: Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH v2 0/7] [PATCH v2 0/7] Add support of OV9655 camera
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: "H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
 <26a55285-509c-b7f4-7806-db537a582631@st.com>
Message-ID: <24ce3de1-5994-1687-ad97-c0d15c85aff5@kernel.org>
Date: Sun, 9 Jul 2017 18:18:05 +0200
MIME-Version: 1.0
In-Reply-To: <26a55285-509c-b7f4-7806-db537a582631@st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On 07/06/2017 09:51 AM, Hugues FRUCHET wrote:
> Hi Sylwester,
> 
> Do you have the possibility to check for non-regression of this patchset
> on 9650/52 camera ?

I will try to test your patch set once I find the camera module for
my Micro2440SDK board. I've spent already a day on setting up everything 
and fixing multiple regressions in the kernel. I will likely try your 
patch series in coming week.

--
Thanks,
Sylwester
