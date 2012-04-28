Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36963 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab2D1KPr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 06:15:47 -0400
Message-ID: <4F9BC350.6010401@iki.fi>
Date: Sat, 28 Apr 2012 13:15:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Demod hardware pid filter implement
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com>, <201204152353103757288@gmail.com>, <201204201601166255937@gmail.com>, <4F9130BB.8060107@iki.fi>, <201204211045557968605@gmail.com>, <4F958640.9010404@iki.fi>, <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>, <4F95CE59.1020005@redhat.com>, <CAF0Ff2m_6fM1QV+Jic7viHXQ7edTe8ZwigjjhdtFwMfhCszuKQ@mail.gmail.com> <201204281717449375969@gmail.com>
In-Reply-To: <201204281717449375969@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28.04.2012 12:17, nibble.max wrote:
> Hello Antti,
> As we known that AF9013 has the hardware pid filter capability.
> How to implement the hardware pid filter, which the demodulator has this capability?
>
> For usb, i find
> struct dvb_usb_adapter_fe_properties {
> int (*pid_filter_ctrl) (struct dvb_usb_adapter *, int);
> int (*pid_filter)      (struct dvb_usb_adapter *, int, u16, int);
> .......
> It can implement the hardware filter if the demodulator has.
>
> But on the other interface, i do not find similar solution.
> For example, we have a hardware of AF9013 and CX23885 pcie chip and want to use the hardware pid filter in AF9013.
> i find some codes to hook the dvb.demux to do that pid filtering.
> I think it is demod property, but the current "dvb_frontend_ops" has no definition for this.
> It is better that adding a function pointer of pid filtering in "dvb_frontend_ops" to do in general way.
> What is your idea?

It is not supported currently - only DVB USB supports it.

In order to PID filter for the demodulator you will need to change DVB 
fronted code. Copy some PID -filtering stuff from the DVB USB to the 
frondend handling.

regards
Antti
-- 
http://palosaari.fi/
