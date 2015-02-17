Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([37.247.8.11]:59396 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320AbbBQKRB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 05:17:01 -0500
Message-ID: <54E31010.10700@southpole.se>
Date: Tue, 17 Feb 2015 10:55:28 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] r820t: add DVBC profile in sysfreq_sel
References: <1423961576-15038-1-git-send-email-benjamin@southpole.se>
In-Reply-To: <1423961576-15038-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Forgot to say that with this patch the Astrometa DVB-T/T2/C usb stick 
now has working DVB-C reception at all the frequencies I have at home. 
Before it was not working at around 290-314 MHz.

The current status of the Astrometa stick is that DVB-T and DVB-C (8MHz 
tested, 6MHz testers wanted) should be working fine. DVB-T2 needs 
working pid filters before it can work properly.

MvH
Benjamin Larsson
