Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:65144 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754468AbcIEPfx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 11:35:53 -0400
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Hugues FRUCHET <hugues.fruchet@st.com>
Date: Mon, 5 Sep 2016 17:35:45 +0200
Subject: Re: [PATCH v6 0/3] support of v4l2 encoder for STMicroelectronics
 SOC
Message-ID: <6c1dac71-feb6-9116-0493-d640d6adca6e@st.com>
References: <1473084390-14860-1-git-send-email-jean-christophe.trotin@st.com>
 <44323d23-9f1d-b668-5363-dbdd6380fc6f@xs4all.nl>
In-Reply-To: <44323d23-9f1d-b668-5363-dbdd6380fc6f@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/05/2016 04:40 PM, Hans Verkuil wrote:
> I ran checkpatch and it complains (correctly) that the MAINTAINERS file wasn't updated.
> Can you add an entry for this driver to the MAINTAINERS file and post it as a separate
> patch? I promise, that's the last thing I need :-)
>
> Regards,
>
>         Hans
>
> On 09/05/2016 04:06 PM, Jean-Christophe Trotin wrote:
>> version 6:
>> - "depends on HAS_DMA" added in Kconfig
>> - g/s parm only supported for output
>> - V4L2_CAP_TIMEPERFRAME capability set in g/s parm
>> - V4L2 compliance successfully passed with this version (see report below)

[snip]

Hi Hans,

I've just sent a patch that adds an entry to the MAINTAINERS file.
Please let me know if it's not correctly formatted or if you need anything else.

Regards,
Jean-Christophe