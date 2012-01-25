Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm5-vm2.bullet.mail.ne1.yahoo.com ([98.138.90.153]:36158 "HELO
	nm5-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754144Ab2AYMul convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 07:50:41 -0500
References: 
Message-ID: <1327495458.95081.YahooMailNeo@web125310.mail.ne1.yahoo.com>
Date: Wed, 25 Jan 2012 04:44:18 -0800 (PST)
From: Abby Cedar <abbycedar@yahoo.com.au>
Reply-To: Abby Cedar <abbycedar@yahoo.com.au>
Subject: Dvico FusionHDTV DVB-T Pro poweroff mode failure, err = -6
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Has anyone got power management to work with CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO? I've enabled debug and am seeing the following in the kernel log:
... "xc2028 1-0061: Putting xc2028/3028 into poweroff mode."
... "xc2028 1-0061: Error on line 1212: -6"

I could add ctl->disable_power_mgmt = 1; to cx88-cards.c to disable it and therefore the error message but am wondering why it isn't working. Is it even supported on this card?

What am I missing out on by disabling poweroff mode? Is there a noticable power consumption (watts) difference?

Please let me know how I can help fix this.

-- 
Abby
