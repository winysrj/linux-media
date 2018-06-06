Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:10878
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752120AbeFFMmA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Jun 2018 08:42:00 -0400
Date: Wed, 6 Jun 2018 21:41:53 +0900 (JST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: mchehab@kernel.org, hans.verkuil@cisco.com
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: unnecessary tests?
Message-ID: <alpine.DEB.2.20.1806062139460.4445@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the file drivers/media/tuners/mxl5005s.c, the function MXL_BlockInit
contains:

       status += MXL_ControlWrite(fe,
               RFSYN_EN_CHP_HIGAIN, state->Mode ? 1 : 1);
       status += MXL_ControlWrite(fe, EN_CHP_LIN_B, state->Mode ? 0 : 0);

Could the second arguments just be 1 and 0, respectively?  It's true that
the preceeding call contains state->Mode, but in a more useful way, so
perhaps it could be useful for uniformity?

thanks,
julia
