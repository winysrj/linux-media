Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:45695 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754867Ab0AMKSW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 05:18:22 -0500
Message-ID: <4B4D9DEB.1030306@panicking.kicks-ass.org>
Date: Wed, 13 Jan 2010 11:18:19 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Nishanth Menon <menon.nishanth@gmail.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ISP OMAP3 camera support ov7690
References: <4AC7DAAD.2020203@panicking.kicks-ass.org> <4AC8B764.2030101@gmail.com> <4AC93DC9.2080809@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE89444CB3A2CB@dlee02.ent.ti.com> <4B4C75F0.3060108@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE8944514AC214@dlee02.ent.ti.com> <4B4CB241.6050603@panicking.kicks-ass.org> <4B4CE976.5050503@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE8944514AC7F3@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944514AC7F3@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have done a step ahead maybe:

The camera has this output format:

YUYV     ---> the first use the CCDC_OTHERS_MEM, so seems that it needs the WEN signal to syncronize (I don't have this one)
RGB565   ---> is not supported
RAW8     ---> is supported by the ISP but seems that is not implemented as a isp formats

So I can't use the first one but I can use the last one because the pipeline support RAW format,
the data path is the same of RAW10 expet for the autofocus module. If all is correct what are the steps?

- add the isp_format
- add in the if confidition this data format and use the same path of RAW10
...

Regards

Michael
