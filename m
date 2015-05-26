Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35830 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbbEZMca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 08:32:30 -0400
Received: by wgme6 with SMTP id e6so27185824wgm.2
        for <linux-media@vger.kernel.org>; Tue, 26 May 2015 05:30:52 -0700 (PDT)
Message-ID: <556465E1.8000009@gmail.com>
Date: Tue, 26 May 2015 14:24:01 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: dvb_usb_af9015: command failed=1 _ kernel >=  4.1.x
References: <554C8E04.5090007@gmail.com> <554C9704.2040503@gmail.com> <554F352F.10301@gmail.com> <554FDAE7.4010906@gmail.com> <5550F842.3050604@gmail.com> <55520A08.1010605@iki.fi> <5552CB67.8070106@gmail.com> <5557CDBE.2030806@iki.fi> <555A3A48.2010002@gmail.com> <555E4CEF.4000901@gmail.com>
In-Reply-To: <555E4CEF.4000901@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


If it is not taken into account the already known problem of unreliable operation of the first tuner of the two,
the device works reliably within kernel 4.0.4 with mxl5007t.ko reverted to
http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/drivers/media/tuners/mxl5007t.c?id=ccae7af
that is in the same state as is in the longterm kernel - 3.18.14,
which is in correspondence with the aforementioned results.


