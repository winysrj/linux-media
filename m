Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35363 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3KZVbU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 16:31:20 -0500
Date: Wed, 27 Nov 2013 00:31:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: pboettcher@kernellabs.com
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: re: [media] dib8000: enhancement
Message-ID: <20131126213112.GB20597@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Patrick Boettcher,

The patch 173a64cb3fcf: "[media] dib8000: enhancement" from Apr 22, 2013, leads to the following
static checker warning: "drivers/media/dvb-frontends/dib8000.c:2074 dib8000_get_init_prbs()
	 error: buffer overflow 'lut_prbs_8k' 14 <= 14"

drivers/media/dvb-frontends/dib8000.c
  3176          case CT_DEMOD_STEP_11:  /* 41 : init prbs autosearch */
  3177                          if (state->subchannel <= 41) {
                                    ^^^^^^^^^^^^^^^^^^^^^^^
  3178                                  dib8000_set_subchannel_prbs(state, dib8000_get_init_prbs(state, state->subchannel));
                                                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If state->subchannel == 41 then we go one space beyond the end of the
arrays in dib8000_get_init_prbs().  "41 / 3 + 1" is 14 and there are
only 14 elements in the arrays so we are reading one space beyond the
end of the array.

  3179                                  *tune_state = CT_DEMOD_STEP_9;
  3180                          } else {
  3181                                  *tune_state = CT_DEMOD_STOP;
  3182                                  state->status = FE_STATUS_TUNE_FAILED;
  3183                          }
  3184                          break;
  3185  

regards,
dan carpenter

