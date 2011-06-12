Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45936 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1FLVmR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 17:42:17 -0400
Received: by fxm17 with SMTP id 17so2389643fxm.19
        for <linux-media@vger.kernel.org>; Sun, 12 Jun 2011 14:42:16 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Jun 2011 07:42:16 +1000
Message-ID: <BANLkTi=BTbJFrYntdJDtAaBpznLZNgkWwA@mail.gmail.com>
Subject: Request: Change to /usr/share/dvb/dvb-t/au-Sydney_North_Shore
From: sollis <sollis@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

The entry for Channel 44 in Sydney needs to be modified in order to
tune in TVS in Sydney.

The following changes need to be made: (update to frequency)

# D44 UHF35
#T 578500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE
T 536625000 7MHz 2/3 NONE QAM64 8k 1/32 NONE

This information was derived from http://www.tvs.org.au/get-involved/tune-in

Steve Ollis

"There are 10 types of people in this world - Those that can count in
binary, and those that can't."
