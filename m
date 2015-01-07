Return-path: <linux-media-owner@vger.kernel.org>
Received: from dub004-omc2s32.hotmail.com ([157.55.1.171]:56032 "EHLO
	DUB004-OMC2S32.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbbAGKIg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jan 2015 05:08:36 -0500
Message-ID: <DUB128-W616FABD8864A79107E5C809C460@phx.gbl>
From: David Binderman <dcb314@hotmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: tuners/mxl5005s.c: 2 * ternary operator problems ?
Date: Wed, 7 Jan 2015 10:03:32 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello there,

[linux-3.19-rc3/drivers/media/tuners/mxl5005s.c:1817]: (style) Same expression in both branches of ternary operator.
[linux-3.19-rc3/drivers/media/tuners/mxl5005s.c:1818]: (style) Same expression in both branches of ternary operator.

Source code is

    status += MXL_ControlWrite(fe,
        RFSYN_EN_CHP_HIGAIN, state->Mode ? 1 : 1);
    status += MXL_ControlWrite(fe, EN_CHP_LIN_B, state->Mode ? 0 : 0);

Suggest code rework.

Regards

David Binderman
 		 	   		  