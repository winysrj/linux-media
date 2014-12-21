Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:51167 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaLUAGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 19:06:38 -0500
Message-ID: <54960F0C.5020506@southpole.se>
Date: Sun, 21 Dec 2014 01:06:36 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: crope@iki.fi
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC][PATCH] mn88472: add support for the mn88473 demod
References: <1419119853-29452-1-git-send-email-benjamin@southpole.se>
In-Reply-To: <1419119853-29452-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is what mn88473 support in the mn88472 demod driver could look 
like. The code is untested but will look similar in the final version. 
It is also possible to let the driver figure out the demod version from 
the 0xff register. Then the users would not need to set that parameter. 
Same goes to the xtal parameter.

So does the mn88473 support look ok and should the driver figure out 
what demod is connected ?

MvH
Benjamin Larsson
