Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39350 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2BWRZy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 12:25:54 -0500
Received: by vbjk17 with SMTP id k17so964539vbj.19
        for <linux-media@vger.kernel.org>; Thu, 23 Feb 2012 09:25:53 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 23 Feb 2012 22:55:53 +0530
Message-ID: <CAH9_wRN5=nHtB9M3dL4wvZGL3+mb4_TfS=uPun_13D7n0E3CKA@mail.gmail.com>
Subject: Video Capture Issue
From: Sriram V <vshrirama@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
  1) I am trying to get a HDMI to CSI Bridge chip working with OMAP4 ISS.
      The issue is the captured frames are completely green in color.
  2) The Chip is configured to output VGA Color bar sequence with
YUV422-8Bit and
       uses datalane 0 only.
  3) The Format on OMAP4 ISS  is UYVY (Register 0x52001074 = 0x0A00001E)
  I am trying to directly dump the data into memory without ISP processing.


  Please advice.

-- 
Regards,
Sriram
