Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:47962 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbZDWTkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 15:40:23 -0400
Received: by bwz7 with SMTP id 7so733989bwz.37
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2009 12:40:21 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Apr 2009 23:40:21 +0400
Message-ID: <1a297b360904231240r3952f6cdt1205aff6f623ae31@mail.gmail.com>
Subject: TT S2 1600 status
From: Manu Abraham <abraham.manu@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Support for the TT S2-1600 has been updated. Please do test. The 903
demodulator
officially supports 45MSPS, with an unofficial max up to 63MSPS with
8PSK DVB-S2.
(standard DVB-S2 demodulators support upto 30MSPS)

Support is found on the v4l-dvb hg tree on jusst.de

Testers, Feedback welcome.

Regards,
Manu
