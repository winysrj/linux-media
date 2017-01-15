Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35753 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751206AbdAOTRs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Jan 2017 14:17:48 -0500
Received: by mail-lf0-f67.google.com with SMTP id v186so10421545lfa.2
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2017 11:17:47 -0800 (PST)
Received: from tuttifrutti.hemmavid ([92.254.128.62])
        by smtp.googlemail.com with ESMTPSA id l138sm2867660lfg.34.2017.01.15.11.17.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Jan 2017 11:17:46 -0800 (PST)
To: linux-media@vger.kernel.org
From: =?UTF-8?B?SMOla2FuIExlbm5lc3TDpWw=?= <hakan.lennestal@gmail.com>
Subject: Re: [OOPS] EM28xx with 4.9.x kernel
Message-ID: <00fec1c1-5ccc-fdad-39e1-86bace4b62bf@gmail.com>
Date: Sun, 15 Jan 2017 20:17:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi !

A workaround for this problem seem to be to enable GPIOLIB in the kernel 
(Device Drivers -> GPIO support).

Regards.

/Håkan

