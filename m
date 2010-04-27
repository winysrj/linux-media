Return-path: <linux-media-owner@vger.kernel.org>
Received: from spamtitan2.stone-is.org ([87.238.161.121]:55282 "EHLO
	out2.stone-is.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754021Ab0D0Q1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 12:27:03 -0400
Received: from localhost (unknown [127.0.0.1])
	by out2.stone-is.org (Postfix) with ESMTP id A13F3E383ED
	for <linux-media@vger.kernel.org>; Tue, 27 Apr 2010 15:46:01 +0000 (UTC)
Received: from out2.stone-is.org ([127.0.0.1])
	by localhost (out2.stone-is.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O35HeH1Wnzpz for <linux-media@vger.kernel.org>;
	Tue, 27 Apr 2010 17:45:47 +0200 (CEST)
Received: from be11.1-eurohost.com (vz02.stone-is.net [87.238.162.138])
	by out2.stone-is.org (Postfix) with ESMTP id 8DDEF1580445
	for <linux-media@vger.kernel.org>; Tue, 27 Apr 2010 17:21:54 +0200 (CEST)
Message-ID: <20100427172933.gas5iopk2sk0w0kw@webmail.diode.be>
Date: Tue, 27 Apr 2010 17:29:33 +0200
From: Tiemen <maillist@diode.be>
To: linux-media@vger.kernel.org
Subject: support for micron MT9[M/T]xxx sensors with CY7C68013 (Cypress
	FX2) bridge cameras
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello developers,

I recently got hold of two USB c-mount cameras with Micron CMOS chips.  
One is a Mightex MCE-B013 (MT9M001 sensor), the other a development  
kit with MT9T031 sensor. I had hoped to use these with v4l2, as  
drivers for these sensors are in the code tree. Initial attemps to use  
these with the sn9c20x driver failed, and the reason became clear when  
I inspected the hardware: both cameras use the CY7C68013A (a.k.a  
EZ-USB FX2) bridge. v4l supports this chip when it is combined with  
Omnivision sensors, cfr. `OVFX2' in ov519.c.

Now, the LinuxTV Wiki, section `How to add support for a device',  
suggests that support attempts might be more feasible if drivers for  
individual components are available. But I am not sure if this also  
applies for a microcontroller like the FX2. Thus I wanted to ask:

- Is somebody already working on support for such cameras?

- Can it be assumed that the FX2 will function the same, regardless of  
which sensor (Micron vs. Omnivision) is attached to it?


Thank you,

Tiemen
