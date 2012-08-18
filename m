Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49502 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2HRUiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 16:38:05 -0400
Received: by obbuo13 with SMTP id uo13so7243050obb.19
        for <linux-media@vger.kernel.org>; Sat, 18 Aug 2012 13:38:05 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 19 Aug 2012 02:08:04 +0530
Message-ID: <CAGfW5PFoiO8TNpZ3UF77c1MyUodYKrDKCOgrKT_vCDPXjsBDNQ@mail.gmail.com>
Subject: TV Tuner dmesg errors
From: Rohit Sharma <iamecstatic@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a tv tuner device with two chips cx23102 and Tda18271.
I created a board profile in cx231xx-cards.cc and reinstalled the
driver. Now i see this error in dmesg:
http://pastebin.com/43SJ6bA4


Regards,
Rohit.
