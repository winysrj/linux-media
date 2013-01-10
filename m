Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3AJLsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 06:48:32 -0500
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: "'Antti Palosaari'" <crope@iki.fi>
Cc: <linux-media@vger.kernel.org>
References: <000801cdef1f$70667580$51336080$@codeaurora.org> <50EEA240.4060803@iki.fi>
In-Reply-To: <50EEA240.4060803@iki.fi>
Subject: RE: [dvb] Question on dvb-core re-structure
Date: Thu, 10 Jan 2013 13:49:52 +0200
Message-ID: <000901cdef28$9ba87050$d2f950f0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/2013 1:13 PM, Antti Palosaari wrote:
> I could guess that even for the SoCs there is some bus used internally. 
> If it is not one of those already existing, then create new directly just
like one of those existing and put it there.

Thanks for the answer. I just wanted to clarify - it's integrated into the
chip and accessed via memory mapped registers, so I'm not sure which
category to give the new directory (parallel to pci/mms/usb). Should I just
put the adapter's sources directory directly under media directory?


Thanks,

--
Hamad Kadmany,
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by
The Linux Foundation

