Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm8-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.65]:34729 "HELO
	nm8-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751854Ab2A3BVs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jan 2012 20:21:48 -0500
References: <1327495458.95081.YahooMailNeo@web125310.mail.ne1.yahoo.com>
Message-ID: <1327886180.18009.YahooMailNeo@web125319.mail.ne1.yahoo.com>
Date: Sun, 29 Jan 2012 17:16:20 -0800 (PST)
From: Abby Cedar <abbycedar@yahoo.com.au>
Reply-To: Abby Cedar <abbycedar@yahoo.com.au>
Subject: Re: Dvico FusionHDTV DVB-T Pro poweroff mode failure, err = -6
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1327495458.95081.YahooMailNeo@web125310.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RegSpy showed incorrect GPIOs. I have included a patch that fixes this and the no sound on composite audio bugs here
https://bugzilla.kernel.org/show_bug.cgi?id=42681

-- 

Abby



----- Original Message -----
From: Abby Cedar <abbycedar@yahoo.com.au>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: 
Sent: Wednesday, 25 January 2012 11:44 PM
Subject: Dvico FusionHDTV DVB-T Pro poweroff mode failure, err = -6

Hi,

Has anyone got power management to work with CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO? I've enabled debug and am seeing the following in the kernel log:
... "xc2028 1-0061: Putting xc2028/3028 into poweroff mode."
... "xc2028 1-0061: Error on line 1212: -6"

I could add ctl->disable_power_mgmt = 1; to cx88-cards.c to disable it and therefore the error message but am wondering why it isn't working. Is it even supported on this card?

What am I missing out on by disabling poweroff mode? Is there a noticable power consumption (watts) difference?

Please let me know how I can help fix this.

-- 
Abby
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

