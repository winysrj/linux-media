Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51941 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab1JOMLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 08:11:41 -0400
Received: by wwe6 with SMTP id 6so116525wwe.1
        for <linux-media@vger.kernel.org>; Sat, 15 Oct 2011 05:11:39 -0700 (PDT)
From: Antonio Marcos =?utf-8?q?L=C3=B3pez_Alonso?=
	<amlopezalonso@gmail.com>
Reply-To: amlopezalonso@gmail.com
To: linux-media@vger.kernel.org
Subject: dib0700: Nova-T-500 remote - IR only respond to button releases
Date: Sat, 15 Oct 2011 13:02:07 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110151302.07525.amlopezalonso@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Since upgrading from Mythbuntu 10.04 to 11.04, dib0700-1.20.fw started to 
behave differently. It happens that my Nova-T-500 IR sensor is only responding 
to button releases on the remote control (shown by irw).

Replacing 1.20.fw with 1.10.fw restores the proper behavior (other issues 
arise though) so I'm pretty sure this has something to do with the firmware 
itself.

Any suggestion on how can I debug this further?

Thanks in advance,
Antonio
