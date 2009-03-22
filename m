Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]:56185 "EHLO
	ctsmtpout2.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752673AbZCVVbR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 17:31:17 -0400
Received: from jar.dominio (80.25.230.35) by ctsmtpout2.frontal.correo (7.2.056.6) (authenticated as jareguero$telefonica.net)
        id 49B4D7130056B319 for linux-media@vger.kernel.org; Sun, 22 Mar 2009 22:31:14 +0100
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: Bug in  mxl5005s driver
Date: Sun, 22 Mar 2009 22:31:12 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903222231.12769.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In line 3992:

        if (fe->ops.info.type == FE_ATSC) {
                switch (params->u.vsb.modulation) {
                case VSB_8:
                        req_mode = MXL_ATSC; break;
                default:
                case QAM_64:
                case QAM_256:
                case QAM_AUTO:
                        req_mode = MXL_QAM; break;
                }
        } else
                req_mode = MXL_DVBT;

req_mode is filled with MXL_ATSC, MXL_QAM, or MXL_DVBT

and in line 4007 req_mode is used like params->u.vsb.modulation

                switch (req_mode) {
                case VSB_8:
                case QAM_64:
                case QAM_256:
                case QAM_AUTO:
                        req_bw  = MXL5005S_BANDWIDTH_6MHZ;
                        break;
                default:
                        /* Assume DVB-T */
                        switch (params->u.ofdm.bandwidth) {
                        case BANDWIDTH_6_MHZ:
                                req_bw  = MXL5005S_BANDWIDTH_6MHZ;
                                break;
                        case BANDWIDTH_7_MHZ:
                                req_bw  = MXL5005S_BANDWIDTH_7MHZ;
                                break;
                        case BANDWIDTH_AUTO:
                        case BANDWIDTH_8_MHZ:


Jose Alberto Reguero


