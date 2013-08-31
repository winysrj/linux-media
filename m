Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:53368 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3HaP4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 11:56:37 -0400
Received: by mail-qa0-f47.google.com with SMTP id j7so275091qaq.6
        for <linux-media@vger.kernel.org>; Sat, 31 Aug 2013 08:56:36 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 31 Aug 2013 17:56:36 +0200
Message-ID: <CAAyapewj+zbaGCikx7cwi1_GzY1BNLeitcHJgLLT0VpVGRSQLQ@mail.gmail.com>
Subject: Kernel 3.10.x Regression
From: mario tillmann <mario.t4man@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could someone please look at these issue
posted in bugzilla as well as in two separate mails:

https://bugzilla.kernel.org/show_bug.cgi?id=60645
http://www.spinics.net/lists/linux-media/msg66804.html
http://www.spinics.net/lists/linux-media/msg67107.html

On Thu, Aug 08, 2013 at 05:52:53PM +0200, mario tillmann wrote:
> With the latest kernel 3.10.x I get an error message when loading the firmware
> sms1xxx-hcw-55xxx-dvbt-02.fw:
>
> smscore_load_firmware_family2: line: 986: sending
> MSG_SMS_DATA_VALIDITY_REQ expecting 0xcfed1755
> smscore_onresponse: line: 1565: MSG_SMS_DATA_VALIDITY_RES, checksum = 0xcfed1755
>
> This error is reported for 32/64 bit systems.
>

If you need more details please let me know.
