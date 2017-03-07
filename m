Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:53318 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755283AbdCGL4i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 06:56:38 -0500
Subject: Re: Status of CEC?
To: Jose Abreu <Jose.Abreu@synopsys.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <02063912-88cf-0832-891c-9deb10c45a0c@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <d76f9635-e387-46af-65f0-0d3b4ee21a90@cisco.com>
Date: Tue, 7 Mar 2017 12:53:04 +0100
MIME-Version: 1.0
In-Reply-To: <02063912-88cf-0832-891c-9deb10c45a0c@synopsys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/2017 12:44 PM, Jose Abreu wrote:
> Hi Hans,
>
>
> I'm writing to you in order to get more details about current CEC
> implementation status. I've seen the code and it appears you have
> already support for CEC 2.0, right? I've also seen the
> implementation in adv7511 of CEC and I've extracted the following
> sequence:
>
>     1) Call cec_allocate_adapter with given flags and given
> cec_adap_ops (enable, log_addr, transmit, ...)
>
>     2) Call cec_register_adapter when all datapath is configured
>
>     3) Call cec_received_msg when a msg is received
>
> Is there anything missing? Can you please confirm that these are
> the essential points in order to implement CEC?

And you need to implement a few callbacks:

adap_enable, adap_log_addr and adap_transmit at minimum.

See also:

https://hverkuil.home.xs4all.nl/spec/kapi/cec-core.html

Starting with 4.10 the CEC framework is now mainlined.

The main missing piece is this:

https://www.spinics.net/lists/linux-samsung-soc/msg58035.html

I need to make a v5 of this patch series. Whether you need this or
not depends on your HW architecture.

>
>
> And about userspace: It should implement the logic of formating
> and the following the messages to cec core, right? Does cec-ctl
> utility and cec-funcs.h already handles CEC 2.0?

Yes. In fact, by default cec-ctl will configure a CEC adapter as a
2.0 CEC device.

Also see cec-compliance to do CEC protocol compliance testing and
cec-follower, which will emulate a CEC device as a follower.

The code in cec-follower is dual licensed as GPLv2 and BSD, so you
can use code from that when you write your own follower. The cec
public headers (including cec-funcs.h) are all dual licensed.

Regards,

	Hans
