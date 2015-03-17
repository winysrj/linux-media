Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:40640 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbbCQIM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2015 04:12:58 -0400
Message-ID: <5507E1DF.9080505@st.com>
Date: Tue, 17 Mar 2015 09:12:15 +0100
From: Patrice Chotard <patrice.chotard@st.com>
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>
Subject: Re: [PATCH 23/35 linux-next] [media] constify of_device_id array
References: <1426533469-25458-1-git-send-email-fabf@skynet.be> <1426535685-25996-1-git-send-email-fabf@skynet.be> <1426535685-25996-2-git-send-email-fabf@skynet.be>
In-Reply-To: <1426535685-25996-2-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabian

On 03/16/2015 08:54 PM, Fabian Frederick wrote:
> of_device_id is always used as const.
> (See driver.of_match_table and open firmware functions)
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
...
>   drivers/media/rc/st_rc.c                     | 2 +-

For this driver

Acked-by: Patrice Chotard <patrice.chotard@st.com>

Thanks

