Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:40651 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932474AbdCGOsf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 09:48:35 -0500
From: Jose Abreu <Jose.Abreu@synopsys.com>
Subject: Status of CEC?
To: <hans.verkuil@cisco.com>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <02063912-88cf-0832-891c-9deb10c45a0c@synopsys.com>
Date: Tue, 7 Mar 2017 11:44:01 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


I'm writing to you in order to get more details about current CEC
implementation status. I've seen the code and it appears you have
already support for CEC 2.0, right? I've also seen the
implementation in adv7511 of CEC and I've extracted the following
sequence:

    1) Call cec_allocate_adapter with given flags and given
cec_adap_ops (enable, log_addr, transmit, ...)

    2) Call cec_register_adapter when all datapath is configured

    3) Call cec_received_msg when a msg is received

Is there anything missing? Can you please confirm that these are
the essential points in order to implement CEC?


And about userspace: It should implement the logic of formating
and the following the messages to cec core, right? Does cec-ctl
utility and cec-funcs.h already handles CEC 2.0?


Thank you in advance for your help.


With best regards,

Jose Miguel Abreu
