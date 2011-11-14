Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33655 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1KNNfL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 08:35:11 -0500
Received: by gyc15 with SMTP id 15so4872248gyc.19
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 05:35:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB33W8cJYoXe+1yCPhEGgSpHM7AYd_b-sm5dSy8g+jT=98X=eg@mail.gmail.com>
References: <CAB33W8dW0Yts_dxz=WyYEK9-bcoQ_9gM-t3+aR5s-G_5QswOyA@mail.gmail.com>
	<CAB33W8eMEG6cxM9x0aGRe+1xx6TwvjBZL4KSdRY4Ti2sTHk9hg@mail.gmail.com>
	<CAL9G6WXq_MSu+6Ogjis43bsszDri0y5JQrhHrAQ8tiTKv09YKQ@mail.gmail.com>
	<CAATJ+ftr76OMckcpf_ceX4cPwv0840C9HL+UuHivAtub+OC+jw@mail.gmail.com>
	<4ebdacc2.04c6e30a.29e4.58ff@mx.google.com>
	<CAB33W8eYnQbKAkNobiez0yH5tgCVN4s84ncT5cmKHxeqHm8P3Q@mail.gmail.com>
	<CAL9G6WXHfA-n0u_yB7QvUAN_8TxSSA2M_O0m6kbsOrcgE+nMsA@mail.gmail.com>
	<CAB33W8cJYoXe+1yCPhEGgSpHM7AYd_b-sm5dSy8g+jT=98X=eg@mail.gmail.com>
Date: Mon, 14 Nov 2011 13:35:10 +0000
Message-ID: <CAB33W8eTZg3Q9xZg9Ebz5C+Cb_H2SHH_R1u30V4i+_Oe8N1ysA@mail.gmail.com>
Subject: Re: AF9015 Dual tuner i2c write failures
From: Tim Draper <veehexx@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ok, looks like the patch has fixed the issue in my initial response,
but now i've got a new issue (related?) when i reboot - the
dvb-usb-af9015 module is not being loaded.

if i try to modprobe it (sudo modprobe dvb-usb-af9015), then i get the error:
FATAL: Error inserting dvb_usb_af9015
(/lib/modules/2.6.38-12-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-af9015.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

dmesg |tail:
[  170.406969] dvb_usb_af9015: Unknown parameter `adapter'

thats the only 2 lines related to the issue.

what i did was apply the patch that Malcolm sent to me, and then
rebooted. af9015 still not working, so removed USB device and
reinserted. tuner now worked flawlessly.
gave the PC a reboot, and now i've got the above error.

any ideas?
