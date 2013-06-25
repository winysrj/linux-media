Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:57532 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458Ab3FYHgA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 03:36:00 -0400
From: Libin Yang <lbyang@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"albert.v.wang@gmail.com" <albert.v.wang@gmail.com>
Date: Tue, 25 Jun 2013 00:33:29 -0700
Subject: RE: [PATCH 2/7] marvell-ccic: add clock tree support for
 marvell-ccic driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF4498FF5C90@SC-VEXCH4.marvell.com>
References: <1370324564.26072.22.camel@younglee-desktop>
 <20130621110224.6adf7492@lwn.net>
In-Reply-To: <20130621110224.6adf7492@lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

Do you mean using IS_ERR() here directly? I think it should be OK. I will change to IS_ERR() in next version.

Regards,
Libin  

>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net] 
>Sent: Saturday, June 22, 2013 1:02 AM
>To: Libin Yang
>Cc: g.liakhovetski@gmx.de; mchehab@redhat.com; 
>linux-media@vger.kernel.org; albert.v.wang@gmail.com
>Subject: Re: [PATCH 2/7] marvell-ccic: add clock tree support 
>for marvell-ccic driver
>
>On Tue, 4 Jun 2013 13:42:44 +0800
>lbyang <lbyang@marvell.com> wrote:
>
>> +static void mcam_clk_enable(struct mcam_camera *mcam) {
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < NR_MCAM_CLK; i++) {
>> +		if (!IS_ERR_OR_NULL(mcam->clk[i]))
>> +			clk_prepare_enable(mcam->clk[i]);
>> +	}
>> +}
>
>It seems I already acked this patch, and I won't take that 
>back.  I will point out, though, that IS_ERR_OR_NULL has 
>become a sort of lightning rod and that its use is probably 
>best avoided.
>
>	
>http://lists.infradead.org/pipermail/linux-arm-kernel/2013-Janu
>ary/140543.html
>
>This relates to the use of ERR_PTR with that particular 
>pointer value; I still think just using NULL is better, but 
>maybe I'm missing something.
>
>jon
>